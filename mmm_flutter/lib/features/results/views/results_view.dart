import 'dart:math';

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
  late ConfettiController _controllerTopRight;
  late ConfettiController _controllerTopLeft;
  late ConfettiController _controllerBottomLeft;
  late ConfettiController _controllerBottomRight;
  late final List<ConfettiController> _controllers;

  @override
  void initState() {
    super.initState();

    _controllerTopRight =
        ConfettiController(duration: const Duration(seconds: 10));
    _controllerTopLeft =
        ConfettiController(duration: const Duration(seconds: 10));
    _controllerBottomLeft =
        ConfettiController(duration: const Duration(seconds: 10));
    _controllerBottomRight =
        ConfettiController(duration: const Duration(seconds: 10));

    _controllers = [
      _controllerTopRight,
      _controllerTopLeft,
      _controllerBottomLeft,
      _controllerBottomRight,
    ];
  }

  @override
  void dispose() {
    for (final ConfettiController controller in _controllers) {
      controller.dispose();
    }

    super.dispose();
  }

  void _listener(BuildContext context, ResultsState state) {
    if (state is ResultsErrorState && state.error is NotFoundException) {
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
    } else if (state is ResultsErrorState) {
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        SnackBar(
          content: Text(
            kDebugMode
                ? "${state.error} ${state.stackTrace}"
                : "Что-то пошло не так",
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
          showCloseIcon: true,
          closeIconColor: Theme.of(context).colorScheme.onError,
        ),
      );
    } else if (state.results.isNotEmpty) {
      for (final ConfettiController controller in _controllers) {
        controller.play();
      }
    }
  }

  Widget _builder(BuildContext context, ResultsState state) {
    if (state is ResultsErrorState && state.error is NotFoundException) {
      return Center(
        child: Text("Кажется такой сессии уже не существует"),
      );
    } else if (state.results.isEmpty) {
      return Center(
        child: CircularProgressIndicator.adaptive(),
      );
    }

    final List<MapEntry<Film, int>> results = state.results.entries.toList()
      ..sort((a, b) => a.value.compareTo(b.value));
    final List<Widget> children = [];

    for (int i = 0; i < results.length.clamp(0, 3); i++) {
      final MapEntry<Film, int> entry = results[i];

      children.add(
        Expanded(
          child: Center(
            child: ResultsCard(
              image: entry.key.art != null
                  ? NetworkImage(entry.key.art!)
                  : AssetImage('assets/pine_trees'),
              label: entry.key.title,
              place: i + 1,
              votes: entry.value,
            ),
          ),
        ),
      );
    }

    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: Row(
            spacing: 10.0,
            children: children,
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: ConfettiWidget(
            confettiController: _controllerTopLeft,
            blastDirectionality: BlastDirectionality.directional,
            blastDirection: 7 * pi / 4,
            shouldLoop: true,
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: ConfettiWidget(
            confettiController: _controllerTopRight,
            blastDirectionality: BlastDirectionality.directional,
            blastDirection: 5 * pi / 4,
            shouldLoop: true,
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: ConfettiWidget(
            confettiController: _controllerBottomRight,
            blastDirectionality: BlastDirectionality.directional,
            blastDirection: 3 * pi / 4,
            shouldLoop: true,
          ),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: ConfettiWidget(
            confettiController: _controllerBottomLeft,
            blastDirectionality: BlastDirectionality.directional,
            blastDirection: pi / 4,
            shouldLoop: true,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(),
        body: BlocConsumer<ResultsBloc, ResultsState>(
          listener: _listener,
          builder: _builder,
        ),
      );
}
