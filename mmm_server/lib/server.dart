import 'package:mmm_server/src/endpoints/search.dart';
import 'package:serverpod/serverpod.dart';

import 'src/generated/protocol.dart';
import 'src/generated/endpoints.dart';

/// The starting point of the Serverpod server.
void run(List<String> args) async {
  // Initialize Serverpod and connect it with your generated code.
  final pod = Serverpod(
    args,
    Protocol(),
    Endpoints(),
  );

  // Prepare search endpoint for work
  final Session session = await pod.createSession();
  await SearchEndpoint().fetchGenres(session);
  session.close();
  // Start the server.
  await pod.start();
}
