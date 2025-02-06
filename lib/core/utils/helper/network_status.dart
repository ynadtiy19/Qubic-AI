import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkManager {
  static final Connectivity _connectivity = Connectivity();

  static Future<bool> isConnected() async {
    final List<ConnectivityResult> results =
        await _connectivity.checkConnectivity();
    return _isConnected(results);
  }

  static bool _isConnected(List<ConnectivityResult> results) {
    return results.any((result) =>
        result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi ||
        result == ConnectivityResult.ethernet ||
        result == ConnectivityResult.vpn);
  }

  static Stream<bool> get connectionStatusStream {
    return _connectivity.onConnectivityChanged
        .asyncMap((results) => _isConnected(results));
  }
}
