import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:lxp_platform/core/network/failure.dart';

abstract class BaseConnectionService {
  final Connectivity connectivity;

  BaseConnectionService({required this.connectivity});

  Future<void> isConnected() async {
    final connectivityResult = await connectivity.checkConnectivity();
    if (!connectivityResult.contains(ConnectivityResult.mobile) &&
        !connectivityResult.contains(ConnectivityResult.wifi) &&
        !connectivityResult.contains(ConnectivityResult.ethernet)) {
      throw ConnectionException("Você está sem conexão com a internet.");
    }
  }
}
