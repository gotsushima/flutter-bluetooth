import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:provider/provider.dart';
import 'package:watch_winder_app/infrastructure/ble/ble_device_connector.dart';
import 'package:watch_winder_app/infrastructure/ble/ble_device_interactor.dart';
import 'package:watch_winder_app/infrastructure/ble/ble_device_io.dart';
import 'package:watch_winder_app/model/winder.dart';
import 'package:audioplayers/audioplayers.dart';


class WinderInput extends StatefulWidget {
  final BleDeviceIO deviceIo;
  final ConnectionStateUpdate connectionState;

  WinderInput(this.deviceIo, this.connectionState,  {super.key}) {
    deviceIo.subscribe(connectionState.deviceId);
  }

  @override
  State<WinderInput> createState() => _WinderInputState();
}

class _WinderInputState extends State<WinderInput> {

  final audioPlayer = AudioPlayer();

  @override

  Widget build(BuildContext context) {

    final Size size = MediaQuery.of(context).size;


    return Consumer3<BleDeviceConnector, BleDeviceInteractor, Winder?>(
        builder: (_, connector, interactor, winder, __) {
          // // if (!_isSubscribing) {
          if (winder == null) {
            return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: const Color.fromRGBO(242, 242, 242, 1),
                  foregroundColor: const Color.fromRGBO(242, 242, 242, 1),
                  fixedSize: const Size(150, 35),
                  alignment: Alignment.center,
                ),
                child: const Text('切断'),
                onPressed: () => connector.disconnect(widget.connectionState.deviceId)
            );
          }


        return Stack(

           children: [

          Wrap(

           alignment: WrapAlignment.center,
              spacing: size.height * 0.03,
              runSpacing:  size.height * 0.03,
           children: <Widget>[


             SizedBox(width: size.width * 0.9,height: size.height * 0.0227,),

             SizedBox(
               width: size.width * 0.09,
                   child: Image.asset(
                     'images/disconnect.png',
                   ),
                 ),


             Align(
                 alignment: const Alignment(0,0),
                 child: ElevatedButton(
                     style: ElevatedButton.styleFrom(
                       elevation: 5,
                       splashFactory: InkSparkle.splashFactory,//エフェクト追加
                       backgroundColor: Colors.white,
                       foregroundColor: Colors.black,
                       fixedSize: Size(size.width * 0.41, size.height* 0.044),
                       alignment: Alignment.center,
                       padding: const EdgeInsets.all(10),
                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                       textStyle: TextStyle(
                         fontSize: size.width / 25,
                         fontFamily:'TimesNewerRoman',
                       ),
                     ),
                     child: const Text('DISCONNECT'),
                      onPressed: () async{
                       await audioPlayer.play(AssetSource("sounds/start_sound.mp3"));
                       connector.disconnect(
                           widget.connectionState.deviceId,
                       );
                      })),
             SizedBox(width: double.infinity,height: size.height * 0.001,),

             SizedBox(width: size.width * 0.05,height: size.height * 0.015,),

             SizedBox(
               width: size.width * 0.17,
               child: Image.asset(
                 'images/start.png',
               ),
             ),
             SizedBox(width: size.width * 0.23,height: size.height * 0.015,),


             SizedBox(
               width: size.width * 0.067,
               child: Image.asset(
                 'images/stop.png',
               ),
             ),

             SizedBox(width: size.width * 0.11,height: size.height * 0.015,),

             Material(
               elevation: 5,
               borderRadius: BorderRadius.circular(4),
               child: SizedBox(
                 width: size.width * 0.41,
                 height: size.height* 0.088,
                 child: Ink(
                   decoration: BoxDecoration(
                     gradient: const LinearGradient(
                       begin: Alignment.topCenter,
                       end: Alignment.bottomCenter,
                       colors: [
                         Color.fromRGBO(35, 106, 170, 0.6),
                         Color.fromRGBO(35, 106, 170, 1),
                       ],
                     ),
                     borderRadius: BorderRadius.circular(4),
                   ),
                   child: ElevatedButton(
                     style: ElevatedButton.styleFrom(
                       backgroundColor: Colors.transparent,
                       foregroundColor: Colors.white,
                       elevation: 0,
                       textStyle: TextStyle(
                         fontSize: size.width / 19,
                         fontFamily: 'TimesNewerRoman',
                       ),
                     ),
                     onPressed: () async{
                       await audioPlayer.play(AssetSource("sounds/start_sound.mp3"));
                       widget.deviceIo.writeRead(widget.connectionState.deviceId, Winder.start);
                     },
                     child: const Text('START'),
                   ),
                 ),
               ),
             ),

             Material(
               elevation: 5,
               borderRadius: BorderRadius.circular(4),
              child: SizedBox(
               width: size.width * 0.41,
               height: size.height* 0.088,
               child: Ink(
                 decoration: BoxDecoration(
                   gradient: const LinearGradient(
                     begin: Alignment.topCenter,
                     end: Alignment.bottomCenter,
                     colors: [
                       Color.fromRGBO(177, 52, 62, 0.6),
                       Color.fromRGBO(177, 52, 62, 1),
                     ],
                   ),
                   borderRadius: BorderRadius.circular(4),
                 ),
                 child: ElevatedButton(
                   style: ElevatedButton.styleFrom(
                     backgroundColor: Colors.transparent,
                     foregroundColor: Colors.white,
                     elevation: 0,
                     textStyle: TextStyle(
                       fontSize: size.width / 19,
                       fontFamily: 'TimesNewerRoman',
                     ),
                   ),
                   onPressed: () async{
                     await audioPlayer.play(AssetSource("sounds/start_sound.mp3"));
                     widget.deviceIo.writeRead(widget.connectionState.deviceId, Winder.stop);
                   },
                   child: const Text('STOP'),
                 ),
               ),
              ),
             ),

             SizedBox(width: double.infinity,height: size.height * 0.001,),

             SizedBox(width: size.width * 0.10,height: size.height * 0.015,),

             SizedBox(
               width: size.width * 0.11,
               child: Image.asset(
                 'images/mode.png',
               ),
             ),

             SizedBox(width: size.width * 0.26,height: size.height * 0.015,),

             SizedBox(
               width: size.width * 0.065,
               child: Image.asset(
                 'images/light.png',
               ),
             ),

             SizedBox(width: size.width * 0.12,height: size.height * 0.015,),


             Material(
               elevation: 5,
               borderRadius: BorderRadius.circular(4),
               child: SizedBox(
                 width: size.width * 0.41,
                 height: size.height* 0.088,
                 child: Ink(
                   decoration: BoxDecoration(
                     gradient: const LinearGradient(
                       begin: Alignment.topCenter,
                       end: Alignment.bottomCenter,
                       colors: [
                         Color.fromRGBO(145, 123, 83, 0.6),
                         Color.fromRGBO(145, 123, 83, 1)
                       ],
                     ),
                     borderRadius: BorderRadius.circular(4),
                   ),
                   child: ElevatedButton(
                     style: ElevatedButton.styleFrom(
                       backgroundColor: Colors.transparent,
                       foregroundColor: Colors.white,
                       elevation: 0,
                       textStyle: TextStyle(
                         fontSize: size.width / 19,
                         fontFamily: 'TimesNewerRoman',
                       ),
                     ),
                     onPressed: () async{
                       await audioPlayer.play(AssetSource("sounds/start_sound.mp3"));
                       widget.deviceIo.writeRead(widget.connectionState.deviceId, Winder.power);
                     },
                     child: const Text('MODE'),
                   ),
                 ),
               ),
             ),


             Material(
               elevation: 5,
               borderRadius: BorderRadius.circular(4),
               child: SizedBox(
                 width: size.width * 0.41,
                 height: size.height* 0.088,
                 child: Ink(
                   decoration: BoxDecoration(
                     gradient: const LinearGradient(
                       begin: Alignment.topCenter,
                       end: Alignment.bottomCenter,
                       colors: [
                         Color.fromRGBO(245, 245, 199, 0.6),
                         Color.fromRGBO(245, 245, 199, 1),
                       ],
                     ),
                     borderRadius: BorderRadius.circular(4),
                   ),
                   child: ElevatedButton(
                     style: ElevatedButton.styleFrom(
                       backgroundColor: Colors.transparent,
                       foregroundColor: Colors.black,
                       elevation: 0,
                       textStyle: TextStyle(
                         fontSize: size.width / 19,
                         fontFamily: 'TimesNewerRoman',
                       ),
                     ),
                     onPressed: () async{
                       await audioPlayer.play(AssetSource("sounds/start_sound.mp3"));
                       widget.deviceIo.writeRead(widget.connectionState.deviceId, Winder.reset);
                     },
                     child: const Text('LIGHT'),
                   ),
                 ),
               ),
             ),

            // Text(winderState.winder.values.toString())
          ]),

                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    width: double.infinity,
                    child: Image.asset(
                      'images/main_logo.png',
                    ),),
                ),
              ]);
        });
  }
}