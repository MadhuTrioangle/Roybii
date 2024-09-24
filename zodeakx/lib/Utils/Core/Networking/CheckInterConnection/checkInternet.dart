
import 'package:connectivity_plus/connectivity_plus.dart';

class CheckInternet{

Future<bool> hasInternet() async{
var checkConnection = await Connectivity().checkConnectivity();
return (checkConnection == ConnectivityResult.none) ? false : true;
}
}

CheckInternet checkInternet = CheckInternet();
