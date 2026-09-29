import { Module } from "@nestjs/common";

import { TokensService } from "../tokens/tokens.service";
import { UsersService } from "../users/users.service";
import { AccountController } from "./account.controller";
import { AccountService } from "./account.service";

@Module({
  controllers: [AccountController],
  providers: [AccountService, UsersService, TokensService],
})
export class AccountModule {}
