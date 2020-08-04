import 'package:flutter/material.dart';
import 'package:lightning_chat/utils/constants.dart';

class RoundedTextField extends StatelessWidget {
  final String hintText;
  final Function handleChanged;
  final Icon prefixIcon;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextEditingController textEditingController;

  const RoundedTextField({
    this.handleChanged,
    @required this.textEditingController,
    this.hintText,
    this.prefixIcon,
    this.obscureText,
    this.keyboardType,
    Key key,
  }) : super(key: key);

  void clearTextInput() {}

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textEditingController,
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
