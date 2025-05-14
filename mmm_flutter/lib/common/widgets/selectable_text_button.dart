import 'package:flutter/material.dart';

import 'package:mmm/common/constants/app_constants.dart';

class SelectableTextButton extends StatefulWidget {
  const SelectableTextButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.tooltip,
  });

  final IconData icon;
  final String label;
  final void Function() onTap;
  final String? tooltip;

  @override
  State<SelectableTextButton> createState() => _BottomBarButtonState();
}

class _BottomBarButtonState extends State<SelectableTextButton> {
  late final FocusNode _focusNode;

  final GlobalKey<TooltipState> _tooltipKey = GlobalKey<TooltipState>();

  late ColorScheme _colorScheme;

  @override
  void initState() {
    super.initState();

    _focusNode = FocusNode()..addListener(_handleFocusChange);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _colorScheme = Theme.of(context).colorScheme;
  }

  @override
  void dispose() {
    _focusNode.dispose();

    super.dispose();
  }

  void _handleFocusChange() => setState(() {
        if (_focusNode.hasFocus) {
          _tooltipKey.currentState?.ensureTooltipVisible();
        } else {
          Tooltip.dismissAllToolTips();
        }
      });

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    return Tooltip(
      key: _tooltipKey,
      preferBelow: true,
      message: widget.label,
      triggerMode: TooltipTriggerMode.manual,
      child: Material(
        color: themeData.colorScheme.primaryContainer,
        shape: RoundedRectangleBorder(
          side: _focusNode.hasFocus
              ? BorderSide(color: _colorScheme.outline, width: rimSize)
              : BorderSide.none,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          focusNode: _focusNode,
          onTap: widget.onTap,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              spacing: 5.0,
              children: [
                Icon(widget.icon),
                Text(widget.label),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
