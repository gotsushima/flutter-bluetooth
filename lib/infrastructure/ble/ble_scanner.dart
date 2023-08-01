import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:watch_winder_app/infrastructure/ble/ble_device_interactor.dart';
import 'package:watch_winder_app/infrastructure/ble/reactive_state.dart';

class BleScanner implements ReactiveState<BleScannerState> {
  BleScanner({
    required FlutterReactiveBle ble,
  }) : _ble = ble;

  final FlutterReactiveBle _ble;
  final StreamController<BleScannerState> _stateStreamController =
      StreamController();

  final _devices = <DiscoveredDevice>[];



  @override
  Stream<BleScannerState> get state => _stateStreamController.stream;

  void startScan() {
    _devices.clear();
    _subscription?.cancel();
    _setSubscription();
    _pushState();
  }




  void _setSubscription() {
    _subscription = _ble.scanForDevices(
        withServices: [BleDeviceInteractor.serviceUuid]).listen((device) {
      final knownDeviceIndex = _devices.indexWhere((d) => d.id == device.id);
      if (knownDeviceIndex >= 0) {
        _devices[knownDeviceIndex] = device;
      } else {
        _devices.add(device);
      }
      _pushState();
    }, onError: (e) async {
      if (Platform.isAndroid) {
        try {
          await Permission.location.request();
          await Permission.bluetoothScan.request();
          await Permission.bluetoothConnect.request();
        } catch (e) {
          debugPrint('device scan error');
          debugPrint(e.toString());
        }
      }
      _devices.clear();
      _pushState();
      // 再スキャンする
      _setSubscription();
    });
    _pushState();
  }


  void _pushState() {
    _stateStreamController.add(
      BleScannerState(
        discoveredDevices: _devices,
        scanIsInProgress: _subscription != null,
      ),
    );
  }

  Future<void> stopScan() async {
    await _subscription?.cancel();
    _subscription = null;
    _pushState();
  }

  Future<void> dispose() async {
    await _stateStreamController.close();
  }

  StreamSubscription? _subscription;
}

@immutable
class BleScannerState {
  const BleScannerState({
    required this.discoveredDevices,
    required this.scanIsInProgress,
  });

  final List<DiscoveredDevice> discoveredDevices;
  final bool scanIsInProgress;

}
