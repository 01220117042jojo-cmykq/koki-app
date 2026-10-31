import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../network_info.dart';
import 'network_state.dart';

class NetworkCubit extends Cubit<NetworkState> {
  final NetworkInfo networkInfo;
  StreamSubscription<bool>? _subscription;

  NetworkCubit({required this.networkInfo}) : super(NetworkInitial()) {
    _monitorConnection();
  }

  void _monitorConnection() {
    // 1. Check initial status
    checkConnection();

    _subscription = networkInfo.onConnectivityChanged.listen((isConnected) {
      if (isConnected) {
        emit(NetworkConnected());
      } else {
        emit(NetworkDisconnected());
      }
    });
  }

  Future<bool> checkConnection() async {
    final isConnected = await networkInfo.isConnected;
    if (isConnected) {
      emit(NetworkConnected());
    } else {
      emit(NetworkDisconnected());
    }
    return isConnected;
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}