export const METADATA_KEY = {
  PUBLIC: "auth:public",
  OPTIONAL_AUTH: "auth:optional",
  ROLES: "auth:roles",
} as const;

export const EMAIL_EVENTS = {
  WELCOME: "email:welcome",
  VERIFY_EMAIL: "email:verify_email",
  RESET_PASSWORD: "email:reset_password",
  NEW_POST: "email:new_post",
} as const;
