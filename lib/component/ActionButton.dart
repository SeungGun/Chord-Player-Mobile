import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget icon;

  const ActionButton({Key? key, required this.onPressed, required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        clipBehavior: Clip.antiAlias,
        shape: CircleBorder(),
        color: Colors.greenAccent,
        elevation: 4.0,
        child: IconButton(icon: icon, onPressed: onPressed));
  }
}
