import 'package:flutter/material.dart';
import 'package:lightning_chat/constants.dart';

class RoundedTextField extends StatelessWidget {
  final String hintText;
  final Function handleChanged;
  final Icon prefixIcon;
  final bool obscureText;
  final TextInputType keyboardType;

  const RoundedTextField({
    @required this.handleChanged,
    this.hintText,
    this.prefixIcon,
    this.obscureText,
    this.keyboardType,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: keyboardType ?? TextInputType.text,
      obscureText: obscureText ?? false,
      onChanged: handleChanged,
      decoration: kTextFieldDecoration.copyWith(
        hintText: hintText,
        prefixIcon: prefixIcon,
      ),
    );
  }
}
