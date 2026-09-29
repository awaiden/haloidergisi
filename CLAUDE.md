# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**haloidergisi** is a Bun + Turborepo monorepo for the HALO literary magazine: a NestJS API (Drizzle ORM + PostgreSQL) and a React web app (TanStack Start). Linting is oxlint, formatting is oxfmt, and pre-commit hooks use Husky + lint-staged.

```
apps/
├── api/          # NestJS REST backend, port 3000 (PORT env)
├── web/          # React frontend (TanStack Start / Vite), port 5173
└── mobile/       # Flutter reader/writer app — NOT a Bun workspace (no package.json), not run by turbo
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
- **Auth uses opaque session tokens, not JWT.** Login stores a random token in the `tokens` table (`TokensService`), and `AuthGuard` looks the bearer token up on every request. It also records the authenticating token on the request (read it with `@SessionToken()`); changing or resetting a password revokes the user's other sessions via `TokensService.removeAllForUser`. `@nestjs/jwt` is only used for one-off signed tokens such as password-reset links. **Google sign-in** (`modules/auth-google`) uses **arctic** as a server-side redirect flow shared by web and mobile: `GET /auth/google?platform=web|mobile` keeps `state` + PKCE verifier in a signed httpOnly cookie and redirects to Google; `GET /auth/google/callback` (must equal `GOOGLE_REDIRECT_URI`, registered in Google Cloud) checks `state`, finds or creates the user, and sends the browser back with a 2-minute one-time handoff code: web `WEB_URL`/`APP_URL` + `/google-callback#code=…`, mobile `halo://auth-callback?code=…`. The client redeems it at `POST /auth/google/exchange`; mobile must also send the verifier behind the `challenge` it passed at start. Linking Google to a signed-in account goes through `POST /auth/google/link`, which returns the URL to open. Signing in with Google whose (Google-verified) email matches an existing account links it automatically; if that account's email was never verified, its password and sessions are revoked first (pre-hijacking protection).
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

### Mobile (`apps/mobile`, Flutter)

Feature-first layout with clean-architecture layers per feature: `lib/app/` (router, theme, env), `lib/core/` (Dio client, token storage, Turnstile, validators) and `lib/features/<name>/{domain,data,presentation}`. State management is Riverpod 3; `@riverpod` controllers use codegen, and core infrastructure uses plain `Provider`s. Routing is `go_router`, and models are `freezed` + `json_serializable`.

- **Auth follows the web's contract.** The opaque token lives in `flutter_secure_storage`, and `AuthInterceptor` adds it as `Bearer`. A 401 on an authenticated request clears the token and fires `sessionExpiredProvider`. `AuthController` then sets the state to `null`, and the router's `redirect` (`authRedirect` in `app/router/app_router.dart`) handles navigation. Mutations never set the controller to loading, because loading means "show the splash".
- **Turnstile**: `/auth/login`, `/register` and `/forgot-password` need a `cf-turnstile-response` body field. `core/turnstile/turnstile_field.dart` renders Cloudflare's `api.js` in a `webview_flutter` WebView loaded from `TURNSTILE_BASE_URL`, and that hostname must be in the site key's allowed domains. It runs with `appearance: "interaction-only"`: the WebView collapses to 1 px until Cloudflare asks for interaction, and `TurnstileFormMixin` waits up to 10 s for the background token on submit. Tokens are single-use; the mixin resets the widget after a failed submit. The public site key is the default for `TURNSTILE_SITE_KEY`. With no WebView platform (widget tests) the field renders a fallback text instead.
- **Google sign-in** (mobile): `AuthRepositoryImpl.signInWithGoogle` opens the API flow in a secure browser tab via `flutter_web_auth_2` (`WebAuthenticator`, callback scheme `halo`, `CallbackActivity` in the Android manifest) with its own PKCE challenge, then redeems the handoff code. Adding or changing native plugins, the manifest, or fields on long-lived objects (providers created at startup) needs a full `flutter run`, not hot reload.
- Auth screens (`AuthScaffold`) always offer a way out: a back arrow when there's a page to pop, otherwise a close button, and the system back button, that go to `/`. They also navigate away on sign-in themselves (to `Routes.afterSignIn`: the `from` path, else home). When login is _pushed_, go_router re-runs `redirect` for the page underneath, so `authRedirect` alone can't leave the login screen.
- **Design system** (`app/theme/app_theme.dart`): taken from the brand material in `apps/web/public`: pale luminous gold, the logo's thin ring with a dot, and a didone wordmark. Playfair Display sets titles and Inter everything else; both are bundled variable fonts in `assets/fonts/` (weights go through the `wght` axis in `_style`). Brand colors Material lacks live in the `HaloColors` theme extension. Reusable brand widgets are in `core/widgets/halo.dart`: `HaloMark` (logo per theme), `HaloSpinner`/`HaloLoading` (ring with an orbiting dot, still under reduced motion), `HaloGlow` and `HaloRing`. Use them instead of Material's spinner or ad-hoc decoration. Covers are printed objects (`AppTheme.coverRadius`, soft shadow), lists are text-first (`EntryRow`: title, date, a two-line `plainTextExcerpt` and a chevron so rows read as tappable) rather than boxed cards; primary actions on detail pages (e.g. "Yazı Gönder" on a call) sit in a bar pinned to the bottom, and metadata goes on separate lines, not joined with " · ". The theme mode (Sistem/Açık/Koyu, on the Ayarlar page) is `themeModeControllerProvider`, persisted in `SharedPreferences` that `main` loads before the first frame.
- **Navigation**: `StatefulShellRoute` with four tabs (`app/shell/app_shell.dart`): Dergiler `/` (posts), Haberler `/news`, Çağrılar `/calls` (submission calls) and Hesap `/account`. Content, call pages, the `/account` tab, Ayarlar (`/account/settings`, opened from the gear icon in Hesap: theme, notifications when signed in, and the HALO pages) and the info pages (about, team, contact, privacy, terms) are public, like the web. Hesap itself only holds the account (profile, submissions, password, sign-out). The user's own account pages (`Routes._sessionPaths`) and `/calls/:id/submit` need a session (`Routes._requiresSession`): `authRedirect` sends signed-out users to `Routes.loginFrom(path)` and returns them to that path after login. Only in-app `from` paths are accepted.
- **Posts**: `GET /posts` returns only published posts to non-admins, and `PostsRemoteDataSource` still sends `status=PUBLISHED`. Stored file paths (covers, PDFs) go through `cdnUrl()` (`core/utils/cdn.dart`), which mirrors the web's `getCdnUrl` and percent-encodes filenames with spaces or Turkish characters. PDFs open **in-app** in `IssueReaderScreen` (`pdfrx`, route `/posts/:slug/read` on the root navigator so it covers the tab bar). Issues are ~85 MB, so the reader asks before downloading into the app cache (`IssueFileCache`, `.part` file until complete), then opens the file and resumes on the last page read (`ReadingProgress`). `IssueDocumentViewer` only loads the document; the paging state lives in its child `_IssuePages`, so nothing calls `setState` on an ancestor from pdfrx's `builder` (that crashed the reader as soon as a document loaded). Tests feed it an in-memory document via `PdfDocumentRefDirect` (no pdfium needed). Don't send users to an external browser for PDFs.
- **Submissions** (`features/submissions`, `Article` in the API): one submission per call. Authors can edit only `PENDING`/`REVISION_REQ` work (`ArticleStatus.canEdit` mirrors `ArticleGuard`). The file is uploaded first (`POST /files`, multipart; the response is the CDN key as plain text) and the key is saved as `fileUrl`. Uploads are streamed from the picked file (not by path, since Android pickers return `content://` URIs). Any signed-in user may upload (avatars, submissions). The size limit depends on role: `RoleBasedUploadInterceptor` (`apps/api/src/modules/files/upload.interceptor.ts`) allows `USER_UPLOAD_LIMIT_BYTES` (25 MB) for regular users and no limit for admins, and oversized uploads get 413. The app checks the same limit up front (`userUploadLimitBytes`); keep the two in sync.
- **Info pages** (`features/info`): Hakkımızda / Gizlilik / Kullanım Şartları render bundled copies of `apps/web/src/contents/*.md` from `apps/mobile/assets/contents/`. Update both copies when the text changes. Ekibimiz reads the public `GET /crews` (members are id + profile only). İletişim posts to the Turnstile-guarded `POST /messages` via `TurnstileFormMixin`.
- Config comes in via `--dart-define` (`lib/app/constants/env.dart`): `API_BASE_URL` (defaults to `https://api.haloidergisi.com` in every build mode, so a debug APK such as the CI artifact works for testers. Local development opts in with `http://localhost:3000` from `dart_defines.json`: on Android, device or emulator, run `adb reverse tcp:3000 tcp:3000`; the iOS simulator shares the host's localhost. Release builds ignore loopback values even when defined, so building with the dev `dart_defines.json` can't ship a localhost API), `TURNSTILE_SITE_KEY`, `TURNSTILE_BASE_URL` and `CDN_BASE_URL`. Keep them in the git-ignored `apps/mobile/dart_defines.json` (template: `dart_defines.example.json`; the site key is `VITE_TURNSTILE_SITE_KEY` from the root `.env`) and run with `--dart-define-from-file=dart_defines.json`. The VS Code "mobile" launch config already does this. The UI locale is fixed to Turkish, and `main` calls `initializeDateFormatting('tr')` for `formatDate`; widget tests that render dates must call it too. Cleartext http is enabled only in the Android debug manifest.
- **APK size**: share release builds, never `--debug` (a debug APK carries the JIT engine and unoptimized code for every ABI: ~37 MB of engine per ABI vs ~11 MB in release). For sideloading use `flutter build apk --release --split-per-abi` and hand out `app-arm64-v8a-release.apk`; for the Play Store use `flutter build appbundle`. Only `halo-dark.png`/`halo-light.png` are bundled from `assets/brand/`; the `app_icon*.png` files are `flutter_launcher_icons` inputs.
- Generated `*.g.dart` / `*.freezed.dart` files are committed. `freezed` is pinned to `4.0.0-dev.3`: stable 3.x conflicts with `riverpod_generator`'s analyzer range, and stable 4.x needs Dart 3.13.

```bash
cd apps/mobile
flutter pub get
dart run build_runner watch --delete-conflicting-outputs   # after editing @riverpod / @freezed classes
flutter analyze && flutter test
flutter test test/features/auth/login_screen_test.dart     # single file
cp dart_defines.example.json dart_defines.json            # once; fill in TURNSTILE_SITE_KEY
adb reverse tcp:3000 tcp:3000                              # Android: reach the local API
flutter run --dart-define-from-file=dart_defines.json
```

## Tooling notes

- The pre-commit hook runs `lint-staged`, which runs `oxfmt --write` and then `oxlint --fix` on staged `*.{ts,tsx}` files. Config lives in `.oxfmtrc.json` (sorts imports, package.json and Tailwind classes) and `.oxlintrc.json`.
- `turbo.json`: `build`, `dev` and `type-check` all depend on `^build`. `dev`/`start` are persistent and uncached, and so are `db:update`/`db:generate`.
- Node >= 22 and `bun@1.3.5` (`packageManager`).
