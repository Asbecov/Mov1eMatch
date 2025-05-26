import 'package:flutter/material.dart';

import 'package:movie_match/common/constants/app_constants.dart';

class SelectableTextField extends StatefulWidget {
  const SelectableTextField({
    super.key,
    required this.label,
    required this.labelIcon,
    required this.hint,
    required this.textEditingController,
  });

  final String label;
  final IconData labelIcon;
  final String hint;
  final TextEditingController textEditingController;

  @override
  State<SelectableTextField> createState() => SelectableTextFieldState();
}

class SelectableTextFieldState extends State<SelectableTextField> {
  late final FocusNode _focusNode;
  late ColorScheme colorScheme;

  @override
  void initState() {
    super.initState();

    _focusNode = FocusNode()..addListener(_focusNodeListener);
  }

  @override
  void didChangeDependencies() {
    final EdgeInsets viewInsets = MediaQuery.of(context).viewInsets;
    if (viewInsets.bottom == 0.0 && _focusNode.hasFocus) _focusNode.nextFocus();

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
              borderRadius: BorderRadius.circular(borderRadius * 2),
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
                        label: Row(
                          spacing: 5.0,
                          children: <Widget>[
                            Icon(
                              widget.labelIcon,
                              color: Colors.white.withAlpha(128),
                            ),
                            Text(
                              widget.label,
                              style: TextStyle(
                                color: Colors.white.withAlpha(128),
                              ),
                            ),
                          ],
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
