import 'package:flutter/material.dart';
import 'package:movie_match/common/constants/app_constants.dart';

class SelectableRadioButton extends StatefulWidget {
  const SelectableRadioButton({
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
  State<SelectableRadioButton> createState() => _SelectableRadioState();
}

class _SelectableRadioState extends State<SelectableRadioButton> {
  late final FocusNode _focusNode;

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

  void _handleFocusChange() => setState(() {});

  @override
  Widget build(BuildContext context) => Material(
        color: widget.selected
            ? _colorScheme.primaryContainer
            : _colorScheme.surfaceContainer,
        shape: RoundedRectangleBorder(
          side: _focusNode.hasFocus
              ? BorderSide(color: _colorScheme.outline, width: rimSize)
              : BorderSide.none,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: InkWell(
          focusNode: _focusNode,
          onTap: widget.onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 5.0,
              horizontal: 10.0,
            ),
            child: Row(
              spacing: 10,
              children: <Widget>[
                Icon(widget.icon),
                Text(widget.label),
              ],
            ),
          ),
        ),
      );
}
