import 'package:boilerplate/constants/constants.dart';
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
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return Container(
        
      
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              isEmail ? 'ایمیل' : 'رمز',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            SizedBox(
              height: 5,
            ),
            TextField(
                controller: controller,
                onChanged: (value) {
                  store(controller.text);
                },
                obscureText: obscureText,
                decoration: InputDecoration(
                    errorText: isEmail
                        ? formStore.formErrorStore.userEmail
                        : formStore.formErrorStore.password,
                    border: InputBorder.none,
                    fillColor: Colors.grey[300],
                    filled: true))
          ],
        ),
      );
    });
  }
}
