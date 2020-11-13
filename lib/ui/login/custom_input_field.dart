import 'package:boilerplate/stores/form/form_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class CustomInputField extends StatelessWidget {
  final String label;
  final IconData prefixIcon;
  final bool obscureText;
  final FormStore formStore;
  final TextEditingController controller;
  final void Function(String) store;
  final bool isEmail;

  const CustomInputField({
    @required this.label,
    @required this.prefixIcon,
    @required this.controller,
    @required this.store,
    @required this.isEmail,
    @required this.formStore,
    this.obscureText = false,
  })  : assert(label != null),
        assert(prefixIcon != null);

  @override
  Widget build(BuildContext context) {}
}
