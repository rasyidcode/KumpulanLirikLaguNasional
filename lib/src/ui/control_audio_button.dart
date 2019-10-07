import 'package:flutter/material.dart';

class ControlAudioButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Function onPressed;

  ControlAudioButton({
    @required this.icon,
    @required this.color,
    @required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: OutlineInputBorder(
        borderSide: BorderSide(color: color, width: 2.0),
        borderRadius: BorderRadius.circular(50.0),
      ),
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(50.0),
        onTap: onPressed,
        child: Container(
          width: 50.0,
          height: 50.0,
          child: Icon(icon, size: 30.0, color: color),
        ),
      ),
    );
  }
}
