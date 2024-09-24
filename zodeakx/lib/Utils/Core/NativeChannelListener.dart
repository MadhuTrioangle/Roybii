import 'package:flutter/services.dart';

class FlutterNativeCodeListenerMethodChannel {
  static const platform = MethodChannel('sendKlineData');
  static const channelName = 'sendKlineData'; // this channel name needs to match the one in Native method channel
  MethodChannel? methodChannel;

  static final FlutterNativeCodeListenerMethodChannel instance = FlutterNativeCodeListenerMethodChannel._init();
  FlutterNativeCodeListenerMethodChannel._init();

  void configureChannel() {
    methodChannel = MethodChannel(channelName);
    // set method handler
  }

  
}