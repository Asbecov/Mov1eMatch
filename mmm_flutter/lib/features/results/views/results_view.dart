import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_confetti/flutter_confetti.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_match/common/constants/app_constants.dart';
import 'package:movie_match/common/constants/assets.dart';
import 'package:movie_match/common/constants/routing_constants.dart';
import 'package:movie_match/common/widgets/selectable_button.dart';
import 'package:movie_match/features/results/domain/results_bloc/bloc.dart';
import 'package:movie_match/features/results/widgets/results_card.dart';
import 'package:mmm_client/mmm_client.dart';

class ResultsView extends StatelessWidget {
  const ResultsView({super.key});

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
      double randomInRange(double min, double max) {
        return min + Random().nextDouble() * (max - min);
      }

      int total = 30;
      int progress = 0;

      Timer.periodic(const Duration(milliseconds: 250), (timer) {
        progress++;

        if (progress >= total) {
          timer.cancel();
          return;
        }

        int count = ((1 - progress / total) * 50).toInt();

        try {
          Confetti.launch(
            context,
            options: ConfettiOptions(
              particleCount: count,
              startVelocity: 30,
              spread: 360,
              ticks: 60,
              x: randomInRange(0.1, 0.3),
              y: Random().nextDouble() - 0.2,
            ),
          );
          Confetti.launch(
            context,
            options: ConfettiOptions(
              particleCount: count,
              startVelocity: 30,
              spread: 360,
              ticks: 60,
              x: randomInRange(0.7, 0.9),
              y: Random().nextDouble() - 0.2,
            ),
          );
        } catch (e) {
          if (kDebugMode) print("error $e");
        }
      });
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
      ..sort((a, b) => b.value.compareTo(a.value));
    final List<Widget> children = [];

    for (int i = 0; i < results.length.clamp(0, 3); i++) {
      final MapEntry<Film, int> entry = results[i];

      children.add(
        Expanded(
          child: Center(
            child: ResultsCard(
              image: entry.key.art != null
                  ? NetworkImage(entry.key.art!.replaceAll(
                      originalImageServerUrl,
                      imagesServerUrl,
                    ))
                  : AssetImage(kUnknown),
              label: entry.key.title,
              place: i + 1,
              votes: entry.value,
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 10.0,
        children: [
          Text(
            "Результаты голосования:",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
            ),
          ),
          Expanded(
            child: Row(spacing: 10.0, children: children),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
            child: SvgPicture.asset(
              kTextLogo,
              alignment: Alignment.centerLeft,
              colorFilter: ColorFilter.mode(
                Theme.of(context).colorScheme.onSurface,
                BlendMode.srcIn,
              ),
            ),
          ),
          leadingWidth: double.infinity,
          actionsPadding: EdgeInsets.all(5),
          actions: <Widget>[
            SelectableButton(
              icon: Icons.clear,
              tooltip: 'Вернуться',
              onTap: () => context.goNamed(createName),
            ),
          ],
        ),
        body: BlocConsumer<ResultsBloc, ResultsState>(
          listener: _listener,
          builder: _builder,
        ),
      );
}
