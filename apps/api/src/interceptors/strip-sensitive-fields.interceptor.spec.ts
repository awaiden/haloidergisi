import { stripSensitiveFields } from "./strip-sensitive-fields.interceptor";

describe("stripSensitiveFields", () => {
  it("removes password at any depth, including relations and arrays", () => {
    const createdAt = new Date("2026-01-01");
    const body = {
      items: [
        {
          id: "n1",
          author: { id: "u1", password: "$argon2id$hash", profile: { name: "Ayşe" } },
        },
      ],
      user: { id: "u2", password: "$argon2id$other", createdAt },
      meta: { total: 1 },
    };

    expect(stripSensitiveFields(body)).toEqual({
      items: [{ id: "n1", author: { id: "u1", profile: { name: "Ayşe" } } }],
      user: { id: "u2", createdAt },
      meta: { total: 1 },
    });
  });

  it("leaves primitives and non-plain objects untouched", () => {
    const date = new Date();
    const buffer = Buffer.from("x");

    expect(stripSensitiveFields("xml")).toBe("xml");
    expect(stripSensitiveFields(null)).toBeNull();
    expect(stripSensitiveFields(date)).toBe(date);
    expect(stripSensitiveFields(buffer)).toBe(buffer);
  });
});
