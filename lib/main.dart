import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:provider/provider.dart';
import 'package:watch_winder_app/component/winder_input.dart';
import 'package:watch_winder_app/component/winder_scan.dart';
import 'package:watch_winder_app/infrastructure/ble/ble_device_connector.dart';
import 'package:watch_winder_app/infrastructure/ble/ble_device_interactor.dart';
import 'package:watch_winder_app/infrastructure/ble/ble_device_io.dart';
import 'package:watch_winder_app/infrastructure/ble/ble_scanner.dart';
import 'package:watch_winder_app/infrastructure/ble/ble_status_monitor.dart';
import 'package:watch_winder_app/model/winder.dart';
import 'dart:async';

const _themeColor = Colors.blue;

void main() {
  WidgetsFlutterBinding.ensureInitialized();



  final ble = FlutterReactiveBle();
  final serviceDiscoverer = BleDeviceInteractor(
    bleDiscoverServices: ble.discoverServices,
    readCharacteristic: ble.readCharacteristic,
    writeWithResponse: ble.writeCharacteristicWithResponse,
    subscribeToCharacteristic: ble.subscribeToCharacteristic,
  );
  final deviceIo = BleDeviceIO(
    ble: ble,
    interactor: serviceDiscoverer,
  );
  final scanner = BleScanner(ble: ble);
  final monitor = BleStatusMonitor(ble);
  final connector = BleDeviceConnector(
    ble: ble,
    deviceIo: deviceIo,
  );
  runApp(
    MultiProvider(
      providers: [
        Provider.value(value: scanner),
        Provider.value(value: monitor),
        Provider.value(value: connector),
        Provider.value(value: serviceDiscoverer),
        Provider.value(value: deviceIo),
        StreamProvider<BleScannerState?>(
          create: (_) => scanner.state,
          initialData: const BleScannerState(
            discoveredDevices: [],
            scanIsInProgress: false,
          ),
        ),
        StreamProvider<BleStatus?>(
          create: (_) => monitor.state,
          initialData: BleStatus.unknown,
        ),
        StreamProvider<ConnectionStateUpdate>(
          create: (_) => connector.state,
          initialData: const ConnectionStateUpdate(
            deviceId: '',
            connectionState: DeviceConnectionState.disconnected,
            failure: null,
          ),
        ),
        StreamProvider<Winder?>(
            create: (_) => deviceIo.state, initialData: null)
      ],
      child: MaterialApp(
        color: _themeColor,
        theme: ThemeData(primarySwatch: _themeColor,fontFamily: 'TimesNewerRoman',),
        home: const HomeScreen(),
      ),
    ),
  );
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  Timer? timer;
  @override
  void initState() {
    super.initState();

    timer = Timer(
      const Duration(seconds: 3),
          () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const FirstScreen(),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }


  @override
  Widget build(BuildContext context) {

    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(242, 242, 242, 1),

      body: SafeArea(
        child: Center(
          child: Container(
            width: size.width * 0.55,
            alignment: Alignment.center,
            child: Image.asset(
              'images/opening_logo.png',
            ),
          ),
        ),
      ),
    );
  }
}

class FirstScreen extends StatelessWidget {
  const FirstScreen({
    Key? key,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) =>

      Consumer2<ConnectionStateUpdate, BleDeviceIO>(
        builder: (_, status, deviceIo, __) {
          var isConnected =
              status.connectionState == DeviceConnectionState.connected;

          final Size size = MediaQuery.of(context).size;


          return SafeArea(
            child: Scaffold(
              backgroundColor: const Color.fromRGBO(242, 242, 242, 1),
              appBar: AppBar(
                  backgroundColor: const Color.fromRGBO(242, 242, 242, 1),
                title: Image.asset(isConnected ? 'images/connected.webp' : 'images/select_your_watch_winder.png',height: size.height * 0.02,),
                automaticallyImplyLeading: false,
                centerTitle: true,
                flexibleSpace: Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('images/primary.png'),
                          fit: BoxFit.cover),
                    )
                ),
              ),
              body: Stack(
                children: [

                  isConnected
                      ? WinderInput(deviceIo, status)
                      : const WinderScan(),
                ],),
            ),
          );
        },
      );
}


