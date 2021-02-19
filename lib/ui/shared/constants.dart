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

InputDecoration buildSignUpInputDecoration(BuildContext context, String hint) {
  return InputDecoration(
    contentPadding: EdgeInsets.all(0),
    hintStyle: Theme.of(context).textTheme.caption,
    hintText: hint,
    errorStyle: TextStyle(height: 0),
    // filled: true,
    fillColor: Colors.grey[50],
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.black26, width: 0.5),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.black, width: 0.5),
    ),
  );
}

InputDecoration profileEditingInputDecoration(
    BuildContext context, String hint) {
  return InputDecoration(
    contentPadding: EdgeInsets.all(0),
    hintStyle: Theme.of(context).textTheme.caption,
    hintText: hint,
    errorStyle: TextStyle(height: 0),
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
