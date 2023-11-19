import 'package:flutter_blue/flutter_blue.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class BleController extends GetxController{

  FlutterBlue flutterBlue = FlutterBlue.instance;
  // Add in classic scanning as well

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
  Future scanDevices(targetDevice) async {
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
          // If I can just scan until specific device is found, that would be epic
          flutterBlue.startScan(timeout: const Duration(seconds: 5));
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
        // for (ScanResult result in devicesList) {
        //   // print('Device Id: ${result.device.id}');
        //   // if (targetDevice != "" && targetDevice == result.device.id.toString()) {
        //   //   print("YESSS FOUND DEVICE: ${result.device.id.toString()}, rssi: ${result.rssi}");
        //   // }
        // }
        print("NUMBER OF DEVICES:${devicesList.length}");
      });
      flutterBlue.startScan(timeout: const Duration(seconds: 10));
      flutterBlue.stopScan();
    }
    // scanDevices();
  }
  Stream<List<ScanResult>> get scanResults => flutterBlue.scanResults;

}