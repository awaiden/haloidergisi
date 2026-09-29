import "reflect-metadata";
import { applyQuery } from "@/utils";

import { PostsService } from "./posts.service";

jest.mock("@/utils", () => ({
  ...jest.requireActual("@/utils"),
  applyQuery: jest.fn(() => ({ where: undefined, orderBy: undefined, limit: 10, offset: 0 })),
}));

describe("PostsService.findAll", () => {
  const service = new PostsService(
    {
      db: {
        query: { posts: { findMany: jest.fn().mockResolvedValue([]) } },
        select: () => ({ from: () => ({ where: async () => [{ total: 0 }] }) }),
      },
    } as any,
    {} as any,
  );

  beforeEach(() => jest.clearAllMocks());

  it("forces PUBLISHED for public callers, overriding a requested status", async () => {
    await service.findAll({ where: { status: "DRAFT", categoryId: "c1" }, take: 10 }, true);

    expect(applyQuery).toHaveBeenCalledWith(
      expect.anything(),
      expect.objectContaining({ where: { status: "PUBLISHED", categoryId: "c1" } }),
    );
  });

  it("leaves the admin query untouched", async () => {
    const query = { where: { status: "DRAFT" }, take: 10 };

    await service.findAll(query, false);

    expect(applyQuery).toHaveBeenCalledWith(expect.anything(), query);
  });
});
