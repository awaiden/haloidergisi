import { Module } from "@nestjs/common";

import { DrizzleModule } from "@/database";

import { StatsController } from "./stats.controller";
import { StatsService } from "./stats.service";

@Module({
  imports: [DrizzleModule],
  controllers: [StatsController],
  providers: [StatsService],
})
export class StatsModule {}
