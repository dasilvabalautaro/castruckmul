import 'package:flutter/material.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:castruckmul/infrastructure/tools/crypto.dart';
import '../core/data/user.dart';
import '../domain/get_data.dart';
import '../infrastructure/tools/observer_change.dart';

class UserFormRegister extends StatefulWidget {
  final GetDataUseCase db;
  const UserFormRegister({Key? key, required this.db}) : super(key: key);

  @override
  State<UserFormRegister> createState() => _UserFormState();

}

class _UserFormState extends State<UserFormRegister>{
  final _formKey = GlobalKey<FormState>();
  final textEditingController = TextEditingController();
  bool _isInsert = true;
  var dataUser = {};
  List<Map<String, dynamic>> _items = [];
  bool _active = false;

  void _handleTap() {
    setState(() {
      _active = !_active;
    });
  }

  @override
  void initState() {
    super.initState();
    ObserveChange.streamController.add(false);
    getTypeUser();
    ObserveChange.userSelected.listen((userSelect) => {
      if(userSelect != null){
        _updateData(userSelect)
      }
    });
  }

  Future<void> getTypeUser() async {
    if(widget.db.isNotConnected()){
      await widget.db.connect();
      await widget.db.getTypeUser().then((List<Map<String, dynamic>> value) {
        setState(() {
          _items = value;
        });
      });
    }
    else {
      await widget.db.getTypeUser().then((List<Map<String, dynamic>> value) {
        setState(() {
          _items = value;
        });
      });
    }
  }

  Future<void> _saveUser(Map dataUser, BuildContext context) async {
    int id = await widget.db.insertUser(dataUser);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('New id: ' + id.toString())),
    );

  }

  Future<void> _updateUser(Map dataUser, BuildContext context) async{
    int changes = await widget.db.updateUser(dataUser);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Changes: ' + changes.toString())),
    );
  }

  void _clearData(){
    _isInsert = true;
    dataUser['id'] = 0;
    dataUser['type'] = "";
    dataUser['password'] = "";
    dataUser['login'] = "";
    dataUser['firstName'] = "";
    dataUser['lastName'] = "";
    setState(() {});
  }

  void _updateData(User user){
    _isInsert = false;
    dataUser['id'] = user.id;
    dataUser['type'] = user.type.toString();
    dataUser['password'] = user.password;
    dataUser['login'] = user.login;
    dataUser['firstName'] = user.firstName;
    dataUser['lastName'] = user.lastName;
    setState(() {});

  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: SizedBox(
        width: 400,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: TextFormField(
                  controller: TextEditingController(text: dataUser['firstName']),
                  enabled: true,
                  validator: (val){
                    if (val == null || val.isEmpty) {
                      return 'Enter valid product';
                    } else {
                      dataUser['firstName'] = val;
                    }
                    return null;
                  },
                  onChanged: (text) {
                    dataUser['firstName'] = text;
                  },
                  decoration: const InputDecoration(
                      labelText: 'First Name', isDense: true),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: TextFormField(
                  controller: TextEditingController(text: dataUser['lastName']),
                  enabled: true,
                  validator: (val){
                    if (val == null || val.isEmpty) {
                      return 'Enter valid product';
                    } else {
                      dataUser['lastName'] = val;
                    }
                    return null;
                  },
                  onChanged: (text) {
                    dataUser['lastName'] = text;
                  },
                  decoration: const InputDecoration(
                      labelText: 'Last Name', isDense: true),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: TextFormField(
                  controller: TextEditingController(text: dataUser['login']),
                  enabled: true,
                  validator: (val){
                    if (val == null || val.isEmpty) {
                      return 'Enter valid product';
                    } else {
                      dataUser['login'] = val;
                    }
                    return null;
                  },
                  onChanged: (text) {
                    dataUser['login'] = text;
                  },
                  decoration: const InputDecoration(
                      labelText: 'Login', isDense: true),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: TextFormField(
                  controller: TextEditingController(text: dataUser['password']),
                  enabled: true,
                  obscureText: true,
                  validator: (val){
                    if (val == null || val.isEmpty) {
                      return 'Enter valid product';
                    } else {
                      dataUser['password'] = val;
                    }
                    return null;
                  },
                  onChanged: (text) {
                    dataUser['password'] = text;
                  },
                  decoration: const InputDecoration(
                      labelText: 'Password', isDense: true),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: SelectFormField(
                  controller: TextEditingController(text: dataUser['type']),
                  textAlign: TextAlign.center,
                  type: SelectFormFieldType.dropdown,
                  labelText: 'Type',
                  dialogSearchHint: 'Search item',
                  items: _items,
                  onChanged: (val) => dataUser['type'] = val,
                  onSaved: (val) => print(val),
                  validator: (val) {
                    if(val == null || val.isEmpty){
                      return 'Enter valid level';
                    }
                    else {
                      dataUser['type'] = val;
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Colors.blueGrey[100]),
                        onPressed: () {
                          // Validate returns true if the form is valid, or false otherwise.
                          if (_formKey.currentState!.validate()) {
                            Crypto.encryptAES(dataUser['password']);
                            dataUser['password'] = Crypto.encrypted?.base64;
                            if(_isInsert){
                              _saveUser(dataUser, context);
                            }
                            else{
                              _updateUser(dataUser, context);
                            }

                            ObserveChange.streamController.add(true);
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
      )
    );
  }
}



