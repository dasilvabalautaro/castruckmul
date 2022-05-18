import 'dart:ffi';

import 'package:castruckmul/core/data/weighing.dart';
import 'package:flutter/material.dart';

import '../domain/get_data.dart';
import '../infrastructure/tools/observer_change.dart';
import 'login_form.dart';

class WeighingForm extends StatefulWidget {
  final GetDataUseCase db;

  const WeighingForm({Key? key, required this.db}) : super(key: key);

  @override
  State<WeighingForm> createState() => _WeighingFormState();

}

class _WeighingFormState extends State<WeighingForm> {
  final _formKey = GlobalKey<FormState>();
  final textEditingController = TextEditingController();
  final scrollControllerFromWeight = ScrollController();
  bool _isInsert = true;
  var dataWeight = {};
  DateTime now = DateTime.now();
  DateTime departureDate = DateTime.now();
  String ticket = '0';
  String? convertedDateTime;
  List<int> _weightValues = [];

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {

    super.initState();
    ObserveChange.weightValue.listen((newVal) => {
      if(newVal.isNotEmpty){
        _weightValues = newVal
      }
    });
    ObserveChange.weightUpdate.listen((weightSelect) => {
      if(weightSelect != null){
        _updateData(weightSelect)
      }
    });
    _clearData();

  }

  Future<void> _saveWeighing(BuildContext context) async {
    _completeData(0);
    if(dataWeight['weightGross'] != 0){
      int id = await widget.db.insertWeighing(dataWeight);
      setState(() {
        dataWeight['register'] = _changeFormatDate(dataWeight['register']);
        dataWeight['inside'] = _changeFormatDate(dataWeight['inside']);
        dataWeight['outside'] = "0";
        ticket = id.toString();
      });
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Weight not found.')),
      );

    }
  }

  Future<void> _updateWeighing(BuildContext context) async {
    _completeDataUpdate();
    if(dataWeight['weightGross'] != 0){
      int id = await widget.db.updateWeighing(dataWeight);
      setState(() {
        dataWeight['register'] = _changeFormatDate(dataWeight['register']);
        dataWeight['inside'] = _changeFormatDate(dataWeight['inside']);
        dataWeight['outside'] = _changeFormatDate(dataWeight['outside']);

      });
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Weight not found.')),
      );

    }

  }

  void _completeDataUpdate() {
    dataWeight['register'] = _changeFormatStringToInt(dataWeight['register']);
    dataWeight['inside'] = _changeFormatStringToInt(dataWeight['inside']);
    dataWeight['outside'] = DateTime.now().millisecondsSinceEpoch;
    dataWeight['weightGross'] = _weightValues[0];
    dataWeight['weightTare'] = _weightValues[1];
    dataWeight['weightNet'] = _weightValues[2];

  }

  void _completeData(int outside) {
    dataWeight['user'] = Login.user?.id;
    dataWeight['register'] = DateTime.now().millisecondsSinceEpoch;
    dataWeight['inside'] = DateTime.now().millisecondsSinceEpoch;
    dataWeight['outside'] = outside;
    dataWeight['weightGross'] = _weightValues[0];
    dataWeight['weightTare'] = _weightValues[1];
    dataWeight['weightNet'] = _weightValues[2];

  }

  int _changeFormatStringToInt(String date){
    DateTime dateRegain = DateTime.parse(date);
    return dateRegain.millisecondsSinceEpoch;
  }
  String _changeFormatDate(int dateMill){
    DateTime newYearsDay = DateTime.fromMillisecondsSinceEpoch(dateMill, isUtc:false);
    String converted =
    "${newYearsDay.year.toString()}-${newYearsDay.month.toString().padLeft(2, '0')}-${newYearsDay.day.toString().padLeft(2, '0')} ${newYearsDay.hour.toString().padLeft(2, '0')}-${newYearsDay.minute.toString().padLeft(2, '0')}";
    return converted;

  }
  void _clearData(){
    _isInsert = true;
    convertedDateTime =
    "${now.year.toString()}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} ${now.hour.toString().padLeft(2, '0')}-${now.minute.toString().padLeft(2, '0')}";

    dataWeight['user'] = 0;
    dataWeight['register'] = convertedDateTime;
    dataWeight['inside'] = convertedDateTime;
    dataWeight['outside'] = '0';
    dataWeight['observation'] = "";
    dataWeight['plate'] = "";
    dataWeight['driver'] = "";
    dataWeight['license'] = "";
    dataWeight['source'] = "";
    dataWeight['target'] = "";
    dataWeight['product'] = "";
    dataWeight['weightGross'] = 0;
    dataWeight['weightTare'] = 0;
    dataWeight['weightNet'] = 0;
    ticket = "0";
    _weightValues.clear();
    _weightValues.add(0);
    _weightValues.add(0);
    _weightValues.add(0);
    ObserveChange.streamControllerRestoreWeight.add(_weightValues);
    setState(() {});
  }

  void _updateData(Weighing weighing){
    _isInsert = false;
    dataWeight['id'] = weighing.id;
    dataWeight['user'] = weighing.user;
    dataWeight['register'] = _changeFormatDate(weighing.register);
    dataWeight['inside'] = _changeFormatDate(weighing.inside);
    dataWeight['outside'] = _changeFormatDate(DateTime.now().millisecondsSinceEpoch);
    dataWeight['observation'] = weighing.observation;
    dataWeight['plate'] = weighing.plate;
    dataWeight['driver'] = weighing.driver;
    dataWeight['license'] = weighing.license;
    dataWeight['source'] = weighing.source;
    dataWeight['target'] = weighing.target;
    dataWeight['product'] = weighing.product;
    dataWeight['weightGross'] = weighing.weightGross;
    dataWeight['weightTare'] = weighing.weightTare;
    dataWeight['weightNet'] = weighing.weightNet;
    ticket = weighing.id.toString();
    setState(() {});

  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        controller: scrollControllerFromWeight,
        child: ConstrainedBox(
          constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height, maxWidth: 400),
          child: IntrinsicHeight(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: TextFormField(
                      controller: TextEditingController(text: ticket),
                      enabled: false,
                      validator: (val){
                        if (val == null || val.isEmpty) {
                          return 'Enter valid ticket';
                        } else {
                          ticket = val;
                        }
                        return null;
                      },
                      onChanged: (text) {
                        ticket = text;
                      },
                      decoration: const InputDecoration(
                          labelText: 'Ticket', isDense: true),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: TextFormField(
                      controller: TextEditingController(text: dataWeight['register']),
                      enabled: false,
                      validator: (val){
                        if (val == null || val.isEmpty) {
                          return 'Enter valid register';
                        } else {
                          dataWeight['register'] = val;
                        }
                        return null;
                      },
                      onChanged: (text) {
                        dataWeight['register'] = text;
                      },
                      decoration: const InputDecoration(
                          labelText: 'Date of register', isDense: true),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: TextFormField(
                      controller: TextEditingController(text: dataWeight['inside']),
                      enabled: false,
                      validator: (val){
                        if (val == null || val.isEmpty) {
                          return 'Enter valid inside';
                        } else {
                          dataWeight['inside'] = val;
                        }
                        return null;
                      },
                      onChanged: (text) {
                        dataWeight['inside'] = text;
                      },
                      decoration: const InputDecoration(
                          labelText: 'Date of admission', isDense: true),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: TextFormField(
                      controller: TextEditingController(text: dataWeight['outside']),
                      enabled: false,
                      validator: (val){
                        if (val == null || val.isEmpty) {
                          return 'Enter valid outside';
                        } else {
                          dataWeight['outside'] = val;
                        }
                        return null;
                      },
                      onChanged: (text) {
                        dataWeight['outside'] = text;
                      },
                      decoration: const InputDecoration(
                          labelText: 'Departure date', isDense: true),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: TextFormField(
                      controller: TextEditingController(text: dataWeight['plate']),
                      enabled: true,
                      validator: (val){
                        if (val == null || val.isEmpty) {
                          return 'Enter valid plate';
                        } else {
                          dataWeight['plate'] = val;
                        }
                        return null;
                      },
                      onChanged: (text) {
                        dataWeight['plate'] = text;

                      },
                      decoration: const InputDecoration(
                          labelText: 'Plate', isDense: true),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: TextFormField(
                      controller: TextEditingController(text: dataWeight['driver']),
                      enabled: true,
                      validator: (val){
                        if (val == null || val.isEmpty) {
                          return 'Enter valid driver';
                        } else {
                          dataWeight['driver'] = val;
                        }
                        return null;
                      },
                      onChanged: (text) {
                        dataWeight['driver'] = text;
                      },
                      decoration: const InputDecoration(
                          labelText: 'Driver', isDense: true),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: TextFormField(
                      controller: TextEditingController(text: dataWeight['license']),
                      enabled: true,
                      validator: (val){
                        if (val == null || val.isEmpty) {
                          return 'Enter valid license';
                        } else {
                          dataWeight['license'] = val;
                        }
                        return null;
                      },
                      onChanged: (text) {
                        dataWeight['license'] = text;
                      },
                      decoration: const InputDecoration(
                          labelText: 'License', isDense: true),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: TextFormField(
                      controller: TextEditingController(text: dataWeight['product']),
                      enabled: true,
                      validator: (val){
                        if (val == null || val.isEmpty) {
                          return 'Enter valid product';
                        } else {
                          dataWeight['product'] = val;
                        }
                        return null;
                      },
                      onChanged: (text) {
                        dataWeight['product'] = text;
                      },
                      decoration: const InputDecoration(
                          labelText: 'Product', isDense: true),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: TextFormField(
                      controller: TextEditingController(text: dataWeight['source']),
                      enabled: true,
                      validator: (val){
                        if (val == null || val.isEmpty) {
                          return 'Enter valid source';
                        } else {
                          dataWeight['source'] = val;
                        }
                        return null;
                      },
                      onChanged: (text) {
                        dataWeight['source'] = text;
                      },
                      decoration: const InputDecoration(
                          labelText: 'Source', isDense: true),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: TextFormField(
                      controller: TextEditingController(text: dataWeight['target']),
                      enabled: true,
                      validator: (val){
                        if (val == null || val.isEmpty) {
                          return 'Enter valid target';
                        } else {
                          dataWeight['target'] = val;
                        }
                        return null;
                      },
                      onChanged: (text) {
                        dataWeight['target'] = text;
                      },
                      decoration: const InputDecoration(
                          labelText: 'Target', isDense: true),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: TextFormField(
                      controller: TextEditingController(text: dataWeight['observation']),
                      enabled: true,
                      validator: (val){
                        if (val == null || val.isEmpty) {
                          return 'Enter valid observation';
                        } else {
                          dataWeight['observation'] = val;
                        }
                        return null;
                      },
                      onChanged: (text) {
                        dataWeight['observation'] = text;
                      },
                      decoration: const InputDecoration(
                          labelText: 'Observation', isDense: true),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.blueGrey[100]),
                            onPressed: () {
                              // Validate returns true if the form is valid, or false otherwise.
                              if (_formKey.currentState!.validate()) {

                                if(_isInsert){
                                  _saveWeighing(context);
                                }
                                else{
                                  _updateWeighing(context);
                                }
                                ObserveChange.streamControllerInsertWeight.add(true);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Processing Data')),
                                );
                              }
                            },
                            child: const Text('Submit'),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.blueGrey[100]),
                            onPressed: () {
                              // Validate returns true if the form is valid, or false otherwise.
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Processing Data')),
                              );
                            },
                            child: const Text('Print'),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.blueGrey[100]),
                            onPressed: () {
                              _clearData();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Clearing Data')),
                              );
                            },
                            child: const Text('New'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
