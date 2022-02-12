import 'package:flutter/material.dart';

class TextPill extends StatelessWidget {
  final String text;
  final double size;
  const TextPill(this.text, {this.size = 14});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(1.0),
      padding: const EdgeInsets.all(3.0),
      decoration: BoxDecoration(
        color: Color.fromRGBO(0, 225, 95, 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
          padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
          child: Text(
            text,
            style: TextStyle(color: Colors.black, fontSize: size),
          )),
    );
  }
}
