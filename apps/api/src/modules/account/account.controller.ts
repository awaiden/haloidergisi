import { Body, Controller, Delete, Get, Patch, Post, UseGuards } from "@nestjs/common";

import { Auth, Roles, SessionToken } from "@/decorators";
import { AuthGuard } from "@/guards";

import { ChangePasswordDto, UpdateAccountDto, UpdateNotificationsDto } from "./account.dto";
import { AccountService } from "./account.service";

@Controller("account")
@UseGuards(AuthGuard)
@Roles("USER")
export class AccountController {
  constructor(private readonly accountService: AccountService) {}

  @Get("notification-settings")
  getNotifications(@Auth("id") userId: string) {
    return this.accountService.getNotifications(userId);
  }

  @Patch("notification-settings")
  updateNotifications(
    @Auth("id") userId: string,
    @Body() updateNotificationsDto: UpdateNotificationsDto,
  ) {
    return this.accountService.updateNotifications(userId, updateNotificationsDto);
  }

  @Get()
  findOne(@Auth("id") userId: string) {
    return this.accountService.findOne(userId);
  }

  @Get("providers")
  getProviders(@Auth("id") userId: string) {
    return this.accountService.getProviders(userId);
  }

  @Delete("providers/:providerId")
  removeProvider(@Auth("id") userId: string, @Body("providerId") providerId: string) {
    return this.accountService.removeProvider(userId, providerId);
  }

  @Patch("password")
  changePassword(
    @Auth("id") userId: string,
    @SessionToken() token: string,
    @Body() changePasswordDto: ChangePasswordDto,
  ) {
    return this.accountService.changePassword(userId, changePasswordDto, token);
  }

  @Patch()
  update(@Auth("id") userId: string, @Body() updateAccountDto: UpdateAccountDto) {
    return this.accountService.update(userId, updateAccountDto);
  }

  @Delete()
  remove(@Auth("id") userId: string) {
    return this.accountService.remove(userId);
  }

  @Post("request-email-verification")
  requestEmailVerification(@Auth("id") userId: string) {
    return this.accountService.requestEmailVerification(userId);
  }

  @Post("verify-email")
  verifyEmail(@Auth("id") userId: string, @Body("token") token: string) {
    return this.accountService.verifyEmail(userId, token);
  }
}
