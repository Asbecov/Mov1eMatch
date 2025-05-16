import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mmm/common/constants/routing_constants.dart';
import 'package:mmm/features/home/widgets/home_button.dart';

class HomeRoute extends StatelessWidget {
  const HomeRoute({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Center(
          child: SizedBox(
            height: kToolbarHeight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                spacing: 20,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SelectableButton(
                    selected: navigationShell.currentIndex == 0,
                    icon: Icons.group_work,
                    label: 'создать',
                    onTap: () => context.goNamed(createName),
                  ),
                  SelectableButton(
                    selected: navigationShell.currentIndex == 1,
                    icon: Icons.auto_awesome,
                    label: 'подборки',
                    onTap: () => context.goNamed(collectionsName),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: navigationShell,
    );
  }
}
