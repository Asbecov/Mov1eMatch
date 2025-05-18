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
          child: Material(
            color: colorScheme.surfaceContainerHighest,
            shape: RoundedRectangleBorder(
              side: _focusNode.hasFocus
                  ? BorderSide(color: colorScheme.outline, width: rimSize)
                  : BorderSide.none,
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: LayoutBuilder(
                builder: (context, constraints) => TextField(
                      textAlignVertical: TextAlignVertical.bottom,
                      scrollPadding: EdgeInsets.zero,
                      focusNode: _focusNode,
                      controller: widget.textEditingController,
                      onEditingComplete: () => _focusNode.nextFocus(),
                      decoration: InputDecoration(
                        constraints: BoxConstraints.expand(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: constraints.maxHeight / 2,
                        ),
                        hintText: widget.hint,
                        border: OutlineInputBorder(borderSide: BorderSide.none),
                        errorBorder:
                            OutlineInputBorder(borderSide: BorderSide.none),
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
                    )),
          ),
        ),
      );
}
