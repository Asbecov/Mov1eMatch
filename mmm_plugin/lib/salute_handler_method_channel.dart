import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'salute_handler_platform_interface.dart';

/// An implementation of [SaluteHandlerPlatform] that uses method channels.
class MethodChannelSaluteHandler extends SaluteHandlerPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('salute_handler');
  @visibleForTesting
  final eventChannel = const EventChannel('salute_event_handler');
  @visibleForTesting
  final navigationEventChannel = const EventChannel(
    'salute_navigation_event_handler',
  );

  @override
  Stream<String> get eventStream =>
      eventChannel.receiveBroadcastStream().map((event) => event.toString());

  @override
  Stream<String> get navigationEventStream => navigationEventChannel
      .receiveBroadcastStream()
      .map((event) => event.toString());

  @override
  Future setState({required String newState}) async => methodChannel
      .invokeMethod('setState', <String, dynamic>{"newState": newState});
}
