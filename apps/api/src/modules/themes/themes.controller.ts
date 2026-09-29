import { Body, Controller, Delete, Get, Param, Patch, Post, UseGuards } from "@nestjs/common";

import { AllowAnonymous, Roles } from "@/decorators";
import { AuthGuard } from "@/guards";

import { CreateThemesPipe } from "./create-themes.pipe";
import { CreateThemeDto } from "./dto/create-theme.dto";
import { UpdateThemeDto } from "./dto/update-theme.dto";
import { ThemesService } from "./themes.service";

@Controller("themes")
@UseGuards(AuthGuard)
export class ThemesController {
  constructor(private readonly themesService: ThemesService) {}

  @Post()
  @Roles("ADMIN")
  create(@Body(CreateThemesPipe) themes: CreateThemeDto[]) {
    return this.themesService.create(themes);
  }

  @Get("archive")
  @AllowAnonymous()
  findGrouped() {
    return this.themesService.findGrouped();
  }

  @Get()
  @AllowAnonymous()
  findAll() {
    return this.themesService.findAll();
  }

  @Get(":id")
  @AllowAnonymous()
  findOne(@Param("id") id: string) {
    return this.themesService.findOne(id);
  }

  @Patch(":id")
  @Roles("ADMIN")
  update(@Param("id") id: string, @Body() updateThemeDto: UpdateThemeDto) {
    return this.themesService.update(id, updateThemeDto);
  }

  @Delete(":id")
  @Roles("ADMIN")
  remove(@Param("id") id: string) {
    return this.themesService.remove(id);
  }
}
