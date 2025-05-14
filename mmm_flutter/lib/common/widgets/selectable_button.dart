import 'package:flutter/material.dart';

import 'package:mmm/common/constants/app_constants.dart';

class SelectableButton extends StatefulWidget {
  const SelectableButton({
    super.key,
    required this.icon,
    required this.onTap,
    required this.tooltip,
  });

  final IconData icon;
  final void Function() onTap;
  final String? tooltip;

  @override
  State<SelectableButton> createState() => _BottomBarButtonState();
}

class _BottomBarButtonState extends State<SelectableButton> {
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
      message: widget.tooltip,
      triggerMode: TooltipTriggerMode.manual,
      child: AspectRatio(
        aspectRatio: 1.0,
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
            child: Center(
              child: Icon(widget.icon),
            ),
          ),
        ),
      ),
    );
  }
}
