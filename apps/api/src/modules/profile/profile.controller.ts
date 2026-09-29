import { Body, Controller, ForbiddenException, Get, Param, Patch, UseGuards } from "@nestjs/common";
import { Role } from "@repo/db";

import { Auth, DrizzleQuery, type DrizzleQueryParams, Roles } from "@/decorators";
import { AuthGuard } from "@/guards";

import { UpdateProfileDto } from "./profile.dto";
import { ProfileGuard } from "./profile.guard";
import { ProfileService } from "./profile.service";

@Controller("profile")
@UseGuards(AuthGuard)
export class ProfileController {
  constructor(private readonly profileService: ProfileService) {}

  @Patch(":id")
  @UseGuards(ProfileGuard)
  async update(
    @Param("id") id: string,
    @Body() updateProfileDto: UpdateProfileDto,
    @Auth("roles") roles: Role[],
  ) {
    // The title ("unvan", e.g. "Editör") is assigned by admins, not self-chosen.
    // Clients that echo the current title back (older web forms) still work.
    if (updateProfileDto.title !== undefined && !roles?.includes(Role.ADMIN)) {
      const current = await this.profileService.findOne(id);
      if ((updateProfileDto.title || null) !== (current.title || null)) {
        throw new ForbiddenException("Unvan yalnızca yöneticiler tarafından değiştirilebilir.");
      }
      delete updateProfileDto.title;
    }
    return this.profileService.update(id, updateProfileDto);
  }

  // Reads are for the admin dashboard; users get their own profile via GET /account.
  // Open to everyone, `search` on `user.email` would reveal which emails are registered.
  @Get()
  @Roles(Role.ADMIN)
  findAll(@DrizzleQuery(["name", "title", "user.email"]) query: DrizzleQueryParams) {
    return this.profileService.findAll(query);
  }

  @Get(":id")
  @Roles(Role.ADMIN)
  findOne(@Param("id") id: string) {
    return this.profileService.findOne(id);
  }

  @Get("user/:userId")
  @Roles(Role.ADMIN)
  findByUserId(@Param("userId") userId: string) {
    return this.profileService.findByUserId(userId);
  }
}
