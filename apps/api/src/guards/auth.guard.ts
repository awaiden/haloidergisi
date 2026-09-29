import { CanActivate, ExecutionContext } from "@nestjs/common";
import { ForbiddenException, Inject, Injectable, UnauthorizedException } from "@nestjs/common";
import { Reflector } from "@nestjs/core";
import { tokens } from "@repo/db";
import { eq } from "drizzle-orm";

import { METADATA_KEY } from "@/constants";
import { DrizzleService } from "@/database";

@Injectable()
export class AuthGuard implements CanActivate {
  constructor(
    @Inject(Reflector)
    private readonly reflector: Reflector,
    private readonly drizzle: DrizzleService,
  ) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const isAllowAnonymous = this.reflector.getAllAndOverride<boolean>(METADATA_KEY.PUBLIC, [
      context.getHandler(),
      context.getClass(),
    ]);

    const request = context.switchToHttp().getRequest();
    const authHeader = request.headers["authorization"];
    const token = this.extractTokenFromHeader(authHeader);

    if (!token && isAllowAnonymous) return true;

    if (token) {
      const tokenDoc = await this.drizzle.db.query.tokens.findFirst({
        where: eq(tokens.token, token),
        with: { user: { with: { profile: true } } },
      });

      request.user = tokenDoc?.user;
      if (tokenDoc) request.sessionToken = token;
    }

    const isOptionalAuth = this.reflector.getAllAndOverride<boolean>(METADATA_KEY.OPTIONAL_AUTH, [
      context.getHandler(),
      context.getClass(),
    ]);

    if (!request.user && (isAllowAnonymous || isOptionalAuth)) {
      return true;
    }

    if (!request.user) {
      throw new UnauthorizedException("Authentication required.");
    }

    const requiredRoles = this.reflector.getAllAndOverride<string[]>(METADATA_KEY.ROLES, [
      context.getHandler(),
      context.getClass(),
    ]);

    if (requiredRoles && !this.matchRoles(request.user.roles, requiredRoles)) {
      throw new ForbiddenException("Insufficient permissions.");
    }

    return true;
  }

  extractTokenFromHeader(header?: string): string | null {
    const [type, token] = header?.split(" ") ?? [];
    return type === "Bearer" && token ? token : null;
  }

  matchRoles(userRoles: string[], requiredRoles: string[]): boolean {
    return requiredRoles.every((role) => userRoles.includes(role));
  }
}
