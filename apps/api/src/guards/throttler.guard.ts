import type { Request } from "express";

import { Injectable } from "@nestjs/common";
import { ThrottlerGuard } from "@nestjs/throttler";

/** Stricter limit for credential and email endpoints (per client IP). */
export const AUTH_THROTTLE = { default: { limit: 10, ttl: 60_000 } };

/**
 * Rate limits per client IP. Behind Cloudflare the client address comes from
 * `CF-Connecting-IP`; otherwise from `req.ip` (honouring `trust proxy`).
 */
@Injectable()
export class ClientIpThrottlerGuard extends ThrottlerGuard {
  protected async getTracker(req: Request): Promise<string> {
    const cfIp = req.headers["cf-connecting-ip"];
    if (typeof cfIp === "string" && cfIp) return cfIp;
    return req.ip ?? req.socket.remoteAddress ?? "unknown";
  }
}
