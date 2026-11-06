import { BadRequestException, Injectable, Logger } from "@nestjs/common";
import { JwtService } from "@nestjs/jwt";
import { ProviderType, providers, users } from "@repo/db";
import { decodeIdToken, generateCodeVerifier, generateState, Google } from "arctic";
import argon2 from "argon2";
import crypto from "crypto";
import { and, eq } from "drizzle-orm";

import { DrizzleService } from "@/database";

import { TokensService } from "../tokens/tokens.service";
import { UsersService } from "../users/users.service";

export type GooglePlatform = "web" | "mobile";

/** httpOnly cookie that carries the signed flow state between start and callback. */
export const GOOGLE_FLOW_COOKIE = "google_oauth";
export const GOOGLE_FLOW_TTL_SECONDS = 10 * 60;

/** Deep link the mobile app listens on (`flutter_web_auth_2`). */
export const MOBILE_CALLBACK_URL = "halo://auth-callback";

interface FlowState {
  type: "google_flow";
  state: string;
  verifier: string;
  platform: GooglePlatform;
  /** Mobile only: S256 challenge of the app's own verifier (see `exchange`). */
  challenge?: string;
  /** Set when an existing user links Google instead of signing in. */
  linkUserId?: string;
}

/** RFC 7636 S256: base64url(sha256(verifier)). */
export function s256Challenge(verifier: string) {
  return crypto.createHash("sha256").update(verifier).digest("base64url");
}

interface GoogleClaims {
  sub: string;
  email?: string;
  email_verified?: boolean;
  name?: string;
}

/**
 * Google sign-in with arctic (authorization code + PKCE), as a server-side
 * redirect flow shared by web and mobile:
 *
 * 1. `start`: the browser hits `GET /auth/google`; we keep `state` and the PKCE
 *    verifier in a signed, httpOnly cookie and redirect to Google.
 * 2. `finish`: Google redirects to `GET /auth/google/callback`; we check
 *    `state` against the cookie (login-CSRF protection), exchange the code and
 *    find or create the user, then send the browser back to the client with a
 *    short-lived one-time *handoff code* (never the session token itself).
 * 3. `exchange`: the client trades the handoff code for a session token. The
 *    mobile app must also present the verifier behind the challenge it sent in
 *    step 1, so an app that intercepts the `halo://` deep link can't use it.
 */
@Injectable()
export class AuthGoogleService {
  private readonly logger = new Logger(AuthGoogleService.name);
  private readonly google = new Google(
    process.env.GOOGLE_CLIENT_ID!,
    process.env.GOOGLE_CLIENT_SECRET!,
    // Must be this API's `/auth/google/callback`, registered in Google Cloud.
    process.env.GOOGLE_REDIRECT_URI!,
  );

  constructor(
    private readonly drizzle: DrizzleService,
    private readonly usersService: UsersService,
    private readonly tokensService: TokensService,
    private readonly jwtService: JwtService,
  ) {}

  /** Public origin of this API, derived from the registered redirect URI. */
  get apiOrigin() {
    return new URL(process.env.GOOGLE_REDIRECT_URI!).origin;
  }

  /** Web app origin the browser returns to (`WEB_URL` for local dev). */
  private get webOrigin() {
    return (process.env.WEB_URL ?? process.env.APP_URL!).replace(/\/$/, "");
  }

  /** Step 1: returns the Google URL and the signed flow cookie value. */
  start(params: { platform?: string; challenge?: string; ticket?: string }) {
    const platform: GooglePlatform = params.platform === "mobile" ? "mobile" : "web";
    if (platform === "mobile" && !/^[A-Za-z0-9_-]{43}$/.test(params.challenge ?? "")) {
      throw new BadRequestException("Missing or invalid PKCE challenge.");
    }

    let linkUserId: string | undefined;
    if (params.ticket) {
      linkUserId = this.verify<{ sub: string }>(params.ticket, "google_link").sub;
    }

    const state = generateState();
    const verifier = generateCodeVerifier();
    const url = this.google.createAuthorizationURL(state, verifier, ["openid", "profile", "email"]);
    url.searchParams.set("prompt", "select_account");

    const flow: FlowState = {
      type: "google_flow",
      state,
      verifier,
      platform,
      challenge: platform === "mobile" ? params.challenge : undefined,
      linkUserId,
    };
    const flowCookie = this.jwtService.sign(flow, { expiresIn: GOOGLE_FLOW_TTL_SECONDS });
    return { url: url.toString(), flowCookie };
  }

  /** Step 2: handles Google's redirect; returns where to send the browser next. */
  async finish(params: {
    code?: string;
    state?: string;
    error?: string;
    flowCookie?: string;
  }): Promise<string> {
    let flow: FlowState | undefined;
    try {
      flow = this.verify<FlowState>(params.flowCookie, "google_flow");
      if (params.error) throw new BadRequestException("Google girişi iptal edildi.");
      if (!params.code || !params.state || params.state !== flow.state) {
        throw new BadRequestException("Oturum doğrulanamadı. Lütfen tekrar deneyin.");
      }

      const claims = await this.claimsFor(params.code, flow.verifier);

      if (flow.linkUserId) {
        await this.link(flow.linkUserId, claims);
        return this.clientUrl(flow.platform, { linked: "1" });
      }

      const userId = await this.findOrCreateUser(claims);
      const handoff = this.jwtService.sign(
        { sub: userId, type: "google_handoff", challenge: flow.challenge },
        { expiresIn: "2m" },
      );
      return this.clientUrl(flow.platform, { code: handoff });
    } catch (error) {
      const message =
        error instanceof BadRequestException ? error.message : "Google ile giriş başarısız oldu.";
      if (!(error instanceof BadRequestException)) this.logger.error(error);
      return this.clientUrl(flow?.platform ?? "web", { error: message });
    }
  }

  /** Step 3: trades a handoff code for a session token. */
  async exchange(code: string, verifier?: string) {
    const handoff = this.verify<{ sub: string; challenge?: string }>(code, "google_handoff");
    if (handoff.challenge) {
      if (!verifier || s256Challenge(verifier) !== handoff.challenge) {
        throw new BadRequestException("Geçersiz doğrulama kodu.");
      }
    }
    const { token } = await this.tokensService.generateToken(handoff.sub);
    return { token };
  }

  /** For signed-in users: a URL that starts a flow linking Google to them. */
  createLinkUrl(userId: string, platform?: string, challenge?: string) {
    const ticket = this.jwtService.sign({ sub: userId, type: "google_link" }, { expiresIn: "2m" });
    const url = new URL("/auth/google", this.apiOrigin);
    url.searchParams.set("ticket", ticket);
    url.searchParams.set("platform", platform === "mobile" ? "mobile" : "web");
    if (challenge) url.searchParams.set("challenge", challenge);
    return { url: url.toString() };
  }

  private async claimsFor(code: string, verifier: string): Promise<GoogleClaims> {
    const tokens = await this.google.validateAuthorizationCode(code, verifier);
    // The ID token comes straight from Google's token endpoint over TLS in the
    // code exchange, so decoding (without re-verifying the signature) is enough.
    const claims = decodeIdToken(tokens.idToken()) as GoogleClaims;
    if (!claims.sub || !claims.email || claims.email_verified !== true) {
      throw new BadRequestException("Google hesabınızın e-posta adresi doğrulanmamış.");
    }
    return claims;
  }

  private async findOrCreateUser(claims: GoogleClaims): Promise<string> {
    const provider = await this.drizzle.db.query.providers.findFirst({
      where: and(eq(providers.providerId, claims.sub), eq(providers.provider, ProviderType.GOOGLE)),
    });
    if (provider) return provider.userId;

    const existingUser = await this.drizzle.db.query.users.findFirst({
      where: eq(users.email, claims.email!),
    });
    if (existingUser) {
      await this.linkExistingAccount(existingUser, claims);
      return existingUser.id;
    }

    const user = await this.usersService.create({
      email: claims.email!,
      name: claims.name || claims.email!.split("@")[0],
      // Unusable random password; the account signs in with Google.
      password: crypto.randomBytes(32).toString("hex"),
      emailVerifiedAt: new Date(),
    });
    await this.drizzle.db.insert(providers).values({
      provider: ProviderType.GOOGLE,
      providerId: claims.sub,
      userId: user.id,
    });
    return user.id;
  }

  /**
   * Google vouches for the (verified) email, so signing in with it reaches the
   * account registered under that email. If that account never verified its
   * email, whoever registered it may not own the address (someone could sign
   * up with a victim's email first and wait for them to use Google): the
   * password and existing sessions are revoked before linking, so only the
   * email's owner keeps access.
   */
  private async linkExistingAccount(
    user: { id: string; emailVerifiedAt: Date | null },
    claims: GoogleClaims,
  ) {
    if (!user.emailVerifiedAt) {
      await this.drizzle.db
        .update(users)
        .set({
          password: await argon2.hash(crypto.randomBytes(32).toString("hex")),
          emailVerifiedAt: new Date(),
        })
        .where(eq(users.id, user.id));
      await this.tokensService.removeAllForUser(user.id);
    }
    await this.drizzle.db.insert(providers).values({
      provider: ProviderType.GOOGLE,
      providerId: claims.sub,
      userId: user.id,
    });
  }

  private async link(userId: string, claims: GoogleClaims) {
    const existing = await this.drizzle.db.query.providers.findFirst({
      where: and(eq(providers.providerId, claims.sub), eq(providers.provider, ProviderType.GOOGLE)),
    });
    if (existing?.userId === userId) return;
    if (existing) {
      throw new BadRequestException("Bu Google hesabı başka bir kullanıcıya bağlı.");
    }
    await this.drizzle.db.insert(providers).values({
      provider: ProviderType.GOOGLE,
      providerId: claims.sub,
      userId,
    });
  }

  private clientUrl(platform: GooglePlatform, params: Record<string, string>) {
    const query = new URLSearchParams(params).toString();
    // Web: fragment, so the code never reaches server logs or Referer headers.
    return platform === "mobile"
      ? `${MOBILE_CALLBACK_URL}?${query}`
      : `${this.webOrigin}/google-callback#${query}`;
  }

  private verify<T extends object>(token: string | undefined, type: string): T {
    try {
      const payload = this.jwtService.verify<T & { type?: string }>(token ?? "");
      if (payload.type !== type) throw new Error("wrong token type");
      return payload;
    } catch {
      throw new BadRequestException("Oturum süresi doldu. Lütfen tekrar deneyin.");
    }
  }
}
