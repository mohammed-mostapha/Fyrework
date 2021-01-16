import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(
  filled: true,
  fillColor: Colors.white,
  enabledBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.black26, width: 0.5),
  ),
  focusedBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.black, width: 0.5),
  ),
);

InputDecoration buildSignUpInputDecoration(String hint) {
  return InputDecoration(
    contentPadding: EdgeInsets.all(0),
    hintStyle: TextStyle(fontSize: 16, color: Colors.black45),
    hintText: hint,
    filled: true,
    fillColor: Colors.grey[50],
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.black26, width: 0.5),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.black, width: 0.5),
    ),
  );
}

InputDecoration profileEditingInputDecoration(String hint) {
  return InputDecoration(
    contentPadding: EdgeInsets.all(0),
    hintStyle: TextStyle(fontSize: 16, color: Colors.grey),
    hintText: hint,
    // filled: true,
    // fillColor: Colors.grey[50],
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.grey[50], width: 0.5),
    ),
    // focusedBorder: UnderlineInputBorder(
    //   borderSide: BorderSide(color: Colors.black, width: 0.5),
    // ),
  );
}
