import 'package:flutter/services.dart';

class IntentHelper{
  static const platform = const MethodChannel('com.az.medeasy');

  Future callAmbulance() async {
    try{
      await platform.invokeMethod('callAmbulance');
    }on PlatformException catch (e){
      print(e.message);
    }
  }

  Future eMeds(String file, String message) async {
    try{
      await platform.invokeMethod('emeds', {'file':file, 'message':message});
    }on PlatformException catch(e){
      print(e.message);
    }

  }
}