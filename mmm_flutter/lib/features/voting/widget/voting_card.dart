import 'package:flutter/material.dart';
import 'package:movie_match/common/constants/app_constants.dart';

class VotingCard extends StatefulWidget {
  const VotingCard({
    super.key,
    required this.image,
    required this.label,
    required this.horizontalDrag,
  });

  final ImageProvider image;
  final String label;
  final int horizontalDrag;

  @override
  State<VotingCard> createState() => _VotingCardState();
}

class _VotingCardState extends State<VotingCard> {
  late ThemeData _theme;
  late ColorScheme _colorScheme;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _theme = Theme.of(context);
    _colorScheme = _theme.colorScheme;
  }

  @override
  Widget build(BuildContext context) => AspectRatio(
        aspectRatio: 2 / 3,
        child: Material(
          color: _colorScheme.surfaceContainer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(borderRadius),
              child: LayoutBuilder(
                  builder: (context, constraints) => Stack(
                        alignment: Alignment.center,
                        children: [
                          Ink(
                            decoration: BoxDecoration(
                              image: DecorationImage(image: widget.image),
                              borderRadius: BorderRadius.circular(borderRadius),
                            ),
                          ),
                          if (widget.horizontalDrag != 0)
                            Ink(
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(borderRadius),
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.transparent,
                                    widget.horizontalDrag < 0
                                        ? Colors.lightGreen.withAlpha(
                                            ((widget.horizontalDrag / -1000) *
                                                    255)
                                                .toInt(),
                                          )
                                        : Colors.red.withAlpha(
                                            ((widget.horizontalDrag / 1000) *
                                                    255)
                                                .toInt(),
                                          ),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                            ),
                          if (widget.horizontalDrag < 0)
                            Align(
                              child: Icon(
                                Icons.favorite,
                                color: Colors.white.withAlpha(
                                  ((widget.horizontalDrag / -300) * 255)
                                      .clamp(0, 255)
                                      .toInt(),
                                ),
                                size: constraints.maxWidth / 4,
                              ),
                            ),
                          if (widget.horizontalDrag > 0)
                            Align(
                              child: Icon(
                                Icons.clear,
                                color: Colors.white.withAlpha(
                                  ((widget.horizontalDrag / 300) * 255)
                                      .clamp(0, 255)
                                      .toInt(),
                                ),
                                size: constraints.maxWidth / 4,
                              ),
                            ),
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
                                  borderRadius:
                                      BorderRadius.circular(borderRadius),
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
                      )),
            ),
          ),
        ),
      );
}
