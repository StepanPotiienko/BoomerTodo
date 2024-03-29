import "package:flutter/material.dart";

class DialogControlButton extends StatelessWidget {
  final String buttonValue;
  final VoidCallback onPressed;

  const DialogControlButton(
      {super.key, required this.buttonValue, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      color: Theme.of(context).primaryColor,
      child: Text(buttonValue),
    );
  }
}
