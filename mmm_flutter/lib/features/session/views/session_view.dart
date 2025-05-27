import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_match/common/constants/app_constants.dart';
import 'package:movie_match/common/constants/assets.dart';
import 'package:movie_match/common/constants/routing_constants.dart';
import 'package:movie_match/common/models/salute/models.dart';
import 'package:movie_match/common/widgets/selectable_text_button.dart';
import 'package:movie_match/features/session/domain/session_bloc/bloc.dart';
import 'package:movie_match/main.dart';
import 'package:qr_flutter/qr_flutter.dart';

class SessionView extends StatefulWidget {
  const SessionView({
    super.key,
  });

  @override
  State<SessionView> createState() => _SessionViewState();
}

class _SessionViewState extends State<SessionView> {
  StreamSubscription<String>? _streamSubscription;

  @override
  void initState() {
    super.initState();

    _streamSubscription =
        saluteHandler?.eventStream.listen((data) => _streamListener(
              context.mounted ? context : null,
              data,
            ));
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();

    super.dispose();
  }

  void _streamListener(BuildContext? context, String data) {
    try {
      final BaseCommand command = BaseCommand.fromJson(jsonDecode(data));

      if (command is HelpCommand && context != null) {
        showDialog(
          context: context,
          useRootNavigator: false,
          builder: (context) => AlertDialog.adaptive(
            // icon: Icon(Icons.question_mark),
            title: Text("Список доступных комманд:"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                    "Скажите \"Покажи результаты\", чтобы закончить голосование и перейти к результатам."),
              ],
            ),
            actions: <Widget>[
              SelectableTextButton(
                icon: Icons.clear,
                label: "Закрыть",
                onTap: () => context.pop(),
              )
            ],
          ),
        );
      }
    } catch (e) {
      if (kDebugMode) print("error : $e");
    }
  }

  void _onCloseSessionTap(BuildContext context) {
    final String? id = context.read<SessionBloc>().state.sessionId;

    if (id != null) {
      context.goNamed(resultsName, pathParameters: {resultsParamName: id});
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

  void _onDebugTap(BuildContext context) {
    final String? id = context.read<SessionBloc>().state.sessionId;

    if (id != null) {
      context.goNamed(votingName, pathParameters: {votingParamName: id});
    } else {
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        SnackBar(
          content: Text("Пока не получится открыть голосование"),
          backgroundColor: Theme.of(context).colorScheme.error,
          showCloseIcon: true,
          closeIconColor: Theme.of(context).colorScheme.onError,
        ),
      );
    }
  }

  void _onReturnTap(BuildContext context) {
    OverlayEntry modalLoadingBarrier = OverlayEntry(
      builder: (context) => Stack(
        children: [
          Center(
            child: CircularProgressIndicator.adaptive(),
          ),
          ModalBarrier(
            dismissible: false,
            color: Colors.black54,
          ),
        ],
      ),
    );

    final SessionBloc bloc = context.read<SessionBloc>();
    bloc.stream.listen(
      (SessionState state) {
        if (context.mounted) {
          modalLoadingBarrier.remove();
          modalLoadingBarrier.dispose();

          context.goNamed(createName);

          if (state is SessionErrorState) {
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
          }
        }
      },
    );

    bloc.add(CloseSessionEvent());
    Overlay.of(context).insert(modalLoadingBarrier);
  }

  Widget _builder(BuildContext context, SessionState state) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 10.0,
          children: [
            Text("Просканируйте QR код для голосования на телефоне:"),
            Expanded(
              child: Center(
                child: state.sessionId == null
                    ? CircularProgressIndicator.adaptive()
                    : Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(borderRadius),
                          color: Colors.white,
                        ),
                        margin: EdgeInsets.symmetric(horizontal: 10.0),
                        child: QrImageView(
                          data:
                              '$frontendUrl${votingRoute.split('/')[1]}/${state.sessionId!}',
                        ),
                      ),
              ),
            ),
            Row(
              spacing: 10.0,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SelectableTextButton(
                  icon: Icons.arrow_forward,
                  label: "Закончить голосование",
                  onTap: () => _onCloseSessionTap(context),
                ),
                SelectableTextButton(
                  icon: Icons.close,
                  label: "Вернуться к выбору",
                  onTap: () => _onReturnTap(context),
                ),
                if (kDebugMode)
                  SelectableTextButton(
                    icon: Icons.abc,
                    label: "Debug",
                    onTap: () => _onDebugTap(context),
                  ),
              ],
            ),
          ],
        ),
      );

  void _listener(BuildContext context, SessionState state) {
    if (state is SessionErrorState) {
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
    }
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
        ),
        body: BlocConsumer<SessionBloc, SessionState>(
          listener: _listener,
          builder: _builder,
        ),
      );
}
