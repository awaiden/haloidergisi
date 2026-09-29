import { Controller, Get, Query, UseGuards } from "@nestjs/common";
import { Role } from "@repo/db";

import { Roles } from "@/decorators";
import { AuthGuard } from "@/guards";

import { StatsService } from "./stats.service";

@Controller("stats")
@UseGuards(AuthGuard)
@Roles(Role.ADMIN)
export class StatsController {
  constructor(private readonly statsService: StatsService) {}

  @Get("dashboard")
  getDashboardStats(@Query("from") from?: string, @Query("to") to?: string) {
    return this.statsService.getDashboardStats({ from, to });
  }
}
