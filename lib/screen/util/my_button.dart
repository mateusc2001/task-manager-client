import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String text;
  VoidCallback action;

  MyButton({Key? key, required this.text, required this.action})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: action,
      color: Theme.of(context).primaryColor,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Text(text),
      ),
    );
  }
}
