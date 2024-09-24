import 'package:flutter/foundation.dart';

class securedPrint{

  securedPrint(dynamic message){
    if (kDebugMode) {
      print('þrint ----> ${message}');
    }
  }
  
}