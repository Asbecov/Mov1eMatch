import 'package:flutter/material.dart';
import 'package:mmm/common/constants/app_constants.dart';

class SelectableButton extends StatefulWidget {
  const SelectableButton({
    super.key,
    required this.selected,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final bool selected;
  final IconData icon;
  final String label;
  final void Function() onTap;

  @override
  State<SelectableButton> createState() => _HomeButtonState();
}

class _HomeButtonState extends State<SelectableButton> {
  bool _focused = false;

  void _handleFocusChange(bool isFocused) => setState(() {
        _focused = isFocused;
      });

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: _focused ? themeData.colorScheme.outline : Colors.transparent,
          width: rimSize,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Material(
          color: widget.selected
              ? themeData.colorScheme.primaryContainer
              : themeData.colorScheme.surfaceContainer,
          child: InkWell(
            onFocusChange: _handleFocusChange,
            onTap: widget.onTap,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
              child: Row(
                spacing: 10,
                children: <Widget>[
                  Icon(widget.icon),
                  Text(widget.label),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
