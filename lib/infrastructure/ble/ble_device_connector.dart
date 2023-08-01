import 'dart:async';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:watch_winder_app/infrastructure/ble/ble_device_io.dart';
import 'package:watch_winder_app/infrastructure/ble/reactive_state.dart';

class BleDeviceConnector extends ReactiveState<ConnectionStateUpdate> {
  BleDeviceConnector({
    required FlutterReactiveBle ble,
    required BleDeviceIO deviceIo,
  })  : _ble = ble,
        _reader = deviceIo;

  final FlutterReactiveBle _ble;
  final BleDeviceIO _reader;

  @override
  Stream<ConnectionStateUpdate> get state => _deviceConnectionController.stream;

  final _deviceConnectionController = StreamController<ConnectionStateUpdate>();

  // ignore: cancel_subscriptions
  late StreamSubscription<ConnectionStateUpdate> _connection;

  Future<void> connect(String deviceId) async {
    _connection = _ble.connectToDevice(id: deviceId).listen(
      (update) {
        _deviceConnectionController.add(update);
        _reader.read(deviceId);
      },
    );
  }

  Future<void> disconnect(String deviceId) async {
    await _connection.cancel();
    _deviceConnectionController.add(
      ConnectionStateUpdate(
        deviceId: deviceId,
        connectionState: DeviceConnectionState.disconnected,
        failure: null,
      ),
    );
    _reader.delete();
  }

  Future<void> dispose() async {
    await _deviceConnectionController.close();
  }
}
