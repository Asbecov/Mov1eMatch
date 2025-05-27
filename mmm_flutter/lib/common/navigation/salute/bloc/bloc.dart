import 'dart:async';
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_match/common/constants/routing_constants.dart';
import 'package:movie_match/common/models/salute/models.dart';
import 'package:movie_match/features/create/domain/create_bloc/bloc.dart';
import 'package:movie_match/features/session/domain/session_bloc/bloc.dart';
import 'package:movie_match/main.dart';

part 'event.dart';
part 'state.dart';

class SaluteNavigationBloc
    extends Bloc<SaluteNavigationEvent, SaluteNavigationState> {
  StreamSubscription? _subscription;

  SaluteNavigationBloc() : super(const SaluteNavigationState.empty()) {
    on<RecievedCommandSaluteNavigationEvent>(
      _onRecievedCommandSaluteNavigationEvent,
    );

    _subscription = saluteHandler?.eventStream.listen(_streamListener);
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();

    return super.close();
  }

  void _onRecievedCommandSaluteNavigationEvent(
    RecievedCommandSaluteNavigationEvent event,
    Emitter<SaluteNavigationState> emit,
  ) =>
      emit(state._copyWith(command: event.command));

  void _streamListener(String data) {
    try {
      final BaseCommand command = BaseCommand.fromJson(jsonDecode(data));

      add(RecievedCommandSaluteNavigationEvent(command: command));
    } catch (e) {
      if (kDebugMode) print("error: $e");
    }
  }

  static void blocListener(BuildContext context, SaluteNavigationState state) {
    final GoRouterState routerState = GoRouterState.of(context);

    if (kDebugMode) print("SaluteNavigation routerState: ${routerState.name}");

    switch (state.command) {
      case StartSessionCommand _:
        if (routerState.name == createName) {
          context.goNamed(
            sessionName,
            extra: context.read<CreateBloc>().state.selection,
          );
        }
      case CloseSessionCommand _:
        if (routerState.name == sessionName) {
          final String? id = context.read<SessionBloc>().state.sessionId;

          if (id != null) {
            context.goNamed(
              resultsName,
              pathParameters: {resultsParamName: id},
            );
          } else {
            ScaffoldMessenger.maybeOf(context)?.showSnackBar(
              SnackBar(
                content: Text("Пока не получится закончить голосование"),
                backgroundColor: Theme.of(context).colorScheme.error,
                showCloseIcon: true,
                closeIconColor: Theme.of(context).colorScheme.onError,
              ),
            );
          }
        }
      case ReturnCreate _:
        context.goNamed(createName);
    }
  }
}
