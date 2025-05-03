import 'package:flutter/material.dart';
import 'package:mmm/common/constants/app_constants.dart';

class FilmCard extends StatefulWidget {
  const FilmCard({
    required super.key,
    required this.image,
    required this.onDelete,
    required this.label,
  });

  final ImageProvider image;
  final String label;
  final void Function(Key key) onDelete;

  @override
  State<FilmCard> createState() => _FilmCardState();
}

class _FilmCardState extends State<FilmCard> {
  late final FocusNode _focusNode;

  late ThemeData _theme;
  late ColorScheme _colorScheme;

  bool _hovered = false;

  bool get _shouldShowCross => _focusNode.hasFocus || _hovered;

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

  void _handleHover(bool entered) => setState(() => _hovered = entered);

  void _handleTap() => widget.onDelete(widget.key!);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _colorScheme.surfaceContainer,
      shape: RoundedRectangleBorder(
        side: _focusNode.hasFocus
            ? BorderSide(
                color: _colorScheme.outline,
                width: rimSize,
              )
            : BorderSide.none,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        focusNode: _focusNode,
        onFocusChange: _handleFocusChange,
        onHover: _handleHover,
        onTap: _handleTap,
        hoverColor: Colors.red.withAlpha(77),
        focusColor: Colors.red.withAlpha(77),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Ink(
                  decoration: BoxDecoration(
                    image: DecorationImage(image: widget.image),
                    borderRadius: BorderRadius.circular(borderRadius),
                  ),
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
                          color:
                              Theme.of(context).colorScheme.secondaryContainer,
                          borderRadius: BorderRadius.circular(borderRadius),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: 5.0,
                          horizontal: 10.0,
                        ),
                        child: Text(
                          widget.label,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
