import 'dart:async';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:watch_winder_app/infrastructure/ble/ble_device_io.dart';

class BleDeviceInteractor {
  static final Uuid serviceUuid =
      Uuid.parse('357e8779-99b3-45b7-9d92-edc98ee5c0b4');
  static final writeCharacteristicUuid =
      Uuid.parse('e0761f40-6a05-4e08-a853-b87d67524a38');
  static final readCharacteristicUuid =
      Uuid.parse('201bcd2c-74ad-11ed-a1eb-0242ac120002');

  BleDeviceInteractor({
    required Future<List<DiscoveredService>> Function(String deviceId)
        bleDiscoverServices,
    required Future<List<int>> Function(QualifiedCharacteristic characteristic)
        readCharacteristic,
    required Future<void> Function(QualifiedCharacteristic characteristic,
            {required List<int> value})
        writeWithResponse,
    required Stream<List<int>> Function(QualifiedCharacteristic characteristic)
        subscribeToCharacteristic,
  })  : _bleDiscoverServices = bleDiscoverServices,
        _readCharacteristic = readCharacteristic,
        _writeWithResponse = writeWithResponse,
        _subScribeToCharacteristic = subscribeToCharacteristic;

  final Future<List<DiscoveredService>> Function(String deviceId)
      _bleDiscoverServices;

  final Future<List<int>> Function(QualifiedCharacteristic characteristic)
      _readCharacteristic;

  final Future<void> Function(QualifiedCharacteristic characteristic,
      {required List<int> value}) _writeWithResponse;

  final Stream<List<int>> Function(QualifiedCharacteristic characteristic)
      _subScribeToCharacteristic;

  Future<List<DiscoveredService>> discoverServices(String deviceId) async {
    final result = await _bleDiscoverServices(deviceId);
    return result;
  }

  Future<List<int>> readCharacteristic(String deviceId) async {
    final result =
        await _readCharacteristic(createWriteQualifiedCharacteristic(deviceId));

    return result;
  }

  Future<void> writeCharacterisiticWithResponse(
      String deviceId, List<int> value) async {
    await _writeWithResponse(createWriteQualifiedCharacteristic(deviceId),
        value: value);
  }

  Future<void> writeCharacterisiticWithResponseAndRead(
      String deviceId, List<int> value, BleDeviceIO deviceIo) async {
    await _writeWithResponse(createWriteQualifiedCharacteristic(deviceId),
        value: value);
    deviceIo.read(deviceId);
  }

  Stream<List<int>> subScribeToCharacteristic(String deviceId) {
    return _subScribeToCharacteristic(
        createWriteQualifiedCharacteristic(deviceId));
  }

  static QualifiedCharacteristic createWriteQualifiedCharacteristic(
      String deviceId) {
    return createQualifiedCharacteristic(deviceId, writeCharacteristicUuid);
  }

  static QualifiedCharacteristic createReadQualifiedCharacteristic(
      String deviceId) {
    return createQualifiedCharacteristic(deviceId, readCharacteristicUuid);
  }

  static QualifiedCharacteristic createQualifiedCharacteristic(
      String deviceId, characteristicUuid) {
    return QualifiedCharacteristic(
        deviceId: deviceId,
        characteristicId: characteristicUuid,
        serviceId: serviceUuid);
  }
}
