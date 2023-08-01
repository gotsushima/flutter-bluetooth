import 'dart:async';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:watch_winder_app/infrastructure/ble/ble_device_interactor.dart';
import 'package:watch_winder_app/infrastructure/ble/reactive_state.dart';
import 'package:watch_winder_app/model/winder.dart';

class BleDeviceIO extends ReactiveState<Winder?> {
  BleDeviceIO({
    required FlutterReactiveBle ble,
    required BleDeviceInteractor interactor,
  })  : _ble = ble,
        _interactor = interactor;


  final FlutterReactiveBle _ble;
  final BleDeviceInteractor _interactor;
  late Timer _timer;

  @override
  Stream<Winder?> get state => _deviceReaderController.stream;

  final _deviceReaderController = StreamController<Winder?>();

  Future<void> subscribe(String deviceId) async {
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) async {
      await read(deviceId);
    });
  }

  void delete() {
    _deviceReaderController.add(null);
  }

  Future<void> writeRead(String deviceId, int value) async {
    await _interactor.writeCharacterisiticWithResponse(deviceId, [value]);
    await read(deviceId);
  }

  Future<void> read(String deviceId) async {
    _ble
        .readCharacteristic(
        BleDeviceInteractor.createReadQualifiedCharacteristic(deviceId))
        .then((result) {
      _deviceReaderController.add(Winder(result));
    }).onError((error, stackTrace) {
      // エラー処理
    });
  }

  Future<void> dispose() async {
    _timer.cancel();
    await _deviceReaderController.close();
  }
}