import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
