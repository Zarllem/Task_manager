import 'package:flutter/material.dart';

class MyIconButton extends StatelessWidget {
  final IconData icon;
  final void Function() onPress;
  final Color? color;

  const MyIconButton({
    super.key,
    required this.color,
    required this.icon,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPress,
      child: Icon(
        icon,
        color: color,
      ),
    );
  }
}
