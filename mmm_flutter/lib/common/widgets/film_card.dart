import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mmm/common/constants/app_constants.dart';

class FilmCard extends StatefulWidget {
  const FilmCard({
    super.key,
    required this.image,
    required this.onDelete,
    required this.label,
  });

  final Image image;
  final String label;
  final void Function(Key? key) onDelete;

  @override
  State<FilmCard> createState() => _FilmCardState();
}

class _FilmCardState extends State<FilmCard> {
  late final FocusNode _focusNode;

  late ThemeData _theme;
  late ColorScheme _colorScheme;

  bool _selected = false;

  bool get _shouldShowCross => _focusNode.hasFocus || _selected;

  @override
  void initState() {
    super.initState();

    _focusNode = FocusNode();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _theme = Theme.of(context);
    _colorScheme = _theme.colorScheme;
  }

  @override
  void dispose() {
    _focusNode.dispose();

    super.dispose();
  }

  void _handleFocusChange(bool isFocused) => setState(() {});

  void _handleEnter(_) => setState(() => _selected = !_selected);

  void _handleExit(_) => setState(() => _selected = !_selected);

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event.logicalKey.keyLabel == 'Enter') {
      _handleTap();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  void _handleTap() => widget.onDelete(widget.key);

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _focusNode,
      onFocusChange: _handleFocusChange,
      onKeyEvent: _handleKeyEvent,
      child: MouseRegion(
        onEnter: _handleEnter,
        onExit: _handleExit,
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: _handleTap,
          child: Container(
            decoration: BoxDecoration(
              color: _colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                width: 2.0,
                color: _focusNode.hasFocus
                    ? _colorScheme.outline
                    : Colors.transparent,
              ),
            ),
            padding: EdgeInsets.all(5.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(borderRadius - 5),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ImageFiltered(
                    enabled: _shouldShowCross,
                    imageFilter: ImageFilter.compose(
                      outer: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      inner: ColorFilter.mode(
                        _colorScheme.error,
                        BlendMode.color,
                      ),
                    ),
                    child: widget.image,
                  ),
                  if (_shouldShowCross) Icon(Icons.close),
                  if (!_shouldShowCross)
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: <Color>[
                              Colors.transparent,
                              Colors.black,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .secondaryContainer,
                            borderRadius: BorderRadius.circular(borderRadius),
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: 5.0,
                            horizontal: 10.0,
                          ),
                          child: Text(widget.label),
                        ),
                      ),
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
