import 'salute_handler_platform_interface.dart';

class SaluteHandler {
  Stream<String> get eventStream => SaluteHandlerPlatform.instance.eventStream;

  Stream<String> get navigationEventStream =>
      SaluteHandlerPlatform.instance.navigationEventStream;

  Future setState({required String newState}) =>
      SaluteHandlerPlatform.instance.setState(newState: newState);
}
