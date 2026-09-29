import { describe, expect, it } from "vitest";

import { feedbackSchema, messageSchema } from "./message";

const valid = {
  name: "Ada",
  email: "ada@example.com",
  subject: "Merhaba",
  content: "Dergi için teşekkürler.",
};

describe("messageSchema", () => {
  it("accepts a complete message", () => {
    expect(messageSchema.safeParse(valid).success).toBe(true);
  });

  it("rejects an invalid email or empty content", () => {
    expect(messageSchema.safeParse({ ...valid, email: "nope" }).success).toBe(false);
    expect(messageSchema.safeParse({ ...valid, content: "" }).success).toBe(false);
  });
});

describe("feedbackSchema", () => {
  it("only requires the content", () => {
    expect(feedbackSchema.safeParse({ content: "Harika" }).success).toBe(true);
    expect(feedbackSchema.safeParse({}).success).toBe(false);
  });
});
