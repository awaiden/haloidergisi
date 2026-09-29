import {
  Controller,
  ExecutionContext,
  INestApplication,
  Post,
  UploadedFile,
  UseInterceptors,
} from "@nestjs/common";
import { FileInterceptor } from "@nestjs/platform-express";
import { Test } from "@nestjs/testing";
import request from "supertest";

import { AuthGuard } from "@/guards";

import { FilesController } from "./files.controller";
import { FilesService } from "./files.service";
import { USER_UPLOAD_LIMIT_BYTES } from "./upload.interceptor";

/** Same endpoint shape with multer's defaults, to show what went wrong before. */
@Controller("default-upload")
class DefaultUploadController {
  @Post()
  @UseInterceptors(FileInterceptor("file"))
  upload(@UploadedFile() file: Express.Multer.File) {
    return file.originalname;
  }
}

describe("POST /files", () => {
  const filename = "Halo 18. Dal - Eylül 2026 Sayısı.pdf";
  const oversized = Buffer.alloc(USER_UPLOAD_LIMIT_BYTES + 1);
  let app: INestApplication;

  beforeAll(async () => {
    const moduleRef = await Test.createTestingModule({
      controllers: [FilesController, DefaultUploadController],
      providers: [
        {
          provide: FilesService,
          useValue: { upload: (file: Express.Multer.File) => file.originalname },
        },
      ],
    })
      .overrideGuard(AuthGuard)
      .useValue({
        // Stand-in for the real token lookup: the role comes from a test header.
        canActivate: (context: ExecutionContext) => {
          const req = context.switchToHttp().getRequest();
          req.user = { roles: [req.headers["x-test-role"] ?? "USER"] };
          return true;
        },
      })
      .compile();

    app = moduleRef.createNestApplication();
    await app.init();
  });

  afterAll(() => app.close());

  it("keeps UTF-8 filenames intact", async () => {
    const res = await request(app.getHttpServer())
      .post("/files")
      .attach("file", Buffer.from("%PDF-1.4"), filename);

    expect(res.text).toBe(filename);
  });

  it("multer's latin1 default is what produced the garbled names", async () => {
    const res = await request(app.getHttpServer())
      .post("/default-upload")
      .attach("file", Buffer.from("%PDF-1.4"), filename);

    expect(res.text).toBe("Halo 18. Dal - EylÃ¼l 2026 SayÄ±sÄ±.pdf");
  });

  it("rejects files over the limit for regular users", async () => {
    const res = await request(app.getHttpServer())
      .post("/files")
      .attach("file", oversized, "big.pdf");

    expect(res.status).toBe(413);
  });

  it("has no size limit for admins", async () => {
    const res = await request(app.getHttpServer())
      .post("/files")
      .set("x-test-role", "ADMIN")
      .attach("file", oversized, "big.pdf");

    expect(res.status).toBe(201);
    expect(res.text).toBe("big.pdf");
  });
});
