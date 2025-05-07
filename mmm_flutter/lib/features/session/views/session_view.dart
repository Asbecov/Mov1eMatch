import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mmm/common/constants/app_constants.dart';
import 'package:mmm/features/create/domain/create_bloc/bloc.dart';
import 'package:mmm/features/session/domain/session_bloc/bloc.dart';
import 'package:mmm_client/mmm_client.dart';
import 'package:qr_flutter/qr_flutter.dart';

class SessionView extends StatefulWidget {
  const SessionView({super.key});

  @override
  State<SessionView> createState() => _CreateSessionViewState();
}

class _CreateSessionViewState extends State<SessionView> {
  @override
  void initState() {
    final List<Film> selection = context.read<CreateBloc>().state.selection;

    context.read<SessionBloc>().add(PromptedSessionEvent(pool: selection));

    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(),
        body: BlocBuilder<SessionBloc, SessionState>(
          builder: (context, state) {
            return Center(
              child: state.sessionId == null
                  ? CircularProgressIndicator.adaptive()
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(borderRadius),
                      child: QrImageView(
                        data: String.fromEnvironment("FRONTED-URL") +
                            state.sessionId!,
                        backgroundColor: Colors.white,
                      ),
                    ),
            );
          },
        ),
      );
}
