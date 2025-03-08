import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mmm/common/constants/app_constants.dart';

class HomeButton extends StatefulWidget {
  const HomeButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final void Function() onTap;

  @override
  State<HomeButton> createState() => _HomeButtonState();
}

class _HomeButtonState extends State<HomeButton> {
  bool focused = false;

  void _handleFocusChange(bool isFocused) => setState(() {
        focused = isFocused;
      });

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: focused ? themeData.colorScheme.primary : Colors.transparent,
          width: 3.0,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Material(
          color: themeData.colorScheme.onSurface,
          child: InkWell(
            onFocusChange: _handleFocusChange,
            onTap: widget.onTap,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                textBaseline: TextBaseline.alphabetic,
                spacing: 25.0,
                children: <Widget>[
                  AspectRatio(
                    aspectRatio: 1.0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: themeData.colorScheme.primary,
                        borderRadius: BorderRadius.circular(borderRadius),
                      ),
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(10.0),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final double size = max(
                            constraints.maxHeight,
                            constraints.minWidth,
                          );

                          return Icon(
                            widget.icon,
                            color: themeData.colorScheme.onPrimary,
                            size: size,
                          );
                        },
                      ),
                    ),
                  ),
                  Text(
                    widget.label,
                    style: themeData.textTheme.labelMedium,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
