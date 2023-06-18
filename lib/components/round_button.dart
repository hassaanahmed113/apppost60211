import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  final String title;

  final VoidCallback onpress;
  const RoundButton({super.key, required this.title, required this.onpress});

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(10),
      clipBehavior: Clip.antiAlias,
      child: MaterialButton(
        minWidth: double.infinity,
        color: Colors.purple,
        height: 50,
        child: Text(
          title,
          style: TextStyle(color: Colors.white, fontSize: 17),
        ),
        onPressed: onpress,
      ),
    );
  }
}
