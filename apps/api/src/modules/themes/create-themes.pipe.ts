import { Injectable, ParseArrayPipe, PipeTransform, ValidationPipe } from "@nestjs/common";

import { CreateThemeDto } from "./dto/create-theme.dto";

/**
 * `POST /themes` takes one theme or an array of them. The global
 * ValidationPipe can't validate that union, so validate each item here.
 */
@Injectable()
export class CreateThemesPipe implements PipeTransform<unknown, Promise<CreateThemeDto[]>> {
  private readonly one = new ValidationPipe({ whitelist: true, transform: true });
  private readonly many = new ParseArrayPipe({ items: CreateThemeDto, whitelist: true });

  async transform(value: unknown): Promise<CreateThemeDto[]> {
    if (Array.isArray(value)) {
      return this.many.transform(value, { type: "body" });
    }
    return [await this.one.transform(value, { type: "body", metatype: CreateThemeDto })];
  }
}
