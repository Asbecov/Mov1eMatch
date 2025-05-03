import 'package:flutter/material.dart';

import 'package:mmm/common/constants/app_constants.dart';

class MovieMatcherTextField extends StatefulWidget {
  const MovieMatcherTextField({
    super.key,
    required this.hint,
    required this.textEditingController,
  });

  final String hint;
  final TextEditingController textEditingController;

  @override
  State<MovieMatcherTextField> createState() => _MovieMatcherTextFieldState();
}

class _MovieMatcherTextFieldState extends State<MovieMatcherTextField> {
  late final FocusNode _focusNode;
  late ColorScheme colorScheme;

  @override
  void initState() {
    super.initState();

    _focusNode = FocusNode()..addListener(_focusNodeListener);
  }

  @override
  void didChangeDependencies() {
    colorScheme = Theme.of(context).colorScheme;

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _focusNode.dispose();

    super.dispose();
  }

  void _focusNodeListener() => setState(() {});

  @override
  Widget build(BuildContext context) => MouseRegion(
        cursor: SystemMouseCursors.text,
        child: GestureDetector(
          onTap: () => _focusNode.requestFocus(),
          child: Container(
            height: double.infinity,
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              border: Border.all(
                width: rimSize,
                color: _focusNode.hasFocus
                    ? colorScheme.outline
                    : Colors.transparent,
              ),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: Material(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(borderRadius),
              child: TextField(
                scrollPadding: EdgeInsets.zero,
                focusNode: _focusNode,
                controller: widget.textEditingController,
                decoration: InputDecoration(
                  constraints: BoxConstraints.expand(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  hintText: widget.hint,
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                  errorBorder: OutlineInputBorder(borderSide: BorderSide.none),
                  enabledBorder:
                      OutlineInputBorder(borderSide: BorderSide.none),
                  focusedBorder:
                      OutlineInputBorder(borderSide: BorderSide.none),
                  disabledBorder:
                      OutlineInputBorder(borderSide: BorderSide.none),
                  focusedErrorBorder:
                      OutlineInputBorder(borderSide: BorderSide.none),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                ),
              ),
            ),
          ),
        ),
      );
}
