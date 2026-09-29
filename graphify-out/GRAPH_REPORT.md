# Graph Report - haloidergisi  (2026-09-29)

## Corpus Check
- 419 files · ~115,225 words
- Verdict: corpus is large enough that graph structure adds value.
- Unclassified: 59 file(s) not represented in the graph (top: (none) 12, .xcconfig 8, .xml 7)

## Summary
- 2488 nodes · 5961 edges · 147 communities (119 shown, 28 thin omitted)
- Extraction: 95% EXTRACTED · 5% INFERRED · 0% AMBIGUOUS · INFERRED: 305 edges (avg confidence: 0.85)
- Token cost: 86,560 input · 0 output

## Community Hubs (Navigation)
- Form UI Components
- Generated Route Tree
- API Constants & DB Client
- App Core & Guards
- Data Grid Components
- CDN Image & Categories UI
- Dashboard Charts & Analytics
- Post Cards & Posts UI
- Drizzle Schema & Relations
- Web Runtime Dependencies
- Breadcrumbs & File Input
- Account & Auth Routes
- API Package Manifest
- Dashboard Sidebar
- AuthGuard & Account Access
- Flutter Apple AppDelegate
- Articles API
- Roles & Auth Decorators
- Account API
- Flutter Default App Icons
- API Runtime Dependencies
- Submission Calls API
- Date Range Picker
- Messages DTOs
- Flutter Linux Runner
- Web Package Manifest
- Categories API
- Posts API
- Flutter Build Configs
- Theme Config API
- DrizzleQuery Decorator
- Landing Navbar & Logo
- News API
- Google OAuth Controller
- Crews API
- Themes API
- Auth API
- API TS Config
- Project Docs & READMEs
- API Dev Dependencies
- Turbo Pipeline
- Article Schema Types
- Files Upload API
- Web TS Config
- Root Package Manifest
- App Module Bootstrap
- Win32 Window Base
- Account Dropdown Menu
- Sitemap Controller
- Analytics Tracking API
- Flutter Counter App
- Flutter Windows Window
- Google Auth & Turnstile UI
- Shadcn Components Config
- Profile API
- Shadcn Theming Rules
- App Providers & Loader
- Markdown & About Page
- Theme Config Frontend
- Stats GraphQL Module
- Users Controller
- Windows Runner Entry
- Field Form Primitives
- Oxlint Config
- Emails Package Manifest
- Shadcn CLI Reference
- API Scripts
- Web Dev Dependencies
- Article Email Templates
- Shadcn Form Rules
- Themes DTOs
- Mail Service
- Web PWA Manifest
- Oxfmt Config
- Shadcn Composition Rules
- Nest CLI Config
- Flutter Web Manifest
- Flutter Window Impl
- Jest Config
- Articles & Messages Schema
- Win32 DPI Handling
- Blog Routes & SEO
- Root Dependencies
- Root Scripts
- Emails TS Config
- Shadcn MCP Tools
- Shadcn Base vs Radix
- Google OAuth Callback
- User DTOs
- Vite Config
- Shadcn Agent Skill
- Shadcn Styling Rules
- App Controller Hello
- Dashboard Stats Types
- Windows Runner Headers
- Win32 Geometry Types
- Footer & Social Links
- Archive Page
- Architecture Concepts
- Root Dev Tooling
- App E2E Tests
- News DTOs
- Web Scripts
- Web API Client
- Layout Routes
- Query DTOs
- Shadcn Tailwind Config
- HALO Brand Assets
- Alert Component
- Router Setup
- Emails Dev Dependencies
- Seed Scripts
- Windows Plugin Registrant
- Legal & Magazine Content
- Vite Env Types
- Emails Scripts
- Profile Guard
- Query Builder
- API Build TS Config
- Account Layout Route
- Profile DTO
- Android MainActivity
- iOS Launch Images
- Emails Peer Deps
- Author Submission Email
- Verify Email Template
- Welcome Email Template
- Shadcn Icons
- Theme Type
- Category Entity
- Crew Entity
- Message Entity
- Post Entity
- User Entity
- iOS Bridging Header
- Sitemap XML Route
- unDraw Illustrations
- Route Typings
- Env Link Script
- Node Engine Spec
- Lint-staged Config
- TS Peer Dependency
- Turnstile Guard Concept

## God Nodes (most connected - your core abstractions)
1. `cn()` - 148 edges
2. `@nestjs/common` - 75 edges
3. `@tanstack/react-router` - 72 edges
4. `Button()` - 61 edges
5. `FileRoutesByPath` - 60 edges
6. `@iconify/react` - 48 edges
7. `DrizzleService` - 47 edges
8. `Roles()` - 44 edges
9. `sonner` - 43 edges
10. `Input()` - 41 edges

## Surprising Connections (you probably didn't know these)
- `packages/db Shared Drizzle Schema (per GEMINI.md)` --conceptually_related_to--> `Drizzle Schema (apps/api/src/database/schema)`  [AMBIGUOUS]
  GEMINI.md → CLAUDE.md
- `NestJS Starter README` --conceptually_related_to--> `haloidergisi Monorepo`  [INFERRED]
  apps/api/README.md → CLAUDE.md
- `React Email Starter (packages/emails)` --conceptually_related_to--> `haloidergisi Monorepo`  [INFERRED]
  packages/emails/readme.md → CLAUDE.md
- `Root README (bun init stub)` --conceptually_related_to--> `haloidergisi Monorepo`  [INFERRED]
  README.md → CLAUDE.md
- `Sitemap Module (/sitemap/xml backend)` --shares_data_with--> `Drizzle Schema (apps/api/src/database/schema)`  [INFERRED]
  docs/SEO_IMPROVEMENTS.md → CLAUDE.md

## Import Cycles
- None detected.

## Hyperedges (group relationships)
- **shadcn Critical Rule Files** — _agents_skills_shadcn_rules_styling, _agents_skills_shadcn_rules_forms, _agents_skills_shadcn_rules_composition, _agents_skills_shadcn_rules_icons, _agents_skills_shadcn_rules_base_vs_radix [EXTRACTED 1.00]
- **Theming via Semantic Tokens** — _agents_skills_shadcn_customization_css_variable_tokens, _agents_skills_shadcn_rules_styling_semantic_colors, _agents_skills_shadcn_rules_styling_no_dark_overrides, _agents_skills_shadcn_customization_dark_mode_next_themes, _agents_skills_shadcn_skill_semantic_colors [INFERRED 0.85]
- **shadcn MCP Registry Tools** — _agents_skills_shadcn_mcp_get_project_registries, _agents_skills_shadcn_mcp_list_items_in_registries, _agents_skills_shadcn_mcp_search_items_in_registries, _agents_skills_shadcn_mcp_view_items_in_registries, _agents_skills_shadcn_mcp_get_item_examples_from_registries, _agents_skills_shadcn_mcp_get_add_command_for_items, _agents_skills_shadcn_mcp_get_audit_checklist [EXTRACTED 1.00]
- **Session Authentication Flow** — claude_opaque_session_token_auth, claude_authguard, claude_tokensservice, claude_auth_decorators, claude_api_client [INFERRED 0.85]
- **SEO Pipeline (meta, sitemap, robots, manifest)** — docs_seo_improvements_seo_utility, docs_seo_improvements_sitemap_module, docs_seo_improvements_sitemap_proxy, apps_web_public_robots_rules, docs_seo_improvements_pwa_manifest [EXTRACTED 1.00]
- **HALO brand visual assets (logos and hero banners sharing script-Halo mark and golden halo theme)** — apps_web_public_logo_halologo, apps_web_public_halo_light_halolightlogo, apps_web_public_halo_dark_halodarklogo, apps_web_public_banner_desktop_bannerdesktop, apps_web_public_banner_mobile_bannermobile [INFERRED 0.85]
- **Flutter platform embedders for mobile app** — apps_mobile_linux_runner_cmakelists_binary, apps_mobile_windows_runner_cmakelists_binary, apps_mobile_web_index_web_entry, apps_mobile_pubspec_mobile [INFERRED 0.85]
- **iOS AppIcon.appiconset (Flutter default icons)** — apps_mobile_ios_runner_assets_xcassets_appicon_appiconset_icon_app_1024x1024_1x_icon, apps_mobile_ios_runner_assets_xcassets_appicon_appiconset_icon_app_20x20_1x_icon, apps_mobile_ios_runner_assets_xcassets_appicon_appiconset_icon_app_20x20_2x_icon, apps_mobile_ios_runner_assets_xcassets_appicon_appiconset_icon_app_20x20_3x_icon, apps_mobile_ios_runner_assets_xcassets_appicon_appiconset_icon_app_29x29_1x_icon, apps_mobile_ios_runner_assets_xcassets_appicon_appiconset_icon_app_29x29_2x_icon, apps_mobile_ios_runner_assets_xcassets_appicon_appiconset_icon_app_29x29_3x_icon, apps_mobile_ios_runner_assets_xcassets_appicon_appiconset_icon_app_40x40_1x_icon, apps_mobile_ios_runner_assets_xcassets_appicon_appiconset_icon_app_40x40_2x_icon, apps_mobile_ios_runner_assets_xcassets_appicon_appiconset_icon_app_40x40_3x_icon, apps_mobile_ios_runner_assets_xcassets_appicon_appiconset_icon_app_60x60_2x_icon, apps_mobile_ios_runner_assets_xcassets_appicon_appiconset_icon_app_60x60_3x_icon, apps_mobile_ios_runner_assets_xcassets_appicon_appiconset_icon_app_76x76_1x_icon, apps_mobile_ios_runner_assets_xcassets_appicon_appiconset_icon_app_76x76_2x_icon, apps_mobile_ios_runner_assets_xcassets_appicon_appiconset_icon_app_83_5x83_5_2x_icon [EXTRACTED 1.00]
- **Android mipmap launcher icon densities** — apps_mobile_android_app_src_main_res_mipmap_hdpi_ic_launcher_icon, apps_mobile_android_app_src_main_res_mipmap_mdpi_ic_launcher_icon, apps_mobile_android_app_src_main_res_mipmap_xhdpi_ic_launcher_icon, apps_mobile_android_app_src_main_res_mipmap_xxhdpi_ic_launcher_icon, apps_mobile_android_app_src_main_res_mipmap_xxxhdpi_ic_launcher_icon [EXTRACTED 1.00]
- **macOS AppIcon set and Web PWA icons/favicon** — apps_mobile_macos_runner_assets_xcassets_appicon_appiconset_app_icon_1024_icon, apps_mobile_macos_runner_assets_xcassets_appicon_appiconset_app_icon_128_icon, apps_mobile_macos_runner_assets_xcassets_appicon_appiconset_app_icon_16_icon, apps_mobile_macos_runner_assets_xcassets_appicon_appiconset_app_icon_256_icon, apps_mobile_macos_runner_assets_xcassets_appicon_appiconset_app_icon_32_icon, apps_mobile_macos_runner_assets_xcassets_appicon_appiconset_app_icon_512_icon, apps_mobile_macos_runner_assets_xcassets_appicon_appiconset_app_icon_64_icon, apps_mobile_web_favicon_favicon, apps_mobile_web_icons_icon_192_icon, apps_mobile_web_icons_icon_512_icon, apps_mobile_web_icons_icon_maskable_192_icon, apps_mobile_web_icons_icon_maskable_512_icon [INFERRED 0.75]

## Communities (147 total, 28 thin omitted)

### Community 0 - "Form UI Components"
Cohesion: 0.10
Nodes (38): apps_web_src_components_ui_form_form, FormControl(), FormDescription(), FormField(), FormFieldContext, FormFieldContextValue, FormItem(), FormItemContext (+30 more)

### Community 1 - "Generated Route Tree"
Cohesion: 0.03
Nodes (72): AuthForgotPasswordRoute, AuthLoginRoute, AuthRegisterRoute, AuthResetPasswordRoute, AuthRouteRoute, AuthRouteRouteChildren, AuthRouteRouteWithChildren, AuthVerifyEmailRoute (+64 more)

### Community 2 - "API Constants & DB Client"
Cohesion: 0.08
Nodes (41): EMAIL_EVENTS, METADATA_KEY, apps_api_src_database_db_client_categories, client, apps_api_src_database_db_client_crews, db, apps_api_src_database_db_client_news, apps_api_src_database_db_client_notificationsettings (+33 more)

### Community 3 - "App Core & Guards"
Cohesion: 0.05
Nodes (36): apps_api_src_database_db_client_files, apps_api_src_decorators_index_allowanonymous, apps_api_src_guards_index_turnstileguard, Injectable, TurnstileGuard, AccountModule, Module, ArticlesModule (+28 more)

### Community 4 - "Data Grid Components"
Cohesion: 0.10
Nodes (35): apps_api_src_database_db_client_message, apps_api_src_database_db_client_pagevisit, apps_api_src_database_db_client_provider, DataGrid(), DataGridProps, Pagination(), PaginationProps, ignoredPaths (+27 more)

### Community 5 - "CDN Image & Categories UI"
Cohesion: 0.08
Nodes (44): apps_api_src_database_db_client_category, apps_api_src_database_db_client_crew, Category, CdnImage(), CdnImageProps, FieldFileInput(), Checkbox(), Select() (+36 more)

### Community 6 - "Dashboard Charts & Analytics"
Cohesion: 0.05
Nodes (36): Message, PageVisit, ChartCard(), ChartCardProps, Surface(), SurfaceProps, Table(), TableBody() (+28 more)

### Community 7 - "Post Cards & Posts UI"
Cohesion: 0.10
Nodes (26): apps_api_src_database_db_client_post, Post, PostCard(), PostCardProps, PostCardSkeleton(), Badge(), badgeVariants, Card() (+18 more)

### Community 8 - "Drizzle Schema & Relations"
Cohesion: 0.04
Nodes (44): articlesRelations, articleStatusEnum, categoriesRelations, crewsRelations, File, files, NewArticle, NewCategory (+36 more)

### Community 9 - "Web Runtime Dependencies"
Cohesion: 0.04
Nodes (45): dependencies, axios, class-variance-authority, clsx, date-fns, @dnd-kit/core, @dnd-kit/sortable, @dnd-kit/utilities (+37 more)

### Community 10 - "Breadcrumbs & File Input"
Cohesion: 0.08
Nodes (33): Breadcrumb(), BreadcrumbItem, Breadcrumbs, FileInput(), Skeleton(), SkeletonProps, Avatar(), AvatarBadge() (+25 more)

### Community 11 - "Account & Auth Routes"
Cohesion: 0.05
Nodes (44): Route, Route, Route, Route, Route, Route, Route, Route (+36 more)

### Community 12 - "API Package Manifest"
Cohesion: 0.05
Nodes (42): author, description, axios, date-fns, graphql, slugify, @types/node, typescript (+34 more)

### Community 13 - "Dashboard Sidebar"
Cohesion: 0.08
Nodes (36): Sidebar(), SidebarContent(), SidebarContext, SidebarContextProps, SidebarFooter(), SidebarGroup(), SidebarGroupAction(), SidebarGroupContent() (+28 more)

### Community 14 - "AuthGuard & Account Access"
Cohesion: 0.09
Nodes (20): apps_api_src_database_db_client_poststatus, apps_api_src_decorators_index_auth, apps_api_src_decorators_index_drizzlequeryparams, AuthGuard, Injectable, apps_api_src_guards_index_authguard, ChangePasswordDto, CreateAccountDto (+12 more)

### Community 15 - "Flutter Apple AppDelegate"
Cohesion: 0.06
Nodes (25): Any, AppDelegate, Bool, SceneDelegate, RunnerTests, RegisterGeneratedPlugins(), AppDelegate, Bool (+17 more)

### Community 16 - "Articles API"
Cohesion: 0.09
Nodes (19): ArticlesController, Body, Controller, Delete, Get, Param, Patch, Post (+11 more)

### Community 17 - "Roles & Auth Decorators"
Cohesion: 0.11
Nodes (19): apps_api_src_database_db_client_role, apps_api_src_database_db_client_user, Role, User, OptionalAuth(), Roles(), apps_api_src_decorators_index_drizzlequery, ArticleGuard (+11 more)

### Community 18 - "Account API"
Cohesion: 0.12
Nodes (11): Auth, AccountController, Body, Controller, Delete, Get, Patch, Post (+3 more)

### Community 19 - "Flutter Default App Icons"
Cohesion: 0.12
Nodes (33): Android Launcher Icon (hdpi, default Flutter logo), Android Launcher Icon (mdpi, default Flutter logo), Android Launcher Icon (xhdpi, default Flutter logo), Android Launcher Icon (xxhdpi, default Flutter logo), Android Launcher Icon (xxxhdpi, default Flutter logo), Default Flutter Logo Branding (unreplaced scaffold placeholder), iOS App Icon 1024x1024@1x (default Flutter logo), iOS App Icon 20x20@1x (default Flutter logo) (+25 more)

### Community 20 - "API Runtime Dependencies"
Cohesion: 0.06
Nodes (32): dependencies, @apollo/server, argon2, @aws-sdk/client-s3, axios, class-transformer, class-validator, date-fns (+24 more)

### Community 21 - "Submission Calls API"
Cohesion: 0.10
Nodes (17): CreateSubmissionCallDto, IsBoolean, IsDateString, IsNotEmpty, IsOptional, IsString, UpdateSubmissionCallDto, SubmissionCallsController (+9 more)

### Community 22 - "Date Range Picker"
Cohesion: 0.10
Nodes (24): DatePickerWithRange(), DatePickerWithRangeProps, buttonVariants, Calendar(), CalendarDayButton(), Command, CommandEmpty, CommandGroup (+16 more)

### Community 23 - "Messages DTOs"
Cohesion: 0.12
Nodes (15): CreateMessageDto, IsEmail, IsString, UpdateMessageDto, MessagesController, Body, Controller, Delete (+7 more)

### Community 24 - "Flutter Linux Runner"
Cohesion: 0.09
Nodes (25): fl_register_plugins(), main(), first_frame_cb(), my_application_activate(), my_application_class_init(), my_application_dispose(), my_application_init(), my_application_local_command_line() (+17 more)

### Community 25 - "Web Package Manifest"
Cohesion: 0.07
Nodes (29): axios, clsx, date-fns, graphql, lucide-react, react, react-dom, tailwind-merge (+21 more)

### Community 26 - "Categories API"
Cohesion: 0.13
Nodes (14): CategoriesController, Body, Controller, Delete, Get, Param, Patch, Post (+6 more)

### Community 27 - "Posts API"
Cohesion: 0.10
Nodes (17): PostStatus, CreatePostDto, IsEnum, IsOptional, IsString, PostsController, Body, Controller (+9 more)

### Community 28 - "Flutter Build Configs"
Cohesion: 0.09
Nodes (28): Flutter Lints Analysis Config, iOS Launch Image Asset Set, APPLY_STANDARD_SETTINGS (Linux), Linux bundle install steps, Linux runner CMake project (mobile, com.example.mobile), flutter INTERFACE library (Linux), flutter_assemble target (Linux), GTK/GLib/GIO system deps (+20 more)

### Community 29 - "Theme Config API"
Cohesion: 0.11
Nodes (17): apps_api_src_database_db_client_themeconfigs, themeConfigs, apps_api_src_decorators_index_roles, IsOptional, IsString, UpdateThemeConfigDto, ThemeConfigController, Body (+9 more)

### Community 30 - "DrizzleQuery Decorator"
Cohesion: 0.15
Nodes (8): DrizzleQuery, DrizzleQueryParams, parseJson(), Get, Query, applyQuery(), buildCondition(), buildOrGroup()

### Community 31 - "Landing Navbar & Logo"
Cohesion: 0.10
Nodes (20): items, LandingNavbar(), Logo(), LogoProps, ThemeIcon, ThemeLabel, ThemeSwitcher(), ThemeSwitcherProps (+12 more)

### Community 32 - "News API"
Cohesion: 0.12
Nodes (12): NewsController, Body, Controller, Delete, Get, Param, Patch, Post (+4 more)

### Community 33 - "Google OAuth Controller"
Cohesion: 0.11
Nodes (14): AuthGoogleController, Controller, Get, AuthGoogleModule, Module, AuthGoogleService, Injectable, TokensController (+6 more)

### Community 34 - "Crews API"
Cohesion: 0.11
Nodes (15): CrewsController, Body, Controller, Delete, Get, Param, Patch, Post (+7 more)

### Community 35 - "Themes API"
Cohesion: 0.12
Nodes (11): ThemesController, Body, Controller, Delete, Get, Param, Patch, Post (+3 more)

### Community 36 - "Auth API"
Cohesion: 0.16
Nodes (12): AuthController, Body, Controller, Post, UseGuards, LoginDto, RegisterDto, ResetPasswordDto (+4 more)

### Community 37 - "API TS Config"
Cohesion: 0.08
Nodes (23): compilerOptions, allowSyntheticDefaultImports, emitDecoratorMetadata, esModuleInterop, experimentalDecorators, forceConsistentCasingInFileNames, incremental, module (+15 more)

### Community 38 - "Project Docs & READMEs"
Cohesion: 0.09
Nodes (23): NestJS Starter README, robots.txt (disallow /dashboard/, /api/), TanStack Router Loaders, TanStack App Starter README, db:update Migration Workflow (drizzle-kit generate && push), Drizzle Schema (apps/api/src/database/schema), @DrizzleQuery() Param Decorator, Event-driven Email Notifications (event-emitter + Nodemailer) (+15 more)

### Community 39 - "API Dev Dependencies"
Cohesion: 0.09
Nodes (22): devDependencies, dotenv, drizzle-kit, globals, jest, @nestjs/cli, @nestjs/schematics, @nestjs/testing (+14 more)

### Community 40 - "Turbo Pipeline"
Cohesion: 0.09
Nodes (21): dependsOn, cache, cache, cache, dependsOn, persistent, globalPassThroughEnv, $schema (+13 more)

### Community 41 - "Article Schema Types"
Cohesion: 0.14
Nodes (16): apps_api_src_database_db_client_article, apps_api_src_database_db_client_articlestatus, apps_api_src_database_db_client_profile, apps_api_src_database_db_client_submissioncall, apps_api_src_database_db_client_theme, Article, ArticleStatus, Crew (+8 more)

### Community 42 - "Files Upload API"
Cohesion: 0.11
Nodes (12): FilesController, Body, Controller, Delete, Post, UseGuards, FilesService, Injectable (+4 more)

### Community 43 - "Web TS Config"
Cohesion: 0.10
Nodes (20): compilerOptions, allowImportingTsExtensions, jsx, lib, module, moduleResolution, noEmit, noFallthroughCasesInSwitch (+12 more)

### Community 44 - "Root Package Manifest"
Cohesion: 0.10
Nodes (20): clsx, lucide-react, slugify, tailwind-merge, typescript, name, packageManager, private (+12 more)

### Community 45 - "App Module Bootstrap"
Cohesion: 0.11
Nodes (14): DrizzleModule, Module, apps_api_src_database_index_drizzlemodule, LoggerMiddleware, Injectable, Global, ref_dotenv_config, drizzle-kit (+6 more)

### Community 46 - "Win32 Window Base"
Cohesion: 0.16
Nodes (15): wchar_t, Scale(), Create, Destroy, SetQuitOnClose, Show, UpdateTheme, Win32Window::Win32Window() (+7 more)

### Community 47 - "Account Dropdown Menu"
Cohesion: 0.14
Nodes (13): AccountDropdown(), DropdownMenu(), DropdownMenuCheckboxItem(), DropdownMenuContent(), DropdownMenuItem(), DropdownMenuLabel(), DropdownMenuRadioItem(), DropdownMenuSeparator() (+5 more)

### Community 48 - "Sitemap Controller"
Cohesion: 0.16
Nodes (11): News, posts, AllowAnonymous(), SitemapController, Controller, Get, SitemapModule, Module (+3 more)

### Community 49 - "Analytics Tracking API"
Cohesion: 0.18
Nodes (10): AnalyticsController, Body, Controller, Post, TrackVisitDto, IsString, AnalyticsModule, Module (+2 more)

### Community 50 - "Flutter Counter App"
Cohesion: 0.12
Nodes (16): build, _counter, createState, _incrementCounter, main, MyApp, MyHomePage, _MyHomePageState (+8 more)

### Community 51 - "Flutter Windows Window"
Cohesion: 0.16
Nodes (18): FlutterWindow, flutter_controller_, OnCreate, OnDestroy, project_, DartProject, HWND, Win32Window (+10 more)

### Community 52 - "Google Auth & Turnstile UI"
Cohesion: 0.15
Nodes (11): GoogleAuthButton(), GoogleAuthButtonProps, Turnstile(), TurnstileProps, Container(), RegisterFormData, registerSchema, PasswordResetFormData (+3 more)

### Community 53 - "Shadcn Components Config"
Cohesion: 0.12
Nodes (16): Registry Configuration (components.json registries), aliases, components, hooks, lib, ui, utils, iconLibrary (+8 more)

### Community 54 - "Profile API"
Cohesion: 0.18
Nodes (9): ProfileController, Body, Controller, Get, Param, Patch, UseGuards, ProfileService (+1 more)

### Community 55 - "Shadcn Theming Rules"
Cohesion: 0.19
Nodes (16): shadcn Customization & Theming, --radius Global Border Radius, Semantic CSS Variable Tokens, Component Customization Order (variants, className, cva variant, wrapper), Add Variant via cva, Dark Mode via .dark class and next-themes, OKLCH Color Format, Wrapper Components (e.g. ConfirmDialog) (+8 more)

### Community 56 - "App Providers & Loader"
Cohesion: 0.16
Nodes (10): LoadingIndicator(), AnalyticsTracker(), AppProviders, LoaderState, useLoaderStore, @fontsource/poppins, @react-oauth/google, ref_styles_css_url (+2 more)

### Community 57 - "Markdown & About Page"
Cohesion: 0.15
Nodes (9): Markdown(), MarkdownProps, Route, Route, Route, ref_contents_about_md_raw, ref_contents_privacy_md_raw, ref_contents_terms_md_raw (+1 more)

### Community 58 - "Theme Config Frontend"
Cohesion: 0.19
Nodes (12): ThemeConfig, ThemeConfigProvider(), UpdateThemeConfigInput, useThemeConfig(), useUpdateThemeConfig(), FONT_OPTIONS, PRESETS, RADIUS_OPTIONS (+4 more)

### Community 59 - "Stats GraphQL Module"
Cohesion: 0.15
Nodes (10): StatsModule, Module, StatsResolver, Query, formatDateTR(), StatsService, toDateBound(), Injectable (+2 more)

### Community 60 - "Users Controller"
Cohesion: 0.18
Nodes (9): Body, Controller, Delete, Get, Param, Patch, Post, UseGuards (+1 more)

### Community 61 - "Windows Runner Entry"
Cohesion: 0.18
Nodes (13): wWinMain(), wchar_t, CreateAndAttachConsole(), GetCommandLineArguments(), Utf8FromUtf16(), flutter_windows, _In_, _In_opt_ (+5 more)

### Community 62 - "Field Form Primitives"
Cohesion: 0.13
Nodes (7): FieldErrorMessageProps, FieldHelperTextProps, FieldInputProps, FieldLabelProps, FieldRootProps, FieldSelectProps, FieldTextAreaProps

### Community 63 - "Oxlint Config"
Cohesion: 0.13
Nodes (14): attributes, components, polymorphicPropName, plugins, formComponents, linkComponents, version, rules (+6 more)

### Community 64 - "Emails Package Manifest"
Cohesion: 0.13
Nodes (13): dependencies, @react-email/components, exports, react, react-dom, @types/react, @types/react-dom, name (+5 more)

### Community 65 - "Shadcn CLI Reference"
Cohesion: 0.21
Nodes (14): shadcn CLI Reference, add command, apply command, build command (custom registry), diff command, docs command, Dry-Run / --diff / --view Mode, init command (+6 more)

### Community 66 - "API Scripts"
Cohesion: 0.14
Nodes (14): scripts, build, db:studio, db:update, debug, dev, prod, start (+6 more)

### Community 67 - "Web Dev Dependencies"
Cohesion: 0.14
Nodes (14): devDependencies, jsdom, @tanstack/devtools-vite, @testing-library/dom, @testing-library/react, @types/cloudflare-turnstile, @types/node, @types/react (+6 more)

### Community 68 - "Article Email Templates"
Cohesion: 0.18
Nodes (5): ArticleStatusUpdatedEmailProps, ArticleSubmittedAdminEmailProps, NewPostEmailProps, ResetPasswordEmailProps, @react-email/components

### Community 69 - "Shadcn Form Rules"
Cohesion: 0.17
Nodes (13): Button Loading via Spinner (no isLoading), Forms & Inputs Rules, Field Validation (data-invalid + aria-invalid), FieldGroup + Field Form Layout, FieldSet + FieldLegend Grouping, Choosing Form Controls, Buttons in Inputs via InputGroupAddon, InputGroup Requires InputGroupInput/InputGroupTextarea (+5 more)

### Community 70 - "Themes DTOs"
Cohesion: 0.24
Nodes (8): apps_api_src_database_db_client_posts, apps_api_src_database_db_client_themes, themes, CreateThemeDto, IsString, UpdateThemeDto, ThemesModule, Module

### Community 71 - "Mail Service"
Cohesion: 0.33
Nodes (4): MailService, Injectable, sleep(), OnEvent

### Community 72 - "Web PWA Manifest"
Cohesion: 0.17
Nodes (11): background_color, categories, description, display, icons, lang, name, orientation (+3 more)

### Community 73 - "Oxfmt Config"
Cohesion: 0.17
Nodes (11): experimentalSortImports, experimentalSortPackageJson, sortScripts, experimentalTailwindcss, jsxSingleQuote, printWidth, $schema, semi (+3 more)

### Community 74 - "Shadcn Composition Rules"
Cohesion: 0.18
Nodes (11): Component Composition Rules, Callouts Use Alert, Avatar Needs AvatarFallback, Full Card Composition, Empty States Use Empty, Items Always Inside Their Group, Choosing Overlay Components, Dialog/Sheet/Drawer Title Required (+3 more)

### Community 75 - "Nest CLI Config"
Cohesion: 0.18
Nodes (10): collection, compilerOptions, assets, builder, deleteOutDir, generateOptions, baseDir, spec (+2 more)

### Community 76 - "Flutter Web Manifest"
Cohesion: 0.18
Nodes (10): background_color, description, display, icons, name, orientation, prefer_related_applications, short_name (+2 more)

### Community 77 - "Flutter Window Impl"
Cohesion: 0.18
Nodes (10): DartProject, HWND, LPARAM, LRESULT, UINT, WPARAM, FlutterWindow::FlutterWindow(), MessageHandler (+2 more)

### Community 78 - "Jest Config"
Cohesion: 0.20
Nodes (10): jest, collectCoverageFrom, coverageDirectory, moduleFileExtensions, moduleNameMapper, rootDir, testEnvironment, testRegex (+2 more)

### Community 79 - "Articles & Messages Schema"
Cohesion: 0.20
Nodes (9): apps_api_src_database_db_client_articles, apps_api_src_database_db_client_messages, apps_api_src_database_db_client_pagevisits, apps_api_src_database_db_client_postreactions, articles, messages, pageVisits, postReactions (+1 more)

### Community 80 - "Win32 DPI Handling"
Cohesion: 0.36
Nodes (10): HWND, LPARAM, LRESULT, UINT, WPARAM, EnableFullDpiSupportIfAvailable(), GetHandle, GetThisFromHandle (+2 more)

### Community 81 - "Blog Routes & SEO"
Cohesion: 0.36
Nodes (9): Route, Route, Route, Route, DEFAULT_SEO, generateCanonicalUrl(), generateMetaTags(), generateStructuredData() (+1 more)

### Community 82 - "Root Dependencies"
Cohesion: 0.20
Nodes (10): dependencies, @as-integrations/express5, clsx, cmdk, @dotenvx/dotenvx, lucide-react, @radix-ui/react-dialog, @radix-ui/react-popover (+2 more)

### Community 83 - "Root Scripts"
Cohesion: 0.20
Nodes (10): scripts, build, check-types, db:update, dev, dotenvx, format, lint (+2 more)

### Community 84 - "Emails TS Config"
Cohesion: 0.20
Nodes (9): compilerOptions, composite, jsx, noEmit, skipLibCheck, strict, strictNullChecks, exclude (+1 more)

### Community 85 - "Shadcn MCP Tools"
Cohesion: 0.42
Nodes (9): shadcn MCP Server, shadcn:get_add_command_for_items, shadcn:get_audit_checklist, shadcn:get_item_examples_from_registries, shadcn:get_project_registries, shadcn:list_items_in_registries, shadcn MCP Server (stdio), shadcn:search_items_in_registries (+1 more)

### Community 86 - "Shadcn Base vs Radix"
Cohesion: 0.28
Nodes (9): Base vs Radix Rules, Accordion type and defaultValue, asChild (radix) vs render (base) Composition, nativeButton={false} for Non-button render, Select API Differences (items prop, placeholder, positioning), Base Select Multiple & Object Values, Slider Scalar vs Array, ToggleGroup type vs multiple (+1 more)

### Community 87 - "Google OAuth Callback"
Cohesion: 0.28
Nodes (3): Body, Post, UseGuards

### Community 88 - "User DTOs"
Cohesion: 0.22
Nodes (9): CreateUserDto, IsDateString, IsEmail, IsEnum, IsOptional, IsString, MaxLength, MinLength (+1 more)

### Community 89 - "Vite Config"
Cohesion: 0.22
Nodes (8): config, nitro, @tailwindcss/vite, @tanstack/devtools-vite, @tanstack/react-start, vite, vite-tsconfig-paths, @vitejs/plugin-react

### Community 90 - "Shadcn Agent Skill"
Cohesion: 0.25
Nodes (8): shadcn OpenAI Agent Interface Config, shadcn/ui Agent Interface (display_name, icons), Built-in Variants First, shadcn Skill (SKILL.md), Built-in Variants Before Custom Styles, Compose, Don't Reinvent, Use Project Package Runner (npx/pnpm dlx/bunx), shadcn Workflow

### Community 91 - "Shadcn Styling Rules"
Cohesion: 0.25
Nodes (8): info command, search command, Adding Custom Colors (Tailwind v3/v4), Separator/Skeleton/Badge Over Custom Markup, Use Configured iconLibrary, No Raw Colors for Status Indicators, Project Context via shadcn info --json, Use Existing Components First

### Community 92 - "App Controller Hello"
Cohesion: 0.29
Nodes (5): AppController, Controller, Get, AppService, Injectable

### Community 93 - "Dashboard Stats Types"
Cohesion: 0.46
Nodes (6): DashboardStats, StatusCount, TimeSeriesPoint, Field, ObjectType, @nestjs/graphql

### Community 94 - "Windows Runner Headers"
Cohesion: 0.39
Nodes (5): dart_project, flutter_view_controller, functional, memory, windows

### Community 95 - "Win32 Geometry Types"
Cohesion: 0.21
Nodes (6): Point, x, y, Size, height, width

### Community 97 - "Archive Page"
Cohesion: 0.25
Nodes (3): ArchiveGenre, ArchiveMagazine, Route

### Community 98 - "Architecture Concepts"
Cohesion: 0.25
Nodes (8): Axios API Client (api-client.ts), Route Auth Decorators (@AllowAnonymous, @OptionalAuth, @Roles, @Auth), AuthGuard (context-aware HTTP+GraphQL), GraphQL Client (graphql-client.ts), Opaque Session-Token Authentication, RBAC (ADMIN / USER), REST-primary API with Code-first GraphQL Layer, TokensService

### Community 99 - "Root Dev Tooling"
Cohesion: 0.25
Nodes (8): devDependencies, husky, lint-staged, oxfmt, oxlint, oxlint-tsgolint, turbo, @types/bun

### Community 100 - "App E2E Tests"
Cohesion: 0.29
Nodes (5): AppModule, Module, @nestjs/testing, supertest, ref_supertest_types

### Community 101 - "News DTOs"
Cohesion: 0.43
Nodes (7): CreateNewsDto, IsBoolean, IsNotEmpty, IsOptional, IsString, MinLength, UpdateNewsDto

### Community 102 - "Web Scripts"
Cohesion: 0.29
Nodes (7): scripts, build, dev, preview, start, test, type-check

### Community 103 - "Web API Client"
Cohesion: 0.33
Nodes (3): FileInputProps, apiClient, ref_axios

### Community 104 - "Layout Routes"
Cohesion: 0.29
Nodes (3): LandingFooter(), Route, Route

### Community 105 - "Query DTOs"
Cohesion: 0.40
Nodes (5): QueryPostsDto, apps_api_src_utils_index_basequerydto, BaseQueryDto, IsOptional, Type

### Community 106 - "Shadcn Tailwind Config"
Cohesion: 0.33
Nodes (6): tailwind, baseColor, config, css, cssVariables, prefix

### Community 107 - "HALO Brand Assets"
Cohesion: 0.60
Nodes (6): HALO Banner Desktop (landscape hero: hands reaching toward glowing halo ring, 'PAU | Ingiliz Dili ve Edebiyati', 'Aylik Fikir, Sanat ve Edebiyat Dergisi'), HALO Banner Mobile (portrait variant of hero banner, same yellow halo theme and taglines), Halo Dark-Mode Logo (light/white script 'Halo' with circle, for dark backgrounds), Halo Light-Mode Logo (black script 'Halo' with open circle, for light backgrounds), HALO Magazine Brand Identity (PAU English Language & Literature monthly thought, art and literature magazine), Halo Square Logo (script 'Halo' on gold radial gradient; favicon / OG image / publisher logo)

### Community 108 - "Alert Component"
Cohesion: 0.40
Nodes (5): Alert, AlertDescription, AlertTitle, alertVariants, class-variance-authority

### Community 109 - "Router Setup"
Cohesion: 0.47
Nodes (5): getRouter(), ErrorComponent(), NotFound(), Register, routeTree

### Community 110 - "Emails Dev Dependencies"
Cohesion: 0.33
Nodes (6): devDependencies, react-email, @react-email/preview-server, tsdown, @types/react, @types/react-dom

### Community 112 - "Windows Plugin Registrant"
Cohesion: 0.40
Nodes (3): RegisterPlugins(), plugin_registry, PluginRegistry

### Community 113 - "Legal & Magazine Content"
Cohesion: 0.50
Nodes (5): HALO Edebiyat Dergisi (Pamukkale University ELL magazine), Permanent vs Guest Writers (Kalici / Konuk Yazarlar), Privacy Policy (Gizlilik Politikasi), Terms of Use (Kullanim Sartlari), PWA manifest.json

### Community 114 - "Vite Env Types"
Cohesion: 0.40
Nodes (4): @fontsource/poppins, ImportMeta, ImportMetaEnv, Window

### Community 115 - "Emails Scripts"
Cohesion: 0.40
Nodes (5): scripts, build, export, start:dev, type-check

### Community 118 - "API Build TS Config"
Cohesion: 0.50
Nodes (3): exclude, extends, ./tsconfig.json

### Community 119 - "Account Layout Route"
Cohesion: 0.50
Nodes (3): Route, RouteComponent(), tabs

### Community 120 - "Profile DTO"
Cohesion: 0.67
Nodes (3): CreateProfileDto, IsOptional, IsString

### Community 122 - "iOS Launch Images"
Cohesion: 0.67
Nodes (3): iOS Launch Image LaunchImage@2x.png (blank placeholder), iOS Launch Image LaunchImage@3x.png (blank placeholder), iOS Launch Image LaunchImage.png (blank placeholder)

### Community 123 - "Emails Peer Deps"
Cohesion: 0.67
Nodes (3): peerDependencies, react, react-dom

## Ambiguous Edges - Review These
- `Drizzle Schema (apps/api/src/database/schema)` → `packages/db Shared Drizzle Schema (per GEMINI.md)`  [AMBIGUOUS]
  GEMINI.md · relation: conceptually_related_to
- `Privacy Policy (Gizlilik Politikasi)` → `Terms of Use (Kullanim Sartlari)`  [AMBIGUOUS]
  apps/web/src/contents/terms.md · relation: conceptually_related_to

## Knowledge Gaps
- **700 isolated node(s):** `$schema`, `sortScripts`, `experimentalSortImports`, `experimentalTailwindcss`, `printWidth` (+695 more)
  These have ≤1 connection - possible missing edges or undocumented components. (Counts symbols only; 1070 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)
- **28 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **What is the exact relationship between `Drizzle Schema (apps/api/src/database/schema)` and `packages/db Shared Drizzle Schema (per GEMINI.md)`?**
  _Edge tagged AMBIGUOUS (relation: conceptually_related_to) - confidence is low._
- **What is the exact relationship between `Privacy Policy (Gizlilik Politikasi)` and `Terms of Use (Kullanim Sartlari)`?**
  _Edge tagged AMBIGUOUS (relation: conceptually_related_to) - confidence is low._
- **Why does `@nestjs/common` connect `App Core & Guards` to `Google OAuth Controller`, `API Constants & DB Client`, `App E2E Tests`, `Themes DTOs`, `API Package Manifest`, `App Module Bootstrap`, `AuthGuard & Account Access`, `Articles & Messages Schema`, `Sitemap Controller`, `Roles & Auth Decorators`, `Analytics Tracking API`, `Messages DTOs`, `Categories API`, `Stats GraphQL Module`, `Theme Config API`, `DrizzleQuery Decorator`?**
  _High betweenness centrality (0.051) - this node is a cross-community bridge._
- **Why does `Roles()` connect `Roles & Auth Decorators` to `App Core & Guards`, `AuthGuard & Account Access`, `Articles API`, `Account API`, `Submission Calls API`, `Messages DTOs`, `Categories API`, `Posts API`, `Theme Config API`, `DrizzleQuery Decorator`, `News API`, `Google OAuth Controller`, `Crews API`, `Themes API`, `Files Upload API`, `Analytics Tracking API`, `Stats GraphQL Module`, `Users Controller`, `Themes DTOs`, `Google OAuth Callback`, `Dashboard Stats Types`?**
  _High betweenness centrality (0.050) - this node is a cross-community bridge._
- **Why does `dependencies` connect `Web Runtime Dependencies` to `Web Package Manifest`?**
  _High betweenness centrality (0.027) - this node is a cross-community bridge._
- **What connects `$schema`, `sortScripts`, `experimentalSortImports` to the rest of the system?**
  _700 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Form UI Components` be split into smaller, more focused modules?**
  _Cohesion score 0.10378378378378378 - nodes in this community are weakly interconnected._