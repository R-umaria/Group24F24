//Andy Guest - Nov 26 2024
//warning popup when the user is doing somthing dangerous

import 'package:flutter/material.dart';

//show a warning notif
void showWarningPopup(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('DANGER'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}
