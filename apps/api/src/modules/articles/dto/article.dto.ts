import { ArticleStatus } from "@repo/db";
import { IsIn, IsNotEmpty, IsOptional, IsString, MinLength } from "class-validator";

export class CreateArticleDto {
  @IsString()
  @IsNotEmpty()
  callId: string;

  @IsString()
  @IsNotEmpty()
  @MinLength(3)
  title: string;

  @IsString()
  @IsOptional()
  content?: string;

  @IsString()
  @IsOptional()
  fileUrl?: string;
}

export class UpdateArticleDto {
  @IsString()
  @IsNotEmpty()
  @MinLength(3)
  title: string;

  @IsString()
  @IsOptional()
  content?: string;

  @IsString()
  @IsOptional()
  fileUrl?: string;
}

export class UpdateArticleStatusDto {
  @IsIn(Object.values(ArticleStatus))
  status: ArticleStatus;

  @IsString()
  @IsOptional()
  adminNote?: string;
}
