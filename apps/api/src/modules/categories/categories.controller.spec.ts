import "reflect-metadata";
import { CategoriesController } from "./categories.controller";

describe("CategoriesController.findAll", () => {
  const findAll = jest.fn();
  const controller = new CategoriesController({ findAll } as any);

  beforeEach(() => jest.clearAllMocks());

  it("turns ?published=true into the published-only filter", () => {
    controller.findAll({ where: { published: "true" }, take: undefined });

    expect(findAll).toHaveBeenCalledWith({ where: {}, take: undefined }, true);
  });

  it("lists every category by default", () => {
    controller.findAll({ where: {}, take: 10 });

    expect(findAll).toHaveBeenCalledWith({ where: {}, take: 10 }, false);
  });
});
