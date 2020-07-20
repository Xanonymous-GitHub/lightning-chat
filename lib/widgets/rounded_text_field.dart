import 'package:flutter/material.dart';
import 'package:lightning_chat/constants.dart';

class RoundedTextField extends StatelessWidget {
  final String hintText;
  final Function handleChanged;
  final Icon prefixIcon;

  const RoundedTextField({
    @required this.handleChanged,
    this.hintText,
    this.prefixIcon,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: handleChanged,
      decoration: kTextFieldDecoration.copyWith(
        hintText: hintText,
        prefixIcon: prefixIcon,
      ),
    );
  }
}
