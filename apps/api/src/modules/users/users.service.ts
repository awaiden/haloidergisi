import { BadRequestException, Injectable, NotFoundException } from "@nestjs/common";
import { EventEmitter2 } from "@nestjs/event-emitter";
import argon2 from "argon2";

import { EMAIL_EVENTS } from "@/constants";
import { PrismaService } from "@/database";
import { PrismaQueryParams } from "@/decorators";
import { WelcomeEmailDto } from "@/services/mail.service";

import { CreateUserDto } from "./dto/create-user.dto";
import { UpdateUserDto } from "./dto/update-user.dto";

@Injectable()
export class UsersService {
  constructor(
    private readonly prismaService: PrismaService,
    private readonly eventEmitter: EventEmitter2,
  ) {}

  async create({ name, password, email, ...createUserDto }: CreateUserDto) {
    const existingUser = await this.prismaService.user.findUnique({
      where: { email },
    });

    if (existingUser) {
      throw new BadRequestException(`User with email ${email} already exists`);
    }

    const user = await this.prismaService.user.create({
      data: {
        email,
        password: await argon2.hash(password),
        ...createUserDto,
        profile: { create: { name } },
        notificationSettings: { create: {} },
      },
    });

    this.eventEmitter.emit(
      EMAIL_EVENTS.WELCOME,
      new WelcomeEmailDto({
        to: user.email,
        name: name,
      }),
    );

    return user;
  }

  async findAll(query: PrismaQueryParams) {
    const [items, total] = await this.prismaService.$transaction([
      this.prismaService.user.findMany(query),
      this.prismaService.user.count({ where: query.where }),
    ]);

    return { items, meta: { total, take: query.take, skip: query.skip } };
  }

  async findOne(id: string) {
    const user = await this.prismaService.user.findUnique({
      where: { id },
      include: { profile: true },
    });

    if (!user) {
      throw new NotFoundException(`User with ID ${id} not found`);
    }

    return user;
  }

  async update(id: string, { name, crewId, ...updateUserDto }: UpdateUserDto) {
    const user = await this.findOne(id);

    if (updateUserDto.password) {
      updateUserDto.password = await argon2.hash(updateUserDto.password);
    }

    if (updateUserDto.email && updateUserDto.email !== user.email) {
      const existingUser = await this.prismaService.user.findUnique({
        where: { email: updateUserDto.email },
      });

      if (existingUser) {
        throw new BadRequestException(`User with email ${updateUserDto.email} already exists`);
      }

      updateUserDto.emailVerifiedAt = null;
    }

    const updatedUser = await this.prismaService.user.update({
      where: { id: user.id },
      data: {
        ...updateUserDto,
        profile: {
          update: { name },
        },
        crewId: crewId ? crewId : null,
      },
    });

    return updatedUser;
  }

  async remove(id: string) {
    const user = await this.findOne(id);

    await this.prismaService.user.delete({
      where: { id: user.id },
    });

    return { success: true };
  }
}
