import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:watch_winder_app/infrastructure/ble/ble_device_connector.dart';
import 'package:watch_winder_app/infrastructure/ble/ble_scanner.dart';



class WinderScan extends StatefulWidget {
  const WinderScan({super.key});
  @override
  State<WinderScan> createState() => _WinderScanState();
}

class _WinderScanState extends State<WinderScan> {


  @override
  Widget build(BuildContext context) =>
      Consumer3<BleScanner, BleScannerState, BleDeviceConnector>(
          builder: (_, bleScanner, bleScannerState, deviceConnector, __) {
            if (!bleScannerState.scanIsInProgress) bleScanner.startScan();
            if (bleScannerState.discoveredDevices.isEmpty) return Container();


            void showProgressDialog() {
              showGeneralDialog(
                  context: context,
                  barrierDismissible: false,
                  transitionDuration: const Duration(milliseconds: 300),
                  barrierColor: const Color.fromRGBO(242, 242, 242, 1).withOpacity(1),
                  pageBuilder: (BuildContext context, Animation animation, Animation secondaryAnimation) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
              );
            }

            return Scaffold(
                backgroundColor:  const Color.fromRGBO(242, 242, 242, 1),

                body: RefreshIndicator(
                    onRefresh: () async {
                      bleScanner.startScan();
                    },

                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),

                      itemBuilder: (context, index) {
                        var device = bleScannerState.discoveredDevices[index];

                        return Card(
                            child: ListTile(
                                tileColor:  const Color.fromRGBO(242, 242, 242, 1),
                                title: Text(device.id),
                                onTap: () async {
                                  showProgressDialog();
                                  NavigatorState nav = Navigator.of(context);
                                  await Future.delayed(const Duration(seconds: 1));
                                  await deviceConnector.connect(device.id);
                                  await Future.delayed(const Duration(seconds: 1));
                                  nav.pop();
                                }));
                      },
                      itemCount: bleScannerState.discoveredDevices.length,
                    )));
          });
}