import type { Request, Response } from "express";

import { Body, Controller, Get, Post, Query, Req, Res, UseGuards } from "@nestjs/common";

import { AllowAnonymous, Auth, Roles } from "@/decorators";
import { AuthGuard } from "@/guards";

import {
  AuthGoogleService,
  GOOGLE_FLOW_COOKIE,
  GOOGLE_FLOW_TTL_SECONDS,
} from "./auth-google.service";

/** Google sign-in flow; see `AuthGoogleService` for the steps. */
@Controller("auth/google")
export class AuthGoogleController {
  constructor(private readonly authGoogleService: AuthGoogleService) {}

  /** Browser entry point: `?platform=web|mobile[&challenge=…][&ticket=…]`. */
  @Get()
  @AllowAnonymous()
  start(
    @Query("platform") platform: string | undefined,
    @Query("challenge") challenge: string | undefined,
    @Query("ticket") ticket: string | undefined,
    @Res() res: Response,
  ) {
    const { url, flowCookie } = this.authGoogleService.start({ platform, challenge, ticket });
    res.cookie(GOOGLE_FLOW_COOKIE, flowCookie, {
      httpOnly: true,
      // Lax: the cookie must survive Google's top-level redirect back to us.
      sameSite: "lax",
      secure: this.authGoogleService.apiOrigin.startsWith("https:"),
      path: "/auth/google",
      maxAge: GOOGLE_FLOW_TTL_SECONDS * 1000,
    });
    res.redirect(url);
  }

  /** Google redirects here (the registered `GOOGLE_REDIRECT_URI`). */
  @Get("callback")
  @AllowAnonymous()
  async callback(
    @Query("code") code: string | undefined,
    @Query("state") state: string | undefined,
    @Query("error") error: string | undefined,
    @Req() req: Request,
    @Res() res: Response,
  ) {
    const target = await this.authGoogleService.finish({
      code,
      state,
      error,
      flowCookie: readCookie(req, GOOGLE_FLOW_COOKIE),
    });
    res.clearCookie(GOOGLE_FLOW_COOKIE, { path: "/auth/google" });
    res.redirect(target);
  }

  /** Trades the one-time handoff code for a session token. */
  @Post("exchange")
  @AllowAnonymous()
  exchange(@Body("code") code: string, @Body("verifier") verifier?: string) {
    return this.authGoogleService.exchange(code, verifier);
  }

  /** Signed-in users: returns a URL that links Google to their account. */
  @Post("link")
  @UseGuards(AuthGuard)
  @Roles("USER")
  link(
    @Auth("id") userId: string,
    @Body("platform") platform?: string,
    @Body("challenge") challenge?: string,
  ) {
    return this.authGoogleService.createLinkUrl(userId, platform, challenge);
  }
}

function readCookie(req: Request, name: string): string | undefined {
  for (const part of (req.headers.cookie ?? "").split(";")) {
    const [key, ...value] = part.trim().split("=");
    if (key === name) return decodeURIComponent(value.join("="));
  }
  return undefined;
}
