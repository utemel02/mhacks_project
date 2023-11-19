import 'package:flutter_blue/flutter_blue.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class BleController extends GetxController{

  FlutterBlue flutterBlue = FlutterBlue.instance;

  // Future scanDevices() async{
  //   var blePermission = await Permission.bluetoothScan.status;
  //   if(blePermission.isDenied){
  //     if(await Permission.bluetoothScan.request().isGranted){
  //       if(await Permission.bluetoothConnect.request().isGranted){
  //         flutterBlue.startScan(timeout: const Duration(seconds: 10));
  //         flutterBlue.stopScan();
  //       }
  //     }
  //   }else{
  //     flutterBlue.startScan(timeout: const Duration(seconds: 10));
  //
  //     flutterBlue.stopScan();
  //
  //   }
  //
  //   // for (var i = 0; i < await scanResults.length; i++) {
  //   //   print("THIS HERE: " + scanResults)
  //   // }
  // }
  List<ScanResult> devicesList = [];
  Future scanDevices() async {
    var blePermission = await Permission.bluetoothScan.status;
    if(blePermission.isDenied){
      if(await Permission.bluetoothScan.request().isGranted){
        if(await Permission.bluetoothConnect.request().isGranted){
          scanResults.listen((List<ScanResult> results) {
            for (ScanResult result in results) {
              if (!devicesList.any((device) => device.device.id == result.device.id)) {
                devicesList.add(result);
              }
            }
            devicesList.sort((a, b) => a.device.id.toString().compareTo(b.device.id.toString()));
            for (ScanResult result in devicesList) {
              print('Device Id: ${result.device.id}');
            }
          });
          flutterBlue.startScan(timeout: const Duration(seconds: 10));
          flutterBlue.stopScan();
        }
      }
    } else {
      scanResults.listen((List<ScanResult> results) {
        for (ScanResult result in results) {
          if (!devicesList.any((device) => device.device.id == result.device.id)) {
            devicesList.add(result);
          } else {
            devicesList = devicesList.map((device) => device.device.id == result.device.id ? result : device).toList();
          }
        }
        devicesList.sort((a, b) => a.device.id.toString().compareTo(b.device.id.toString()));
        for (ScanResult result in devicesList) {
          print('Device Id: ${result.device.id}');
        }
      });
      flutterBlue.startScan(timeout: const Duration(seconds: 10));
      flutterBlue.stopScan();
    }
  }
  Stream<List<ScanResult>> get scanResults => flutterBlue.scanResults;
}