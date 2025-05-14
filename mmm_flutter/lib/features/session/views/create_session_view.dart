import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mmm/common/constants/app_constants.dart';
import 'package:mmm/common/constants/routing_constants.dart';
import 'package:mmm/common/widgets/selectable_text_button.dart';
import 'package:mmm/features/session/domain/create_session_bloc/bloc.dart';
import 'package:mmm_client/mmm_client.dart';
import 'package:qr_flutter/qr_flutter.dart';

class CreateSessionView extends StatefulWidget {
  const CreateSessionView({
    super.key,
    required this.selection,
  });

  final List<Film> selection;

  @override
  State<CreateSessionView> createState() => _CreateSessionViewState();
}

class _CreateSessionViewState extends State<CreateSessionView> {
  @override
  void initState() {
    context
        .read<CreateSessionBloc>()
        .add(PromptedCreateSessionEvent(pool: widget.selection));

    super.initState();
  }

  void _onCloseSessionTap(BuildContext context) {
    final String? id = context.read<CreateSessionBloc>().state.sessionId;

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
    final String? id = context.read<CreateSessionBloc>().state.sessionId;

    if (id != null) {
      context.goNamed(sessionName, pathParameters: {sessionParamName: id});
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
            ));

    final CreateSessionBloc bloc = context.read<CreateSessionBloc>();
    bloc.stream.listen(
      (CreateSessionState state) {
        if (state is! SessionErrorState && context.mounted) {
          modalLoadingBarrier.remove();
          modalLoadingBarrier.dispose();
          context.goNamed(createName);
        }
      },
    );

    bloc.add(CloseCreateSessionEvent());
    Overlay.of(context).insert(modalLoadingBarrier);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(),
        body: BlocConsumer<CreateSessionBloc, CreateSessionState>(
          listener: (context, state) {
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
          },
          buildWhen: (context, state) => state is! SessionErrorState,
          builder: (context, state) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 10.0,
              children: [
                Text("Просканируйте QR код для голосования на телефоне:"),
                Expanded(
                  child: state.sessionId == null
                      ? CircularProgressIndicator.adaptive()
                      : Center(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(borderRadius),
                              color: Colors.white,
                            ),
                            child: QrImageView(
                              data: String.fromEnvironment("FRONTED-URL") +
                                  state.sessionId!,
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
          ),
        ),
      );
}
