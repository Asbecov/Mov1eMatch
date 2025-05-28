import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:go_router/go_router.dart';

import 'package:movie_match/common/constants/routing_constants.dart';
import 'package:movie_match/common/models/salute/models.dart';
import 'package:movie_match/common/navigation/salute/bloc/bloc.dart';
import 'package:movie_match/common/widgets/exit_notifier.dart';
import 'package:movie_match/features/create/views/create_view.dart';
import 'package:movie_match/features/results/domain/results_bloc/bloc.dart';
import 'package:movie_match/features/results/views/results_view.dart';
import 'package:movie_match/features/session/domain/session_bloc/bloc.dart';
import 'package:movie_match/features/session/views/session_view.dart';
import 'package:movie_match/features/voting/domain/voting_bloc/bloc.dart';
import 'package:movie_match/features/voting/views/voting_view.dart';
import 'package:mmm_client/mmm_client.dart';
import 'package:movie_match/main.dart';

class SaluteNavigatorObserver extends NavigatorObserver {
  @override
  void didChangeTop(Route<dynamic> topRoute, Route<dynamic>? previousTopRoute) {
    if (topRoute.settings.name != null) {
      final AppState state = AppState(routingState: topRoute.settings.name!);
      saluteHandler?.setState(newState: jsonEncode(state.toJson()));
      if (kDebugMode) print("SaluteHandler: ${state.routingState}");
    }
  }
}

final GoRouter router = GoRouter(
  observers: [SaluteNavigatorObserver()],
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
    ),
  ),
  routes: <RouteBase>[
    GoRoute(
      path: createRoute,
      name: createName,
      builder: (context, state) => BlocProvider<SaluteNavigationBloc>(
        create: (context) {
          return SaluteNavigationBloc();
        },
        child: BlocListener<SaluteNavigationBloc, SaluteNavigationState>(
          listener: SaluteNavigationBloc.blocListener,
          child: const ExitNotifier(child: CreateView()),
        ),
      ),
    ),
    GoRoute(
      path: sessionRoute,
      name: sessionName,
      builder: (context, state) => MultiBlocProvider(
        providers: [
          BlocProvider<SessionBloc>(
            create: (context) {
              final SessionBloc bloc = SessionBloc();

              if (state.extra is List<Film>) {
                bloc.add(
                  PromptedSessionEvent(pool: state.extra as List<Film>),
                );
              }

              return bloc;
            },
          ),
          BlocProvider<SaluteNavigationBloc>(
            create: (context) => SaluteNavigationBloc(),
          )
        ],
        child: BlocListener<SaluteNavigationBloc, SaluteNavigationState>(
          listener: SaluteNavigationBloc.blocListener,
          child: const ExitNotifier(child: SessionView()),
        ),
      ),
    ),
    GoRoute(
      path: resultsRoute,
      name: resultsName,
      builder: (context, state) => MultiBlocProvider(
        providers: [
          BlocProvider<ResultsBloc>(
            create: (context) => ResultsBloc()
              ..add(
                ResultsPromptedEvent(
                  sessionId: state.pathParameters[resultsParamName]!,
                ),
              ),
          ),
          BlocProvider<SaluteNavigationBloc>(
            create: (context) => SaluteNavigationBloc(),
          ),
        ],
        child: BlocListener<SaluteNavigationBloc, SaluteNavigationState>(
          listener: SaluteNavigationBloc.blocListener,
          child: const ExitNotifier(child: ResultsView()),
        ),
      ),
    ),
    GoRoute(
      path: votingRoute,
      name: votingName,
      builder: (context, state) => MultiBlocProvider(
        providers: [
          BlocProvider<VotingBloc>(
            create: (context) => VotingBloc()
              ..add(
                VotingInitEvent(
                  sessionId: state.pathParameters[votingParamName]!,
                ),
              ),
          ),
          BlocProvider<SaluteNavigationBloc>(
            create: (context) => SaluteNavigationBloc(),
          ),
        ],
        child: BlocListener<SaluteNavigationBloc, SaluteNavigationState>(
          listener: SaluteNavigationBloc.blocListener,
          child: const ExitNotifier(child: VotingView()),
        ),
      ),
    ),
  ],
);
