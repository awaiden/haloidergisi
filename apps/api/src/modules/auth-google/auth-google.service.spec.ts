import { BadRequestException } from "@nestjs/common";
import { JwtService } from "@nestjs/jwt";

import { AuthGoogleService, s256Challenge } from "./auth-google.service";

// arctic is ESM-only; Jest runs CommonJS, so stand in for the bits we use.
const validateAuthorizationCode = jest.fn();
const decodeIdToken = jest.fn();
jest.mock("arctic", () => ({
  Google: jest.fn().mockImplementation(() => ({
    createAuthorizationURL: (state: string) =>
      new URL(`https://accounts.google.com/o/oauth2/v2/auth?state=${state}`),
    validateAuthorizationCode: (...args: unknown[]) => validateAuthorizationCode(...args),
  })),
  generateState: () => "state-123",
  generateCodeVerifier: () => "google-verifier",
  decodeIdToken: (token: string) => decodeIdToken(token),
}));

const APP_VERIFIER = "app-verifier-0123456789-abcdefghijklmnopqrstuvwxyz";

describe("AuthGoogleService", () => {
  const providersFindFirst = jest.fn();
  const usersFindFirst = jest.fn();
  const insertValues = jest.fn();
  const create = jest.fn();
  const generateToken = jest.fn().mockResolvedValue({ token: "session-token" });
  const removeAllForUser = jest.fn();
  const updateSet = jest.fn(() => ({ where: jest.fn() }));
  const jwt = new JwtService({ secret: "test-secret" });
  let service: AuthGoogleService;

  beforeAll(() => {
    process.env.GOOGLE_REDIRECT_URI = "http://localhost:3000/auth/google/callback";
    process.env.WEB_URL = "http://localhost:5173";
  });

  beforeEach(() => {
    jest.clearAllMocks();
    validateAuthorizationCode.mockResolvedValue({ idToken: () => "id-token" });
    decodeIdToken.mockReturnValue({
      sub: "google-1",
      email: "ayse@example.com",
      email_verified: true,
      name: "Ayşe",
    });
    service = new AuthGoogleService(
      {
        db: {
          query: {
            providers: { findFirst: providersFindFirst },
            users: { findFirst: usersFindFirst },
          },
          insert: () => ({ values: insertValues }),
          update: () => ({ set: updateSet }),
        },
      } as any,
      { create } as any,
      { generateToken, removeAllForUser } as any,
      jwt,
    );
  });

  const challenge = s256Challenge(APP_VERIFIER);

  function startMobile() {
    return service.start({ platform: "mobile", challenge });
  }

  async function handoffFrom(target: string) {
    const url = new URL(target.replace("halo://", "halo://x/"));
    return url.searchParams;
  }

  it("mobile flows require a PKCE challenge", () => {
    expect(() => service.start({ platform: "mobile" })).toThrow(BadRequestException);
    expect(startMobile().url).toContain("state=state-123");
  });

  it("rejects a callback whose state does not match the cookie", async () => {
    const { flowCookie } = startMobile();

    const target = await service.finish({ code: "c", state: "forged", flowCookie });

    expect(target.startsWith("halo://auth-callback?error=")).toBe(true);
    expect(validateAuthorizationCode).not.toHaveBeenCalled();
  });

  it("signs up a new Google user and hands the app a code only its verifier can redeem", async () => {
    providersFindFirst.mockResolvedValue(undefined);
    usersFindFirst.mockResolvedValue(undefined);
    create.mockResolvedValue({ id: "u1" });
    const { flowCookie } = startMobile();

    const target = await service.finish({ code: "google-code", state: "state-123", flowCookie });

    expect(validateAuthorizationCode).toHaveBeenCalledWith("google-code", "google-verifier");
    expect(create).toHaveBeenCalledWith(
      expect.objectContaining({ email: "ayse@example.com", name: "Ayşe" }),
    );
    const code = (await handoffFrom(target)).get("code")!;

    await expect(service.exchange(code, "someone-elses-verifier")).rejects.toThrow(
      BadRequestException,
    );
    await expect(service.exchange(code)).rejects.toThrow(BadRequestException);
    await expect(service.exchange(code, APP_VERIFIER)).resolves.toEqual({
      token: "session-token",
    });
    expect(generateToken).toHaveBeenCalledWith("u1");
  });

  it("signs in an already linked user on the web via the URL fragment", async () => {
    providersFindFirst.mockResolvedValue({ userId: "u9" });
    const { flowCookie } = service.start({ platform: "web" });

    const target = await service.finish({ code: "c", state: "state-123", flowCookie });

    expect(target.startsWith("http://localhost:5173/google-callback#code=")).toBe(true);
    const code = new URLSearchParams(target.split("#")[1]).get("code")!;
    await expect(service.exchange(code)).resolves.toEqual({ token: "session-token" });
    expect(create).not.toHaveBeenCalled();
  });

  it("signs an existing verified account in with Google and links it", async () => {
    providersFindFirst.mockResolvedValue(undefined);
    usersFindFirst.mockResolvedValue({ id: "existing", emailVerifiedAt: new Date() });
    const { flowCookie } = service.start({ platform: "web" });

    const target = await service.finish({ code: "c", state: "state-123", flowCookie });

    const code = new URLSearchParams(target.split("#")[1]).get("code")!;
    await expect(service.exchange(code)).resolves.toEqual({ token: "session-token" });
    expect(generateToken).toHaveBeenCalledWith("existing");
    expect(insertValues).toHaveBeenCalledWith(
      expect.objectContaining({ providerId: "google-1", userId: "existing" }),
    );
    expect(create).not.toHaveBeenCalled();
    expect(updateSet).not.toHaveBeenCalled();
    expect(removeAllForUser).not.toHaveBeenCalled();
  });

  it("locks out whoever set the password on an unverified account before linking", async () => {
    providersFindFirst.mockResolvedValue(undefined);
    usersFindFirst.mockResolvedValue({ id: "squatted", emailVerifiedAt: null });
    const { flowCookie } = service.start({ platform: "web" });

    const target = await service.finish({ code: "c", state: "state-123", flowCookie });

    expect(target).toContain("#code=");
    expect(updateSet).toHaveBeenCalledWith(
      expect.objectContaining({ password: expect.any(String), emailVerifiedAt: expect.any(Date) }),
    );
    expect(removeAllForUser).toHaveBeenCalledWith("squatted");
    expect(insertValues).toHaveBeenCalledWith(expect.objectContaining({ userId: "squatted" }));
  });

  it("refuses unverified Google emails", async () => {
    decodeIdToken.mockReturnValue({ sub: "g", email: "x@example.com", email_verified: false });
    const { flowCookie } = service.start({ platform: "web" });

    const target = await service.finish({ code: "c", state: "state-123", flowCookie });

    expect(target).toContain("#error=");
    expect(create).not.toHaveBeenCalled();
  });

  it("links Google to the signed-in user from a link ticket", async () => {
    providersFindFirst.mockResolvedValue(undefined);
    const ticket = new URL(service.createLinkUrl("u5").url).searchParams.get("ticket")!;
    const { flowCookie } = service.start({ platform: "web", ticket });

    const target = await service.finish({ code: "c", state: "state-123", flowCookie });

    expect(target).toBe("http://localhost:5173/google-callback#linked=1");
    expect(insertValues).toHaveBeenCalledWith(
      expect.objectContaining({ providerId: "google-1", userId: "u5" }),
    );
  });

  it("does not accept other token types as handoff codes", async () => {
    const ticket = new URL(service.createLinkUrl("u5").url).searchParams.get("ticket")!;
    await expect(service.exchange(ticket)).rejects.toThrow(BadRequestException);
  });
});
