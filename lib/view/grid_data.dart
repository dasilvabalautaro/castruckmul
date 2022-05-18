import 'package:castruckmul/core/data/user.dart';
import 'package:flutter/material.dart';

import '../domain/get_data.dart';
import '../infrastructure/tools/observer_change.dart';

class GridData extends StatefulWidget{
  final GetDataUseCase db;
  const GridData({Key? key, required this.db}) : super(key: key);

  @override
  State<GridData> createState() => _GridDataState();
}

class _GridDataState extends State<GridData>{
  int _numItems = 0;
  late List<bool> selected;
  List<Map<String, dynamic>> _items = [];

  @override
  void initState() {
    super.initState();
    ObserveChange.usersUpdateList.listen((newVal) => {
      if(newVal){
        ObserveChange.streamController.add(false),
        getUsers()

      }
    });
    getUsers();
  }

  Future<void> getUsers() async {
    if(widget.db.isNotConnected()){
      await widget.db.connect();
      await widget.db.getUsers().then((List<Map<String, dynamic>> value) {
        setState(() {
          _items = value;
        });
        _numItems = value.length;
        selected = List<bool>.generate(_numItems, (int index) => false);
      });
    }
    else {
      await widget.db.getUsers().then((List<Map<String, dynamic>> value) {
        setState(() {
          _items = value;
        });
        _numItems = value.length;
        selected = List<bool>.generate(_numItems, (int index) => false);
      });
    }
  }

  void _sendUserSelected(int index){
    int type = _items[index]['type'] == 'Operator' ? 1: 2;
    User user = User(id: _items[index]['id'],
        type: type, login: _items[index]['login'],
        password: _items[index]['password'],
        firstName: _items[index]['first_name'], lastName: _items[index]['last_name']);
    ObserveChange.streamControllerUserSelected.add(user);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const <DataColumn>[
          DataColumn(
            label: Text(
              'First Name',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
          DataColumn(
            label: Text(
              'Last Name',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
          DataColumn(
            label: Text(
              'Login',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
          DataColumn(
            label: Text(
              'Level',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ],
        rows: List<DataRow>.generate(
          _numItems,
              (int index) => DataRow(
                  color: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                      // All rows will have the same selected color.
                      if (states.contains(MaterialState.selected)) {
                        return Theme.of(context).colorScheme.primary.withOpacity(0.08);
                      }
                      // Even rows will have a grey color.
                      if (index.isEven) {
                        return Colors.grey.withOpacity(0.3);
                      }
                      return null; // Use default value for other states and odd rows.
                  }),
            cells: <DataCell>[
              DataCell(Text(_items[index]['first_name'])),
              DataCell(Text(_items[index]['last_name'])),
              DataCell(Text(_items[index]['login'])),
              DataCell(Text(_items[index]['type'])),
            ],
            selected: selected[index],
            onSelectChanged: (bool? value) {
              if(value != null && value){
                _sendUserSelected(index);
              }

              setState(() {
                selected[index] = value!;
              });
            },
          ),
        ),
      ),
    );
  }
}