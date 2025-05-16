import 'package:flutter/material.dart';
import 'package:mmm/common/constants/app_constants.dart';

class ResultsCard extends StatefulWidget {
  const ResultsCard({
    super.key,
    required this.image,
    required this.label,
    required this.place,
    required this.votes,
  });

  final ImageProvider image;
  final String label;
  final int place;
  final int votes;

  @override
  State<ResultsCard> createState() => _ResultsCardState();
}

class _ResultsCardState extends State<ResultsCard> {
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
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Ink(
                    decoration: BoxDecoration(
                      image: DecorationImage(image: widget.image),
                      borderRadius: BorderRadius.circular(borderRadius),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 10.0,
                      children: [
                        Ink(
                          decoration: ShapeDecoration(
                            shape:
                                StarBorder(points: 15, innerRadiusRatio: 0.9),
                            color: _colorScheme.secondaryContainer,
                          ),
                          padding: EdgeInsets.all(5.0),
                          child: Text("№${widget.place}"),
                        ),
                        Ink(
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(borderRadius),
                            ),
                            color: _colorScheme.secondaryContainer,
                          ),
                          padding: EdgeInsets.all(5.0),
                          child: Text("${widget.votes}"),
                        ),
                      ],
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
