# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**haloidergisi** is a Bun + Turborepo monorepo for the HALO literary magazine: a NestJS API (Drizzle ORM + PostgreSQL) and a React web app (TanStack Start). Linting is oxlint, formatting is oxfmt, and pre-commit hooks use Husky + lint-staged.

```
apps/
├── api/          # NestJS REST backend, port 3000 (PORT env)
├── web/          # React frontend (TanStack Start / Vite), port 5173
packages/
└── emails/       # @repo/emails — React Email templates consumed by the API's MailService
```

## Commands

The root `package.json` only defines `build`, `dev`, `start`, `check-types`, `lint`, `format` and `db:update`. Any other script (test, debug, db:studio, …) has to be run in its workspace with `bun run --filter=<name> <script>`, or from inside the app directory. `bun run test --filter=api` from the root does **not** work.

```bash
bun install
bun run dev                        # all apps (turbo; dev depends on ^build, so packages/emails builds first)
bun run dev --filter=api           # just the API (extra args pass through to `turbo run dev`)
bun run dev --filter=web
bun run build                      # dotenvx run -- turbo run build
bun run start                      # production start (does NOT build first)

bun run lint                       # oxlint (root)
bun run format                     # oxfmt (root)
bun run check-types                # turbo run type-check → tsc --noEmit per workspace

bun run db:update                  # api: drizzle-kit generate && drizzle-kit push
bun run --filter=api db:studio     # Drizzle Studio

# API tests (Jest): unit specs sit next to the code (src/**/*.spec.ts)
bun run --filter=api test
bun run --filter=api test:e2e      # test/app.e2e-spec.ts boots AppModule with configureApp(); no DB needed
cd apps/api && bun x jest path/to/file.spec.ts        # single file
cd apps/api && bun x jest -t "test name"              # single test by name
bun run --filter=api debug         # nest start --debug --watch

# Web tests (Vitest, src/**/*.test.ts(x), jsdom; config in vitest.config.ts, not vite.config.ts)
bun run --filter=web test          # vitest run
cd apps/web && bun x vitest run path/to/file.test.tsx

# Email template preview
bun run --filter=@repo/emails start:dev   # React Email dev server on :3030
```

## Environment

- There is a single `.env` at the repo root. `link-env.sh` symlinks it into each workspace that has a `package.json` (`apps/*/.env`, `packages/*/.env`). Run it after cloning or after adding a workspace.
- Root `build`/`start` wrap turbo with `dotenvx run --`. `turbo.json` sets `globalPassThroughEnv: ["*"]`. The API and `drizzle.config.ts` also call `import "dotenv/config"` themselves.
- `drizzle.config.ts` reads `DATABASE_URL`.

## Architecture

### Shared DB types via the `@repo/db` alias

`@repo/db` is a **tsconfig path alias, not a package**. It points to `apps/api/src/database/db-client.ts`, which re-exports the Drizzle client, every table, the inferred types and the enums (`Role`, `PostStatus`, …) from `src/database/schema/index.ts`.

- API code imports tables and types from `"@repo/db"` (`apps/api/tsconfig.json`).
- **The web app has the same alias** (`apps/web/tsconfig.json` → `../api/src/database/db-client`). Frontend entity types (`apps/web/src/types`) come straight from the API's Drizzle schema, so a schema change can break web type-checking. In web code, only use it for types (prefer `import type`); never pull runtime values such as `db` or tables into the browser bundle.

The schema is a single file, `apps/api/src/database/schema/index.ts`. Migrations are written to `apps/api/drizzle/`. Seed and mock-data scripts live in `apps/api/scripts/`.

### Backend (`apps/api/src`)

- `app/app.module.ts` wires up every feature module in `modules/` plus JWT, the mailer, the event emitter and scheduling. Each module is `*.module.ts` + `*.controller.ts` + `*.service.ts` + `dto/` (class-validator) + `entities/`. `app/configure-app.ts` (used by `main.ts` and the e2e test) sets up CORS, helmet, `trust proxy` and a global `ValidationPipe`.
- **Auth uses opaque session tokens, not JWT.** Login stores a random token in the `tokens` table (`TokensService`), and `AuthGuard` looks the bearer token up on every request. It also records the authenticating token on the request (read it with `@SessionToken()`); changing or resetting a password revokes the user's other sessions via `TokensService.removeAllForUser`. `@nestjs/jwt` is only used for one-off signed tokens such as password-reset links. **Google sign-in** (`modules/auth-google`) uses **arctic** as a server-side redirect flow: `GET /auth/google` keeps `state` + PKCE verifier in a signed httpOnly cookie and redirects to Google; `GET /auth/google/callback` (must equal `GOOGLE_REDIRECT_URI`, registered in Google Cloud) checks `state`, finds or creates the user, and sends the browser back with a 2-minute one-time handoff code: web `WEB_URL`/`APP_URL` + `/google-callback#code=…`. The client redeems it at `POST /auth/google/exchange`. Linking Google to a signed-in account goes through `POST /auth/google/link`, which returns the URL to open. Signing in with Google whose (Google-verified) email matches an existing account links it automatically; if that account's email was never verified, its password and sessions are revoked first (pre-hijacking protection).
- **Route decorators** (`src/decorators`): `@AllowAnonymous()`, `@OptionalAuth()`, `@Roles(Role.ADMIN, …)`, and the `@Auth()` param decorator (current user, or one field of it). RBAC roles are ADMIN and USER. `ProfileGuard` handles per-profile ownership checks; a profile's `title` ("unvan") is admin-managed, and `PATCH /profile/:id` refuses a change to it from anyone else (an unchanged value is ignored). There is also a Cloudflare Turnstile guard for public forms. Both clients render Turnstile with `appearance: "interaction-only"`, so it verifies in the background and only shows when Cloudflare needs interaction.
- **List endpoints** use the `@DrizzleQuery()` param decorator. It parses `page`, `limit`, `sort`, `fields`, `filter` and `search` into a Drizzle where/order/pagination shape, backed by `utils/queryBuilder`.
- **Email**: services emit events (`EMAIL_EVENTS` in `src/constants.ts`). `services/mail.service.ts` listens for them and renders `@repo/emails` templates through Nodemailer.
- **HTTP hardening** (`app/configure-app.ts`): `helmet`, CORS limited to `CORS_ORIGINS` (comma-separated) or else `WEB_URL`/`APP_URL`/`FRONTEND_URL` plus their `www.` variants, with the Vite dev server allowed outside production (`utils/cors.ts`). `TRUST_PROXY` (default 1) is the number of reverse proxies in front of the API. `ClientIpThrottlerGuard` runs before `AuthGuard` and rate-limits per client IP (`CF-Connecting-IP` when present): 600 req/min globally, and `@Throttle(AUTH_THROTTLE)` (10/min) on login, register, password reset, Google exchange, email verification and the contact form. Put `AUTH_THROTTLE` on new public or credential endpoints.
- A global `StripSensitiveFieldsInterceptor` (`src/interceptors/`) removes `password` from every HTTP response, because user rows leak in through many relations (`author`, `user`, …). Don't rely on it to hide other secrets; add the field to its list.
- Files are stored in AWS S3 (`modules/files`), and `utils/cdn.ts` builds public URLs.

### Frontend (`apps/web/src`)

- TanStack Start with file-based routing in `routes/`. `routeTree.gen.ts` is generated, so don't edit it. Pathless layout groups are directories with a `route.tsx`: `_landing/` (public site), `_auth/` (login/register) and `dashboard/` (admin). Dynamic segments look like `$postId.tsx`.
- **One API client**: `lib/api-client.ts` (axios) attaches the bearer token from `localStorage` and toggles the global loading indicator through the Zustand `loader-store`. Shared TanStack Query hooks and response types live in `queries/`.
- UI is Shadcn (`components/ui`) + Tailwind v4 with CSS-variable theming (next-themes). Forms use React Hook Form + Zod (`schemas/`). Charts use Recharts. `.agents/skills/shadcn/` holds project shadcn usage rules (composition, forms, styling, base-vs-radix). Follow them when adding UI.
- Public config (`VITE_API_URL`, `VITE_TURNSTILE_SITE_KEY`) is read through `lib/env.ts`, never `import.meta.env` directly. The root `.env` is shared by dev and production builds, so a production build ignores loopback API URLs and Turnstile test keys and falls back to `https://api.haloidergisi.com` and the production site key.
- SEO helpers are in `utils/seo.ts`. The sitemap is proxied from the API's `/sitemap` module (see `docs/SEO_IMPROVEMENTS.md`).

### PWA

`apps/web` is installable via `vite-plugin-pwa` (`vite.config.ts`). The plugin's `outDir` must stay `.output/public`, because that is where TanStack Start + nitro put the client build; elsewhere `sw.js` is emitted but precaches nothing. The service worker is registered in `routes/__root.tsx` (production only). Phones get a bottom tab bar (`components/landing/bottom-tabs.tsx`, `md:hidden`). Issues open in-app at `/posts/:slug/read` (`react-pdf`, client-only, outside the landing layout): the reader asks before downloading the PDF into Cache Storage (`lib/issue-cache.ts`, stores nothing unless the bytes contain `%PDF`) and resumes on the last page (`lib/reading-progress.ts`). The CDN must send CORS headers for the web origin or the download fails.

## Tooling notes

- The pre-commit hook runs `lint-staged`, which runs `oxfmt --write` and then `oxlint --fix` on staged `*.{ts,tsx}` files. Config lives in `.oxfmtrc.json` (sorts imports, package.json and Tailwind classes) and `.oxlintrc.json`.
- `turbo.json`: `build`, `dev` and `type-check` all depend on `^build`. `dev`/`start` are persistent and uncached, and so are `db:update`/`db:generate`.
- Node >= 22 and `bun@1.3.5` (`packageManager`).
