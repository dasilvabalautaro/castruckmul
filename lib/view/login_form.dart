import 'package:castruckmul/view/user_form_field.dart';
import 'package:flutter/material.dart';

import '../core/data/user.dart';
import '../domain/get_data.dart';
import '../main.dart';
import 'main_screen.dart';

class Login extends StatefulWidget{
  final GetDataUseCase db;
  const Login({Key? key, required this.db}) : super(key: key);
  static User? user;
  @override
  State<Login> createState() => _LoginFormState();

}

class _LoginFormState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final textEditingController = TextEditingController();
  String? _login;
  String? _password;
  String? _message;
  bool? isEnter;

  @override
  void initState() {
    super.initState();
    _message = "";
    isEnter = false;
  }

  Future<void> _getUser(String log, String pwd) async {
    await widget.db.connect();
    Login.user = await widget.db.getUserByLogin(log, pwd);
    if(Login.user != null){
      setState(() {
        _message = "Welcome ${Login.user?.firstName}";
      });
      setState(() {
        isEnter = true;
      });
    }
    else {
      setState(() {
        _message = "User not found.";
      });
      setState(() {
        isEnter = false;
      });
    }
  }

  void _navigateAndDisplaySelection(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MainScreen(db: widget.db)),
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter your personal data.'),
      ),
      body: Center(
        child: SizedBox(
          width: 400,
          child: Column(
            children: [
              const SizedBox(height: 10),
              Card(
                elevation: 12,
                child: SizedBox(
                  width: 300,
                  height: 50,
                  child: Container(
                    color: Colors.greenAccent,
                    child: const Center(
                        child:
                        Text('LOGIN', style: TextStyle(fontSize: 20))),
                  ),
                ),
              ),
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: TextFormField(
                          enabled: true,
                          validator: (val){
                            if (val == null || val.isEmpty) {
                              return 'Enter valid login';
                            } else {
                              _login = val;
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                              labelText: 'Login', isDense: true),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: TextFormField(
                          enabled: true,
                          obscureText: true,
                          validator: (val){
                            if (val == null || val.isEmpty) {
                              return 'Enter valid password';
                            } else {
                              _password = val;
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                              labelText: 'Password', isDense: true),
                        ),
                      ),
                      if(!isEnter!) Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(primary: Colors.blueGrey[100]),
                          onPressed: () {
                            // Validate returns true if the form is valid, or false otherwise.
                            if (_formKey.currentState!.validate()) {
                              _getUser(_login!, _password!);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Processing Data')),
                              );
                            }
                          },
                          child: const Text('Submit'),
                        ),
                      ),
                    ],
                  )
              ),
              if(isEnter!) Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.blueGrey[100]),
                  onPressed: () {
                    _navigateAndDisplaySelection(context);
                  },
                  child: Text('$_message'),
                ),
              )
              else Text('$_message'),
            ],
          ),
        )
      )
    );
  }
}