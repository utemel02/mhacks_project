import 'package:flutter/material.dart';
import 'package:mhacks_project/ble_controller.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:get/get.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("BLE SCANNER"),
        centerTitle: true,
      ),
      body: GetBuilder<BleController>(
        init: BleController(),
        builder: (controller) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 15,
                ),
                StreamBuilder<List<ScanResult>>(
                    stream: controller.scanResults,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Expanded(
                            child: ListView.builder(
                            shrinkWrap: true,
                            // itemCount: snapshot.data!.length,
                                itemCount: controller.devicesList!.length,
                            itemBuilder: (context, index) {
                              // final data = snapshot.data![index];
                              final data = controller.devicesList![index];
                              return GestureDetector(
                                  onTap:() => print("Gottem:${Text(data.device.id.id)}"),
                                  child: Card(
                                    elevation: 2,
                                    child: ListTile(
                                      title: Text(data.device.name),
                                      subtitle: Text(data.device.id.id),
                                      trailing: Text("${(pow(10, ((-56 - data.rssi) / (10*2))) * 3.2808).toStringAsFixed(2)} ft"),
                                    ),
                                  ),
                              );
                              //   Card(
                              //   elevation: 2,
                              //   child: ListTile(
                              //     title: Text(data.device.name),
                              //     subtitle: Text(data.device.id.id),
                              //     trailing: Text("${(pow(10, ((-56 - data.rssi) / (10*2))) * 3.2808).toStringAsFixed(2)} ft"),
                              //   ),
                              // );
                            }));
                      }else{
                        return const Center(child: Text("No Device Found"),);
                      }
                    }),
                ElevatedButton(onPressed: () =>controller.scanDevices(), child: const Text("Scan")),
                const SizedBox(
                  height: 15,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}