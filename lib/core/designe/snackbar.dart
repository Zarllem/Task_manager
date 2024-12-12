import 'package:flutter/material.dart';

class MySnackbar {
  static SnackBar mySnackbar(String mes) {
    return SnackBar(
      content: Text(
        mes,
        style: const TextStyle(color: Color.fromARGB(255, 202, 161, 234)),
      ),
      backgroundColor: Colors.redAccent,
    );
  }
}
