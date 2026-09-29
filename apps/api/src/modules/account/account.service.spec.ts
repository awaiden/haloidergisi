import { BadRequestException } from "@nestjs/common";
import argon2 from "argon2";

import { AccountService } from "./account.service";

describe("AccountService.changePassword", () => {
  const findOne = jest.fn();
  const update = jest.fn();
  const removeAllForUser = jest.fn();
  const service = new AccountService(
    {} as any,
    { findOne, update } as any,
    {} as any,
    {} as any,
    { removeAllForUser } as any,
  );

  beforeEach(() => jest.clearAllMocks());

  it("updates the password when the current one matches", async () => {
    findOne.mockResolvedValue({ id: "u1", password: await argon2.hash("old-secret") });

    await expect(
      service.changePassword(
        "u1",
        { currentPassword: "old-secret", newPassword: "new-secret" },
        "current-token",
      ),
    ).resolves.toEqual({ success: true });
    expect(update).toHaveBeenCalledWith("u1", { password: "new-secret" });
    expect(removeAllForUser).toHaveBeenCalledWith("u1", "current-token");
  });

  it("rejects a wrong current password", async () => {
    findOne.mockResolvedValue({ id: "u1", password: await argon2.hash("old-secret") });

    await expect(
      service.changePassword("u1", { currentPassword: "nope", newPassword: "new-secret" }),
    ).rejects.toThrow(BadRequestException);
    expect(update).not.toHaveBeenCalled();
    expect(removeAllForUser).not.toHaveBeenCalled();
  });

  it("rejects (instead of crashing) when the account has no password", async () => {
    findOne.mockResolvedValue({ id: "u1", password: null });

    await expect(
      service.changePassword("u1", { currentPassword: "anything", newPassword: "new-secret" }),
    ).rejects.toThrow(BadRequestException);
    expect(update).not.toHaveBeenCalled();
  });
});
