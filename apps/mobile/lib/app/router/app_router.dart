import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/account/presentation/screens/account_screen.dart';
import '../../features/account/presentation/screens/change_password_screen.dart';
import '../../features/account/presentation/screens/edit_profile_screen.dart';
import '../../features/account/presentation/screens/notification_settings_screen.dart';
import '../../features/auth/domain/entities/user.dart';
import '../../features/info/presentation/screens/contact_screen.dart';
import '../../features/info/presentation/screens/markdown_page_screen.dart';
import '../../features/info/presentation/screens/team_screen.dart';
import '../../features/auth/presentation/controllers/auth_controller.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/news/presentation/screens/news_detail_screen.dart';
import '../../features/news/presentation/screens/news_screen.dart';
import '../../features/posts/presentation/screens/issue_reader_screen.dart';
import '../../features/posts/presentation/screens/post_detail_screen.dart';
import '../../features/posts/presentation/screens/posts_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/submissions/presentation/screens/call_detail_screen.dart';
import '../../features/submissions/presentation/screens/calls_screen.dart';
import '../../features/submissions/presentation/screens/my_submissions_screen.dart';
import '../../features/submissions/presentation/screens/submit_screen.dart';
import '../shell/app_shell.dart';

abstract final class Routes {
  static const splash = '/splash';
  static const login = '/login';
  static const register = '/register';
  static const forgotPassword = '/forgot-password';

  static const home = '/';
  static String post(String idOrSlug) => '/posts/${_seg(idOrSlug)}';
  static String issueReader(String idOrSlug) => '${post(idOrSlug)}/read';

  static const news = '/news';
  static String newsItem(String idOrSlug) => '$news/${_seg(idOrSlug)}';

  static const calls = '/calls';
  static String call(String id) => '$calls/${_seg(id)}';
  static String submit(String callId) => '${call(callId)}/submit';

  static const account = '/account';
  static const mySubmissions = '$account/submissions';
  static const settings = '$account/settings';
  static const about = '$account/about';
  static const team = '$account/team';
  static const contact = '$account/contact';
  static const privacy = '$account/privacy';
  static const terms = '$account/terms';
  static const editProfile = '$account/profile';
  static const changePassword = '$account/password';
  static const notificationSettings = '$account/notifications';

  /// Where an auth screen at [uri] sends the user once signed in: its `from`
  /// parameter if that is an in-app path (never an arbitrary URL), else home.
  static String afterSignIn(Uri uri) {
    final from = uri.queryParameters['from'];
    return from != null && from.startsWith('/') && !from.startsWith('//')
        ? from
        : home;
  }

  /// Login that returns to [from] once signed in.
  static String loginFrom(String from) =>
      Uri(path: login, queryParameters: {'from': from}).toString();

  static const _authRoutes = {login, register, forgotPassword};

  /// The user's own account pages and the submit form need a session;
  /// everything else (content, calls, the `/account` tab, info pages) is public.
  static bool _requiresSession(String path) =>
      _sessionPaths.contains(path) || _submitPath.hasMatch(path);

  /// Info pages (about, team, contact, legal) under `/account` stay public.
  static const _sessionPaths = {
    editProfile,
    changePassword,
    notificationSettings,
    mySubmissions,
  };

  static final _submitPath = RegExp(r'^/calls/[^/]+/submit$');

  static String _seg(String value) => Uri.encodeComponent(value);
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  final auth = ValueNotifier<AsyncValue<User?>>(const AsyncLoading());
  ref.listen(
    authControllerProvider,
    (_, next) => auth.value = next,
    fireImmediately: true,
  );

  final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: Routes.splash,
    refreshListenable: auth,
    redirect: (context, state) => authRedirect(auth.value, state.uri),
    routes: [
      GoRoute(
        path: Routes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: Routes.login,
        builder: (context, state) {
          final params = state.uri.queryParameters;
          return LoginScreen(
            initialEmail: params['email'],
            justRegistered: params['registered'] == '1',
          );
        },
      ),
      GoRoute(
        path: Routes.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: Routes.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => AppShell(navigationShell: shell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.home,
                builder: (context, state) => const PostsScreen(),
                routes: [
                  GoRoute(
                    path: 'posts/:idOrSlug',
                    builder: (context, state) => PostDetailScreen(
                      idOrSlug: state.pathParameters['idOrSlug']!,
                    ),
                    routes: [
                      GoRoute(
                        path: 'read',
                        // Full screen, above the bottom navigation.
                        parentNavigatorKey: _rootNavigatorKey,
                        builder: (context, state) {
                          final extra = state.extra;
                          final autoDownload =
                              extra is Map && extra['autoDownload'] == true;
                          return IssueReaderScreen(
                            idOrSlug: state.pathParameters['idOrSlug']!,
                            autoDownload: autoDownload,
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.news,
                builder: (context, state) => const NewsScreen(),
                routes: [
                  GoRoute(
                    path: ':idOrSlug',
                    builder: (context, state) => NewsDetailScreen(
                      idOrSlug: state.pathParameters['idOrSlug']!,
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.calls,
                builder: (context, state) => const CallsScreen(),
                routes: [
                  GoRoute(
                    path: ':callId',
                    builder: (context, state) => CallDetailScreen(
                      callId: state.pathParameters['callId']!,
                    ),
                    routes: [
                      GoRoute(
                        path: 'submit',
                        builder: (context, state) => SubmitScreen(
                          callId: state.pathParameters['callId']!,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.account,
                builder: (context, state) => const AccountScreen(),
                routes: [
                  GoRoute(
                    path: 'profile',
                    builder: (context, state) => const EditProfileScreen(),
                  ),
                  GoRoute(
                    path: 'password',
                    builder: (context, state) => const ChangePasswordScreen(),
                  ),
                  GoRoute(
                    path: 'settings',
                    builder: (context, state) => const SettingsScreen(),
                  ),
                  GoRoute(
                    path: 'about',
                    builder: (context, state) => const MarkdownPageScreen(
                      title: 'Hakkımızda',
                      asset: 'assets/contents/about.md',
                    ),
                  ),
                  GoRoute(
                    path: 'team',
                    builder: (context, state) => const TeamScreen(),
                  ),
                  GoRoute(
                    path: 'contact',
                    builder: (context, state) => const ContactScreen(),
                  ),
                  GoRoute(
                    path: 'privacy',
                    builder: (context, state) => const MarkdownPageScreen(
                      title: 'Gizlilik Politikası',
                      asset: 'assets/contents/privacy.md',
                    ),
                  ),
                  GoRoute(
                    path: 'terms',
                    builder: (context, state) => const MarkdownPageScreen(
                      title: 'Kullanım Şartları',
                      asset: 'assets/contents/terms.md',
                    ),
                  ),
                  GoRoute(
                    path: 'submissions',
                    builder: (context, state) => const MySubmissionsScreen(),
                  ),
                  GoRoute(
                    path: 'notifications',
                    builder: (context, state) =>
                        const NotificationSettingsScreen(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );

  ref.onDispose(() {
    router.dispose();
    auth.dispose();
  });
  return router;
});

@visibleForTesting
String? authRedirect(AsyncValue<User?> auth, Uri uri) {
  final path = uri.path;

  // Initial restore still running, or it failed (e.g. API unreachable).
  if (!auth.hasValue) return path == Routes.splash ? null : Routes.splash;
  if (path == Routes.splash) return Routes.home;

  final signedIn = auth.value != null;
  if (!signedIn && Routes._requiresSession(path)) {
    return Routes.loginFrom(uri.toString());
  }
  if (signedIn && Routes._authRoutes.contains(path)) {
    return Routes.afterSignIn(uri);
  }
  return null;
}
