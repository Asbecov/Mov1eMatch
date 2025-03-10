import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mmm/features/create/views/create_view.dart';

final GoRouter route = GoRouter(
  routes: <RouteBase>[
    ShellRoute(
      builder: (context, state, child) => HomeRoute(state: state, child: child),
      routes: <GoRoute>[
        GoRoute(
          path: createRoute, // Ensure this is NOT '/' if inside a ShellRoute
          builder: (context, state) => const CreateView(),
        ),
        GoRoute(
          path: collectionsRoute,
          builder: (context, state) => const Placeholder(),
        ),
      ],
    ),
    GoRoute(
      path: vottingRoute,
      builder: (context, state) => const Placeholder(),
      routes: <GoRoute>[
        GoRoute(
          path: resultsRoute,
          builder: (context, state) => const Placeholder(),
        ),
      ],
    ),
  ],
);

const String createRoute = '/';
const String collectionsRoute = '/collections';

const String vottingRoute = '/voting';
const String resultsRoute = '/results';

class HomeRoute extends StatelessWidget {
  const HomeRoute({
    super.key,
    required this.state,
    required this.child,
  });

  final GoRouterState state;
  final Widget child;

  @override
  Widget build(BuildContext context) => child;
}
