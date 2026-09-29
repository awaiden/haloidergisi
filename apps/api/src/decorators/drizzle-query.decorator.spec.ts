import { BadRequestException } from "@nestjs/common";

import { pickRelations } from "@/utils";

import { parseFields } from "./drizzle-query.decorator";

describe("parseFields", () => {
  it("accepts flat relation selections", () => {
    expect(parseFields('{"category":true,"crew":true}')).toEqual({ category: true, crew: true });
    expect(parseFields(undefined)).toBeUndefined();
  });

  it("rejects nested selections that could reach other tables", () => {
    expect(() => parseFields('{"postReactions":{"with":{"user":true}}}')).toThrow(
      BadRequestException,
    );
    expect(() => parseFields('{"users":{"columns":{"email":true}}}')).toThrow(BadRequestException);
    expect(() => parseFields('["users"]')).toThrow(BadRequestException);
    expect(() => parseFields("not json")).toThrow(BadRequestException);
  });
});

describe("pickRelations", () => {
  it("keeps only allowed relations", () => {
    expect(pickRelations({ category: true, postReactions: true }, ["category"])).toEqual({
      category: true,
    });
    expect(pickRelations(undefined, ["category"])).toEqual({});
  });
});
