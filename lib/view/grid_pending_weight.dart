import 'package:castruckmul/core/data/weighing.dart';
import 'package:flutter/material.dart';
import '../core/data/user.dart';
import '../domain/get_data.dart';
import '../infrastructure/tools/observer_change.dart';

class GridPending extends StatefulWidget {
  final GetDataUseCase db;
  const GridPending({Key? key, required this.db}) : super(key: key);

  @override
  State<GridPending> createState() => _GridDPendingState();
}

class _GridDPendingState extends State<GridPending> {
  int _numItems = 0;
  late List<bool> selected;
  List<Map<String, dynamic>> _items = [];
  final scrollControllerPending = ScrollController();

  @override
  void initState() {
    super.initState();
    ObserveChange.weightInsert.listen((newVal) => {
      if (newVal)
        {
          ObserveChange.streamControllerInsertWeight.add(false),
          getPending()
        }
    });
    getPending();
  }

  Future<void> getPending() async {
    if (widget.db.isNotConnected()) {
      await widget.db.connect();
      await widget.db
          .getWeighingPending()
          .then((List<Map<String, dynamic>> value) {
        setState(() {
          _items = value;
        });
        _numItems = value.length;
        selected = List<bool>.generate(_numItems, (int index) => false);
      });
    } else {
      await widget.db
          .getWeighingPending()
          .then((List<Map<String, dynamic>> value) {
        setState(() {
          _items = value;
        });
        _numItems = value.length;
        selected = List<bool>.generate(_numItems, (int index) => false);
      });
    }
  }

  void _sendPending(int index){
    List<int> _weightValues = [];

    Weighing weightPending = Weighing(id: _items[index]['id'],
      user: _items[index]['user'], driver: _items[index]['driver'],
        plate: _items[index]['plate'], license: _items[index]['license'],
        register: _items[index]['register'],
        inside: _items[index]['inside'], outside: _items[index]['outside'],
        source: _items[index]['source'],
        target: _items[index]['target'], product: _items[index]['product'],
        weightGross: _items[index]['weight_gross'], weightNet: _items[index]['weight_net'],
        weightTare: _items[index]['weight_tare'], observation: _items[index]['observations']);

    _weightValues.add(_items[index]['weight_gross']);
    _weightValues.add(_items[index]['weight_tare']);
    _weightValues.add(_items[index]['weight_net']);

   ObserveChange.streamControllerWeightUpdate.add(weightPending);
   ObserveChange.streamControllerRestoreWeight.add(_weightValues);

  }
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        controller: scrollControllerPending,
        child: ConstrainedBox(
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height, maxWidth: 200),
            child: IntrinsicHeight(
              child: DataTable(
                horizontalMargin: 5,
                columnSpacing: 15,
                columns: const <DataColumn>[
                  DataColumn(
                    label: Text(
                      'Ticket',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Plate',
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
                        return Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.08);
                      }
                      // Even rows will have a grey color.
                      if (index.isEven) {
                        return Colors.grey.withOpacity(0.5);
                      }
                      return null; // Use default value for other states and odd rows.
                    }),
                    cells: <DataCell>[
                      DataCell(Text(_items[index]['id'].toString(), textAlign: TextAlign.center,)),
                      DataCell(Text(_items[index]['plate'])),
                    ],
                    selected: selected[index],
                    onSelectChanged: (bool? value) {
                      if(value != null && value){

                        _sendPending(index);

                      }
                      setState(() {
                        selected[index] = value!;

                      });
                    },
                  ),
                ),
              ),
            ), //scrollDirection: Axis.horizontal,
        ),
      ),
    );
  }
}
