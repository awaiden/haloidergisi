import { BadRequestException } from "@nestjs/common";
import argon2 from "argon2";

import { AuthService } from "./auth.service";

describe("AuthService.login", () => {
  const findFirst = jest.fn();
  const update = jest.fn();
  const generateToken = jest.fn().mockResolvedValue({ token: "tok" });

  const service = new AuthService(
    { db: { query: { users: { findFirst } }, update } } as any,
    { generateToken } as any,
    {} as any,
    {} as any,
    {} as any,
  );

  beforeEach(() => jest.clearAllMocks());

  it("issues a token for a correct password", async () => {
    findFirst.mockResolvedValue({ id: "u1", password: await argon2.hash("secret1") });

    await expect(service.login({ email: "a@b.co", password: "secret1" })).resolves.toEqual({
      token: "tok",
    });
    expect(generateToken).toHaveBeenCalledWith("u1");
  });

  it("rejects a wrong password", async () => {
    findFirst.mockResolvedValue({ id: "u1", password: await argon2.hash("secret1") });

    await expect(service.login({ email: "a@b.co", password: "wrong!" })).rejects.toThrow(
      BadRequestException,
    );
    expect(generateToken).not.toHaveBeenCalled();
  });

  it("rejects an unknown email", async () => {
    findFirst.mockResolvedValue(undefined);

    await expect(service.login({ email: "x@b.co", password: "secret1" })).rejects.toThrow(
      BadRequestException,
    );
  });

  it("forgot-password gives the same answer for unknown emails and sends nothing", async () => {
    const emit = jest.fn();
    const withEvents = new AuthService(
      { db: { query: { users: { findFirst } } } } as any,
      {} as any,
      {} as any,
      { sign: jest.fn().mockReturnValue("jwt") } as any,
      { emit } as any,
    );

    findFirst.mockResolvedValue(undefined);
    await expect(withEvents.initiatePasswordReset("nobody@b.co")).resolves.toEqual({
      success: true,
    });
    expect(emit).not.toHaveBeenCalled();

    findFirst.mockResolvedValue({ id: "u1", profile: { name: "Ayşe" } });
    await expect(withEvents.initiatePasswordReset("a@b.co")).resolves.toEqual({
      success: true,
    });
    expect(emit).toHaveBeenCalledTimes(1);
  });

  it("does not let anyone claim an account that has no password", async () => {
    findFirst.mockResolvedValue({ id: "u1", password: null });

    await expect(service.login({ email: "a@b.co", password: "attacker-chosen" })).rejects.toThrow(
      BadRequestException,
    );
    expect(update).not.toHaveBeenCalled();
    expect(generateToken).not.toHaveBeenCalled();
  });

  it("reset-password sets the new password and revokes every session", async () => {
    const update = jest.fn();
    const removeAllForUser = jest.fn();
    const withReset = new AuthService(
      {} as any,
      { removeAllForUser } as any,
      { update } as any,
      { verify: jest.fn().mockReturnValue({ sub: "u1", type: "reset_password" }) } as any,
      {} as any,
    );

    await expect(
      withReset.resetPassword({ token: "jwt", newPassword: "new-secret" }),
    ).resolves.toEqual({ success: true });
    expect(update).toHaveBeenCalledWith("u1", { password: "new-secret" });
    expect(removeAllForUser).toHaveBeenCalledWith("u1");
  });

  it("reset-password rejects an invalid link without touching anything", async () => {
    const update = jest.fn();
    const removeAllForUser = jest.fn();
    const withReset = new AuthService(
      {} as any,
      { removeAllForUser } as any,
      { update } as any,
      {
        verify: jest.fn(() => {
          throw new Error("jwt expired");
        }),
      } as any,
      {} as any,
    );

    await expect(
      withReset.resetPassword({ token: "bad", newPassword: "new-secret" }),
    ).rejects.toThrow(BadRequestException);
    expect(update).not.toHaveBeenCalled();
    expect(removeAllForUser).not.toHaveBeenCalled();
  });
});
