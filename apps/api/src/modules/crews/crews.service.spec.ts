import { CrewsService } from "./crews.service";

describe("CrewsService.findAll", () => {
  it("never lets a fields include replace the public member selection", async () => {
    const findMany = jest.fn().mockResolvedValue([]);
    const service = new CrewsService({
      db: {
        query: { crews: { findMany } },
        select: () => ({ from: () => ({ where: async () => [{ total: 0 }] }) }),
      },
    } as any);

    await service.findAll({ include: { users: true }, take: 10 });

    expect(findMany.mock.calls[0][0].with.users).toEqual({
      columns: { id: true },
      with: { profile: true },
    });
  });
});
