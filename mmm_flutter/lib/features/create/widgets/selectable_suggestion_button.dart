import 'package:flutter/material.dart';

import 'package:mmm/common/constants/app_constants.dart';

class SelectableSuggestionButton extends StatefulWidget {
  const SelectableSuggestionButton({
    super.key,
    required this.onTap,
    required this.suggestion,
  });

  final void Function() onTap;
  final String suggestion;

  @override
  State<SelectableSuggestionButton> createState() =>
      _SelectableSuggestionButtonState();
}

class _SelectableSuggestionButtonState
    extends State<SelectableSuggestionButton> {
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
  Widget build(BuildContext context) => Container(
        margin: EdgeInsets.only(top: 10.0, right: 10.0, left: 10.0),
        height: 60,
        child: Material(
          color: _colorScheme.primaryContainer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side: _focusNode.hasFocus
                ? BorderSide(color: _colorScheme.outline, width: rimSize)
                : BorderSide.none,
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            focusNode: _focusNode,
            onTap: widget.onTap,
            child: Padding(
              padding: EdgeInsets.all(5.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(widget.suggestion),
              ),
            ),
          ),
        ),
      );
}
