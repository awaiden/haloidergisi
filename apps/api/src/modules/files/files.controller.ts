import {
  Body,
  Controller,
  Delete,
  Post,
  UploadedFile,
  UseGuards,
  UseInterceptors,
} from "@nestjs/common";

import { Roles } from "@/decorators";
import { AuthGuard } from "@/guards";

import { FilesService } from "./files.service";
import { RoleBasedUploadInterceptor } from "./upload.interceptor";

@Controller("files")
@UseGuards(AuthGuard)
export class FilesController {
  constructor(private readonly filesService: FilesService) {}

  /** Any signed-in user (avatars, submissions); size limit depends on role. */
  @Post()
  @UseInterceptors(RoleBasedUploadInterceptor)
  upload(@UploadedFile() file: Express.Multer.File) {
    return this.filesService.upload(file);
  }

  @Delete()
  @Roles("ADMIN")
  remove(@Body("key") key: string) {
    return this.filesService.remove(key);
  }
}
