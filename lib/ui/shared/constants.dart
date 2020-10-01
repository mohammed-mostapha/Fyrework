import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(
  filled: true,
  fillColor: Colors.white,
  enabledBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.black26, width: 1.0),
  ),
  focusedBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.black, width: 1.0),
  ),
);

InputDecoration buildSignUpInputDecoration(String hint) {
  return InputDecoration(
    hintText: hint,
    filled: true,
    fillColor: Colors.white,
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.black26, width: 1.0),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.black, width: 1.0),
    ),
  );
}
