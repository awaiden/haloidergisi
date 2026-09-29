import type { Role, User } from "@repo/db";

import { createParamDecorator, SetMetadata } from "@nestjs/common";

import { METADATA_KEY } from "@/constants";

export const AllowAnonymous = () => SetMetadata(METADATA_KEY.PUBLIC, true);

export const OptionalAuth = () => SetMetadata(METADATA_KEY.OPTIONAL_AUTH, true);

export const Roles = (...roles: Role[]) => SetMetadata(METADATA_KEY.ROLES, roles);

/** The opaque bearer token that authenticated the current request. */
export const SessionToken = createParamDecorator((_data: unknown, ctx): string | undefined => {
  return ctx.switchToHttp().getRequest().sessionToken;
});

export const Auth = createParamDecorator((data: keyof User, ctx): User | undefined => {
  const request = ctx.switchToHttp().getRequest();
  return data ? request.user?.[data as keyof User] : request.user;
});
