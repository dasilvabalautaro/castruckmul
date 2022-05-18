import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:libserialport/libserialport.dart';

class PlugCom {
  late SerialPort serialPort;
  late SerialPortReader reader;
  final StreamController _streamController = StreamController<String>.broadcast();
  Stream get weightUpdates => _streamController.stream;

  bool _isNumericTryParse(String string) {
    if (string.isEmpty) {
      return false;
    }
    final number = num.tryParse(string);
    if (number == null) {
      return false;
    }
    return true;
  }

  List<dynamic> availablePorts(){
    return SerialPort.availablePorts;
  }

  void configuration(String port){
    serialPort = SerialPort(port);
    serialPort.config.baudRate = 9600; //115200
    serialPort.config.bits = 8;
    serialPort.config.stopBits = 1;
    serialPort.config.parity = 0;
    serialPort.config.xonXoff = 0;
    serialPort.config.setFlowControl(0);
    serialPort.config.dtr = 0;
    serialPort.config.rts = 0;
  }

  Future<void> runCapture() async {
    BytesBuilder bytesBuilder = BytesBuilder();
    serialPort.open(mode: 3);
    if (serialPort.isOpen){
      reader = SerialPortReader(serialPort);
      reader.stream.listen((data) {
        bytesBuilder.add(data);

        if(bytesBuilder.length > 21){
          var contentData = bytesBuilder.toBytes();
          var listWeight = contentData.sublist(10, 17);
          String valueWeight = String.fromCharCodes(listWeight).trim();
          //print(valueWeight);
          if(_isNumericTryParse(valueWeight)){
            _streamController.add(valueWeight);

          }
          bytesBuilder.clear();
        }
      });
    }
  }

  Map<String, dynamic> getInformation(){
    var info = <String, dynamic>{};
    info['Description'] = serialPort.description;
    info['Transport'] = serialPort.transport.toTransport();
    info['USB Bus'] = serialPort.busNumber?.toPadded();
    info['USB Device'] = serialPort.deviceNumber?.toPadded();
    info['Vendor ID'] = serialPort.vendorId?.toHex();
    info['Product ID'] = serialPort.productId?.toHex();
    info['Manufacturer'] = serialPort.manufacturer;
    info['Product Name'] = serialPort.productName;
    info['Serial Number'] = serialPort.serialNumber;
    info['MAC Address'] = serialPort.macAddress;

    return info;
  }

  void close(){
    try {
      reader.close();
      serialPort.close();
    } on Exception catch (exception) {
      print(exception.toString());
    } catch (error) {
      print(error.toString());
    }
  }
}

extension IntToString on int {
  String toHex() => '0x${toRadixString(16)}';
  String toPadded([int width = 3]) => toString().padLeft(width, '0');
  String toTransport() {
    switch (this) {
      case SerialPortTransport.usb:
        return 'USB';
      case SerialPortTransport.bluetooth:
        return 'Bluetooth';
      case SerialPortTransport.native:
        return 'Native';
      default:
        return 'Unknown';
    }
  }
}
