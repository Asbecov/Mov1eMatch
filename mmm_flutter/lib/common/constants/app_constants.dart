const String title = "Movie Match";

const double borderRadius = 20.0;
const double rimSize = 2.0;

const String frontendUrl = String.fromEnvironment(
  "FRONTEND_URL",
  defaultValue: '',
);

const String serverUrl = String.fromEnvironment(
  "SERVER_URL",
  defaultValue: 'http://localhost:8080/',
);
