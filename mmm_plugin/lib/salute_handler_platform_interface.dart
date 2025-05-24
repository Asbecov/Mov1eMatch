import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'salute_handler_method_channel.dart';

abstract class SaluteHandlerPlatform extends PlatformInterface {
  /// Constructs a SaluteHandlerPlatform.
  SaluteHandlerPlatform() : super(token: _token);

  static final Object _token = Object();

  static SaluteHandlerPlatform _instance = MethodChannelSaluteHandler();

  static SaluteHandlerPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [SaluteHandlerPlatform] when
  /// they register themselves.
  static set instance(SaluteHandlerPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Stream<String> get eventStream {
    throw UnimplementedError('eventStream has not been implemented.');
  }

  Stream<String> get navigationEventStream {
    throw UnimplementedError('navigationEventStream has not been implemented.');
  }

  Future setState({required String newState}) {
    throw UnimplementedError('setState() has not been implemented.');
  }
}
