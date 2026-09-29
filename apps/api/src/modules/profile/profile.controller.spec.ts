import "reflect-metadata";
import { ForbiddenException } from "@nestjs/common";

import { ProfileController } from "./profile.controller";

describe("ProfileController.update (title is admin-managed)", () => {
  const findOne = jest.fn().mockResolvedValue({ id: "p1", title: "Yazar" });
  const update = jest.fn().mockResolvedValue({});
  const controller = new ProfileController({ findOne, update } as any);

  beforeEach(() => jest.clearAllMocks());

  it("refuses a title change from a regular user", async () => {
    await expect(
      controller.update("p1", { title: "Genel Yayın Yönetmeni" }, ["USER"]),
    ).rejects.toThrow(ForbiddenException);
    expect(update).not.toHaveBeenCalled();
  });

  it("drops an unchanged title echoed back by older clients", async () => {
    await controller.update("p1", { name: "Ayşe", title: "Yazar" }, ["USER"]);

    expect(update).toHaveBeenCalledWith("p1", { name: "Ayşe" });
  });

  it("lets regular users edit everything else", async () => {
    await controller.update("p1", { bio: "Merhaba" }, ["USER"]);

    expect(findOne).not.toHaveBeenCalled();
    expect(update).toHaveBeenCalledWith("p1", { bio: "Merhaba" });
  });

  it("lets admins set any title", async () => {
    await controller.update("p1", { title: "Editör" }, ["ADMIN"]);

    expect(update).toHaveBeenCalledWith("p1", { title: "Editör" });
  });
});
