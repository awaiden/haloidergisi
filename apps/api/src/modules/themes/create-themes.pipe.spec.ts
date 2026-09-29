import { BadRequestException } from "@nestjs/common";

import { CreateThemesPipe } from "./create-themes.pipe";

describe("CreateThemesPipe", () => {
  const pipe = new CreateThemesPipe();
  const theme = { work: "Sessizlik", category: "Şiir", postId: "p1" };

  it("wraps a single theme in an array", async () => {
    await expect(pipe.transform(theme)).resolves.toEqual([theme]);
  });

  it("accepts an array and strips unknown fields", async () => {
    const [result] = await pipe.transform([{ ...theme, extra: true }]);
    expect(result).toEqual(theme);
  });

  it("rejects invalid items", async () => {
    await expect(pipe.transform({ work: "x" })).rejects.toBeInstanceOf(BadRequestException);
    await expect(pipe.transform([theme, { work: 1 }])).rejects.toBeInstanceOf(BadRequestException);
  });
});
