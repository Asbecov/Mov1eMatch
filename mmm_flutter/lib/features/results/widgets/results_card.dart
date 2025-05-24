import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:movie_match/common/constants/app_constants.dart';
import 'package:movie_match/common/constants/assets.dart';

class ResultsCard extends StatefulWidget {
  const ResultsCard({
    super.key,
    required this.image,
    required this.label,
    required this.place,
    required this.votes,
  }) : assert(place <= 3, "Place can't be higher than 3");

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
        aspectRatio: 1.0,
        child: LayoutBuilder(
            builder: (context, constraints) => Stack(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: SvgPicture.asset(
                        switch (widget.place) {
                          1 => number1,
                          2 => number2,
                          3 => number3,
                          _ => number3,
                        },
                        height: constraints.maxHeight / 3.5,
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: AspectRatio(
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
                                      image:
                                          DecorationImage(image: widget.image),
                                      borderRadius:
                                          BorderRadius.circular(borderRadius),
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
                                          borderRadius: BorderRadius.circular(
                                              borderRadius),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                          vertical: 5.0,
                                          horizontal: 10.0,
                                        ),
                                        child: Text(
                                          "${widget.label}: ${widget.votes}",
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
                      ),
                    ),
                  ],
                )),
      );
}
