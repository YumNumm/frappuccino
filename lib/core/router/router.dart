import 'package:flutter/material.dart';
import 'package:frappuccino/features/error/error_page.dart';
import 'package:frappuccino/features/home/home_page.dart';
import 'package:frappuccino/features/splash/splash_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'router.g.dart';

@Riverpod(keepAlive: true)
GoRouter router(RouterRef ref) => GoRouter(
      routes: $appRoutes,
      errorBuilder: (context, state) => const ErrorPage(),
      initialLocation: const SplashRoute().location,
    );

@TypedGoRoute<AuthRoute>(path: '/auth')
class AuthRoute extends GoRouteData {
  const AuthRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SizedBox();
  }
}

@TypedGoRoute<ErrorRoute>(path: '/error')
class ErrorRoute extends GoRouteData {
  const ErrorRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) => const ErrorPage();
}

@TypedGoRoute<SplashRoute>(path: '/splash')
class SplashRoute extends GoRouteData {
  const SplashRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const SplashScreen();
}

@TypedGoRoute<HomeRoute>(path: '/')
class HomeRoute extends GoRouteData {
  const HomeRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) => const HomePage();
}
