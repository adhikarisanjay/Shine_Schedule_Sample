import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkUtil {
  static Future<bool> isConnected() async {
    try {
      var connectivityResult = await (Connectivity().checkConnectivity());

      if (connectivityResult.contains(ConnectivityResult.none)) {
        return false;
      }
      return true;
    } catch (e) {
      return false;
    }
  }
}
