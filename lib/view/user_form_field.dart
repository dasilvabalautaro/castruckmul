import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UserFormField  extends StatelessWidget {
  final String label;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final bool password;
  final String? init;
  final TextEditingController? textEditingController;

  const UserFormField({Key? key,
    required this.textEditingController,
    required this.label,
    this.inputFormatters,
    this.validator,
    required this.password,
    this.init}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        controller: textEditingController,
        obscureText: password,
        inputFormatters: inputFormatters,
        validator: validator,
        initialValue: init,
        decoration: InputDecoration(labelText: label, isDense: true),
      ),
    );
  }
}
