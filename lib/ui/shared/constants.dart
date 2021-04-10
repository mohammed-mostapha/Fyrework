import 'package:flutter/material.dart';

//

InputDecoration signUpInputDecoration(BuildContext context, String hint) {
  return InputDecoration(
    filled: true,
    fillColor: Colors.grey[900],
    contentPadding: EdgeInsets.only(left: 10),
    // hintStyle: Theme.of(context).textTheme.caption,
    hintText: hint,
    errorStyle: TextStyle(height: 0),
    enabledBorder: UnderlineInputBorder(
        borderSide:
            BorderSide(color: Theme.of(context).primaryColor, width: 0.5),
        borderRadius: BorderRadius.circular(10)),
    // focusedBorder: UnderlineInputBorder(
    //     borderSide:
    //         BorderSide(color: Theme.of(context).primaryColor, width: 0.5),
    //     borderRadius: BorderRadius.circular(10)),
    border: UnderlineInputBorder(borderRadius: BorderRadius.circular(10)),
  );
}

InputDecoration profileEditingInputDecoration(
    BuildContext context, String hint) {
  return InputDecoration(
    contentPadding: EdgeInsets.all(0),
    // hintStyle: Theme.of(context).textTheme.caption,
    hintText: hint,
    errorStyle: TextStyle(height: 0),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.grey[50], width: 0.5),
    ),
  );
}
