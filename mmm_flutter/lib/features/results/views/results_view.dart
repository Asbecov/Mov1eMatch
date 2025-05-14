import 'package:confetti/confetti.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mmm/common/constants/app_constants.dart';
import 'package:mmm/features/results/domain/results_bloc/bloc.dart';
import 'package:mmm_client/mmm_client.dart';

class ResultsView extends StatefulWidget {
  const ResultsView({super.key});

  @override
  State<ResultsView> createState() => _ResultsViewState();
}

class _ResultsViewState extends State<ResultsView> {
  late final ConfettiController _controller;

  @override
  void initState() {
    super.initState();

    _controller = ConfettiController();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(),
        body: BlocConsumer<ResultsBloc, ResultsState>(
          listener: (context, state) {
            if (state is ResultsErrorState) {
              ScaffoldMessenger.maybeOf(context)?.showSnackBar(
                SnackBar(
                  content: Text(
                    kDebugMode
                        ? "${state.error} ${state.stackTrace}"
                        : "Поробуйте позже",
                  ),
                  backgroundColor: Theme.of(context).colorScheme.error,
                  showCloseIcon: true,
                  closeIconColor: Theme.of(context).colorScheme.onError,
                ),
              );
              return;
            }
            if (state.results.isNotEmpty) {
              _controller.play();
            }
          },
          buildWhen: (previous, current) => current is! ResultsErrorState,
          builder: (context, state) {
            if (state.results.isEmpty) {
              return Center(
                child: CircularProgressIndicator.adaptive(),
              );
            } else {
              final List<MapEntry<Film, int>> results = state.results.entries
                  .toList()
                ..sort((a, b) => a.value.compareTo(b.value));
              final List<Widget> children = [];

              for (int i = 0; i < results.length; i++) {
                final MapEntry<Film, int> entry = results[i];

                children.add(ResultsCard(
                  image: entry.key.art != null
                      ? NetworkImage(entry.key.art!)
                      : AssetImage('assets/pine_trees'),
                  label: entry.key.title,
                  place: i + 1,
                  votes: entry.value,
                ));
              }

              return ConfettiWidget(
                confettiController: _controller,
                child: Center(
                  child: Wrap(
                    spacing: 10.0,
                    runSpacing: 10.0,
                    children: children.getRange(0, 3).toList(),
                  ),
                ),
              );
            }
          },
        ),
      );
}

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
  Widget build(BuildContext context) {
    return Material(
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
                child: Ink(
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(borderRadius),
                    ),
                    color: _colorScheme.secondaryContainer,
                  ),
                  padding: EdgeInsets.all(5.0),
                  child: RichText(
                    text: TextSpan(
                      children: <InlineSpan>[
                        TextSpan(text: "№${widget.place} "),
                        TextSpan(text: "${widget.votes}"),
                      ],
                    ),
                  ),
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
                      color: Theme.of(context).colorScheme.secondaryContainer,
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
    );
  }
}
