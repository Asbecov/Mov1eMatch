package com.movie.match.salute_handler

import android.content.Context
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.plugin.common.EventChannel.StreamHandler
import ru.sberdevices.services.appstate.*
import ru.sberdevices.messaging.*

/** SaluteHandlerPlugin */
class SaluteHandlerPlugin: FlutterPlugin, MethodCallHandler {
  private lateinit var channel : MethodChannel
  private lateinit var eventChannel: EventChannel
  private lateinit var navigationEventChannel: EventChannel

  private var eventSink: EventSink? = null
  private var navigationEventSink: EventSink? = null

  private lateinit var messaging : Messaging
  private lateinit var appStateHolder : AppStateHolder

  private val messagingListener = object : Messaging.Listener {
    override fun onMessage(messageId: MessageId, payload: Payload) {
      eventSink?.success(payload.data)
    }

    override fun onNavigationCommand(payload: Payload) {
      navigationEventSink?.success(payload.data)
    }

    override fun onError(messageId: MessageId, throwable: Throwable) {
      eventSink?.error(1.toString(), messageId.value, null)
    }
  }

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "salute_handler")
    eventChannel = EventChannel(flutterPluginBinding.binaryMessenger, "salute_event_handler")
    navigationEventChannel = EventChannel(flutterPluginBinding.binaryMessenger, "salute_navigation_handler")

    channel.setMethodCallHandler(this)
    eventChannel.setStreamHandler(object : StreamHandler {
      override fun onListen(arguments: Any?, events: EventSink?) {
        eventSink = events
      }

      override fun onCancel(arguments: Any?) {
        eventSink?.endOfStream()
      }
    })
    navigationEventChannel.setStreamHandler(object : StreamHandler {
      override fun onListen(arguments: Any?, events: EventSink?) {
        navigationEventSink = events

      }

      override fun onCancel(arguments: Any?) {
        navigationEventSink?.endOfStream()
      }
    })

    val context : Context = flutterPluginBinding.applicationContext
    
    messaging = MessagingFactory.create(appContext = context)
    appStateHolder = AppStateManagerFactory.createHolder(context = context)

    val version : Int? = messaging.getVersion();
    if (version != null && version >= 1) {
      messaging.addListener(messagingListener)
    }
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    if (call.method == "setState" && call.hasArgument("newState")) {
      val argument : String? = call.argument<String>("newState")
      appStateHolder.setState(argument)

      result.success("Set state to $argument")
    } else {
      result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
    eventChannel.setStreamHandler(null)
    navigationEventChannel.setStreamHandler(null)
  }
}
