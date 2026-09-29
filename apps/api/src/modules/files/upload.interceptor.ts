import type { MulterOptions } from "@nestjs/platform-express/multer/interfaces/multer-options.interface";

import { CallHandler, ExecutionContext, Injectable, NestInterceptor } from "@nestjs/common";
import { FileInterceptor } from "@nestjs/platform-express";
import { Role } from "@repo/db";

/** Max upload size for regular users (avatars, submissions). Admins have no limit. */
export const USER_UPLOAD_LIMIT_BYTES = 25 * 1024 * 1024;

/**
 * Browsers send `filename="…"` as raw UTF-8, but multer decodes it as latin1 by
 * default, turning "Eylül" into "EylÃ¼l". Nest's type omits `defParamCharset`,
 * but the options are passed straight through to multer.
 */
export const uploadOptions = { defParamCharset: "utf8" } as MulterOptions;

const AdminUpload = FileInterceptor("file", uploadOptions);
const UserUpload = FileInterceptor("file", {
  ...uploadOptions,
  limits: { fileSize: USER_UPLOAD_LIMIT_BYTES },
});

/**
 * Single-file upload (`file` field) whose size limit depends on the caller:
 * none for admins, {@link USER_UPLOAD_LIMIT_BYTES} for everyone else. Guards run
 * before interceptors, so `request.user` is already resolved by `AuthGuard`.
 * Oversized uploads are rejected by multer with 413 Payload Too Large.
 */
@Injectable()
export class RoleBasedUploadInterceptor implements NestInterceptor {
  private readonly admin = new AdminUpload();
  private readonly user = new UserUpload();

  intercept(context: ExecutionContext, next: CallHandler) {
    const roles: string[] | undefined = context.switchToHttp().getRequest().user?.roles;
    const upload = roles?.includes(Role.ADMIN) ? this.admin : this.user;
    return upload.intercept(context, next);
  }
}
