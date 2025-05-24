import 'package:flutter/material.dart';

import 'package:movie_match/common/constants/app_constants.dart';

class SearchSelectableCard extends StatefulWidget {
  const SearchSelectableCard({
    required super.key,
    required this.onTap,
    required this.title,
    required this.description,
    required this.genres,
    required this.image,
  });

  final void Function(Key) onTap;
  final String title;
  final String description;
  final List<String> genres;
  final ImageProvider image;

  @override
  State<SearchSelectableCard> createState() => _SearchCardState();
}

class _SearchCardState extends State<SearchSelectableCard> {
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
        height: 240,
        child: Material(
          color: _colorScheme.surfaceContainer,
          shape: RoundedRectangleBorder(
            side: _focusNode.hasFocus
                ? BorderSide(color: _colorScheme.outline, width: rimSize)
                : BorderSide.none,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            focusNode: _focusNode,
            onTap: () => widget.onTap(widget.key!),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: IntrinsicHeight(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 10.0,
                  children: <Widget>[
                    AspectRatio(
                      aspectRatio: 2 / 3,
                      child: Ink(
                        decoration: BoxDecoration(
                          image: DecorationImage(image: widget.image),
                          borderRadius: BorderRadius.circular(borderRadius),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 5.0,
                        children: <Widget>[
                          Text(widget.title),
                          Expanded(
                            child: Ink(
                              decoration: BoxDecoration(
                                color: _colorScheme.surfaceContainerLowest,
                                borderRadius:
                                    BorderRadius.circular(borderRadius),
                              ),
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(borderRadius),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    widget.description,
                                    softWrap: true,
                                    maxLines: null,
                                    overflow: TextOverflow.fade,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            spacing: 5.0,
                            children: widget.genres
                                .getRange(0, widget.genres.length >= 3 ? 2 : 0)
                                .map<Widget>(
                              (String genre) {
                                final int colorIndex =
                                    (genre.hashCode % Colors.primaries.length)
                                        .toInt();
                                final Color color =
                                    Colors.primaries[colorIndex];

                                return Ink(
                                  decoration: BoxDecoration(
                                    color: color,
                                    borderRadius: BorderRadius.circular(
                                      borderRadius,
                                    ),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    vertical: 5.0,
                                    horizontal: 10.0,
                                  ),
                                  child: Text(genre),
                                );
                              },
                            ).toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}
