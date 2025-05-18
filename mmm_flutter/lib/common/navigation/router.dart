import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:go_router/go_router.dart';

import 'package:movie_match/common/constants/routing_constants.dart';
import 'package:movie_match/features/create/views/create_view.dart';
import 'package:movie_match/features/results/domain/results_bloc/bloc.dart';
import 'package:movie_match/features/results/views/results_view.dart';
import 'package:movie_match/features/session/domain/session_bloc/bloc.dart';
import 'package:movie_match/features/session/views/session_view.dart';
import 'package:movie_match/features/voting/domain/voting_bloc/bloc.dart';
import 'package:movie_match/features/voting/views/voting_view.dart';
import 'package:mmm_client/mmm_client.dart';

final GoRouter route = GoRouter(
  initialLocation: createRoute,
  onException: (context, state, router) =>
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
    SnackBar(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Что-то пошло не так"),
          if (kDebugMode) Text(state.error?.message ?? ""),
        ],
      ),
      action: SnackBarAction(
        label: "Ok",
        onPressed: () {},
      ),
    ),
  ),
  routes: <RouteBase>[
    GoRoute(
      path: createRoute,
      name: createName,
      builder: (context, state) => CreateView(),
    ),
    GoRoute(
      path: sessionRoute,
      name: sessionName,
      builder: (context, state) => BlocProvider<SessionBloc>(
        create: (context) => SessionBloc(),
        child: SessionView(
          selection: state.extra as List<Film>? ?? <Film>[],
        ),
      ),
    ),
    GoRoute(
      path: resultsRoute,
      name: resultsName,
      builder: (context, state) => BlocProvider<ResultsBloc>(
        create: (context) => ResultsBloc()
          ..add(ResultsPromptedEvent(
            sessionId: state.pathParameters[resultsParamName]!,
          )),
        child: const ResultsView(),
      ),
    ),
    GoRoute(
      path: votingRoute,
      name: votingName,
      builder: (context, state) => BlocProvider<VotingBloc>(
        create: (context) => VotingBloc()
          ..add(VotingInitEvent(
            sessionId: state.pathParameters[votingParamName]!,
          )),
        child: VotingView(),
      ),
    ),
  ],
);
