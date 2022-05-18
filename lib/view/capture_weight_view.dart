import 'dart:async';
import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';

import '../infrastructure/plug_com.dart';
import '../infrastructure/tools/observer_change.dart';

PlugCom plugCom = PlugCom();

class CaptureWeight extends StatefulWidget{
  const CaptureWeight({Key? key}) : super(key: key);

  @override
  State<CaptureWeight> createState() => _CaptureWeightState();


}

class _CaptureWeightState extends State<CaptureWeight>{
  String dataWeight = "0";
  int gross = 0;
  int tare = 0;
  int net = 0;
  int initGross = 0;
  List<dynamic> availablePorts = plugCom.availablePorts();
  late StreamSubscription streamSubscription;
  Color detailBackgroundColor = Colors.blueGrey[300] as Color;
  final List<int> _weightValues = [];

  @override
  void initState() {
    streamSubscription = plugCom.weightUpdates.listen((newVal)
    => setState(() {
      if(gross == 0){
        initGross = 0;
      }
      _weightBalance(newVal);
      if(gross != 0){
        _weightValues.clear();
        _weightValues.add(gross);
        _weightValues.add(tare);
        _weightValues.add(net);
        ObserveChange.streamControllerValueWeight.add(_weightValues);
      }
    }));

    ObserveChange.weightRestore.listen((restoreValue) => {
      if(restoreValue.isNotEmpty){
        setState(() {
          gross = restoreValue[0];
          tare = restoreValue[1];
          net = restoreValue[2];
          initGross = gross;

        })
      }
    });

    super.initState();
    initPlugCom();

  }

  @override
  void deactivate() {
    close();
    streamSubscription.cancel();
    super.deactivate();
  }

  void initPlugCom(){
    plugCom.configuration(plugCom.availablePorts().first);
    plugCom.runCapture();
  }

  void close(){
    plugCom.close();
  }

  void _weightBalance(String data){
    int? weightIndicator = int.tryParse(data);
    dataWeight = data;

    if(initGross == 0){
      gross = weightIndicator!;
    }
    else if(weightIndicator! > gross){
      tare = initGross;
      gross = weightIndicator;
    }
    else {
      gross = initGross;
      tare = 0;
    }

    net = gross - tare;

  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Card(
          elevation: 12,
          margin: const EdgeInsets.only(bottom: 0.0),
          child: SizedBox(
            width: 200,
            height: 50,
            child: Container(
              color: Colors.black,
              child: Center(
                  child:
                  Text(dataWeight, style: const TextStyle(fontWeight: FontWeight.bold,
                      fontSize: 40, color: Colors.white),
                  ),
              ),
            ),
          ),
        ),
        Card(
          elevation: 12,
          margin: const EdgeInsets.only(top: 0.0),
          child: SizedBox(
            width: 200,
            child: Container(
              color: Colors.white,
              margin: const EdgeInsets.only(top: 0.0),
              child: const Center(
                child:
                Text('Indicator', style: TextStyle(fontWeight: FontWeight.bold,
                    fontSize: 20, color: Colors.black),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          elevation: 12,
          margin: const EdgeInsets.only(bottom: 0.0),
          child: SizedBox(
            width: 200,
            height: 50,
            child: Container(
              color: Colors.greenAccent,
              child: Center(
                  child:
                  Text(gross.toString(), style: const TextStyle(fontWeight: FontWeight.bold,
                      fontSize: 40))),
            ),
          ),
        ),
        Card(
          elevation: 12,
          margin: const EdgeInsets.only(top: 0.0),
          child: SizedBox(
            width: 200,
            child: Container(
              color: Colors.white,
              child: const Center(
                child:
                Text('Weight Gross', style: TextStyle(fontWeight: FontWeight.bold,
                    fontSize: 20, color: Colors.black),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Card(
          elevation: 12,
          margin: const EdgeInsets.only(bottom: 0.0),
          child: SizedBox(
            width: 200,
            height: 50,
            child: Container(
              color: Colors.greenAccent,
              child: Center(
                  child:
                  Text(tare.toString(), style: const TextStyle(fontWeight: FontWeight.bold,
                      fontSize: 40))),
            ),
          ),
        ),
        Card(
          elevation: 12,
          margin: const EdgeInsets.only(top: 0.0),
          child: SizedBox(
            width: 200,
            child: Container(
              color: Colors.white,
              child: const Center(
                child:
                Text('Weight Tare', style: TextStyle(fontWeight: FontWeight.bold,
                    fontSize: 20, color: Colors.black),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Card(
          elevation: 12,
          margin: const EdgeInsets.only(bottom: 0.0),
          child: SizedBox(
            width: 200,
            height: 50,
            child: Container(
              color: Colors.greenAccent,
              child: Center(
                  child:
                  Text(net.toString(), style: const TextStyle(fontWeight: FontWeight.bold,
                      fontSize: 40))),
            ),
          ),
        ),
        Card(
          elevation: 12,
          margin: const EdgeInsets.only(top: 0.0),
          child: SizedBox(
            width: 200,
            child: Container(
              color: Colors.white,
              child: const Center(
                child:
                Text('Weight Net', style: TextStyle(fontWeight: FontWeight.bold,
                    fontSize: 20, color: Colors.black),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
  
  
}