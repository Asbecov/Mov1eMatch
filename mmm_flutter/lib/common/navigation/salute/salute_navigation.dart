import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:movie_match/common/models/salute/models.dart';
import 'package:movie_match/main.dart';

class SaluteNavigation extends StatefulWidget {
  const SaluteNavigation({super.key, required this.child});

  final Widget child;

  @override
  State<SaluteNavigation> createState() => _NavigationState();
}

class _NavigationState extends State<SaluteNavigation> {
  late final StreamSubscription<String>? _saluteHandlerSubscription;

  @override
  void initState() {
    super.initState();

    _saluteHandlerSubscription =
        saluteHandler?.navigationEventStream.listen(_saluteHandlerListener);
  }

  void _saluteHandlerListener(String data) {
    try {
      final NavigationCommand command = NavigationCommand.fromJson(
        jsonDecode(data),
      );
      final FocusManager manager = FocusManager.instance;

      manager.primaryFocus?.focusInDirection(switch (command.command) {
        NavCommand.down => TraversalDirection.down,
        NavCommand.left => TraversalDirection.left,
        NavCommand.up => TraversalDirection.up,
        NavCommand.right => TraversalDirection.right,
      });
    } finally {
      if (kDebugMode) print("Salute Navigation: $data");
    }
  }

  @override
  void dispose() {
    _saluteHandlerSubscription?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
