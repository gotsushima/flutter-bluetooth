import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class BleConnect {
  static final Uuid _serviceUuid =
      Uuid.parse('357e8779-99b3-45b7-9d92-edc98ee5c0b4');
  static final _characteristicUuid =
      Uuid.parse('e0761f40-6a05-4e08-a853-b87d67524a38');
  static late QualifiedCharacteristic characteristic;
  static final _flutterReactiveBle = FlutterReactiveBle();

  static Stream<DiscoveredDevice> scanWinders() {
    return _flutterReactiveBle.scanForDevices(
        withServices: [_serviceUuid], scanMode: ScanMode.lowLatency);
  }

  static Stream<ConnectionStateUpdate> connectWinder(String deviceId) {
    return _flutterReactiveBle.connectToAdvertisingDevice(
      id: deviceId,
      withServices: [_serviceUuid],
      prescanDuration: const Duration(seconds: 10),
    );
  }

  static QualifiedCharacteristic createQualifiedCharacteristic(
      String deviceId) {
    return QualifiedCharacteristic(
        serviceId: _serviceUuid,
        characteristicId: _characteristicUuid,
        deviceId: deviceId);
  }

  static Future<List<DiscoveredService>> discoverService(String deviceId) {
    return _flutterReactiveBle.discoverServices(deviceId);
  }

  static Future<List<int>> readCharacteristic() {
    return _flutterReactiveBle.readCharacteristic(characteristic);
  }

  static Future<void> writeCharacteristic(List<int> value) {
    return _flutterReactiveBle.writeCharacteristicWithResponse(characteristic,
        value: value);
  }

  static Stream<List<int>> subscribeToCharacteristic() {
    return _flutterReactiveBle.subscribeToCharacteristic(characteristic);
  }
}
