import 'package:confetti/confetti.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mmm/features/results/domain/results_bloc/bloc.dart';
import 'package:mmm/features/results/widgets/results_card.dart';
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
            if (state is ResultsErrorState &&
                state.error is NotFoundException) {
              ScaffoldMessenger.maybeOf(context)?.showSnackBar(
                SnackBar(
                  content: Text(
                    kDebugMode
                        ? "${state.error} ${state.stackTrace}"
                        : "Кажется такой сессии уже не существует",
                  ),
                  backgroundColor: Theme.of(context).colorScheme.error,
                  showCloseIcon: true,
                  closeIconColor: Theme.of(context).colorScheme.onError,
                ),
              );
              return;
            }
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
                  child: Row(
                    spacing: 10.0,
                    children: children.getRange(0, 3).toList(),
                  ),
                ),
              );
            }
          },
        ),
      );
}
