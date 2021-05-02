import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ErrorView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Listas da compra',
          style: TextStyle(color: Color(0xFFf0f0f1), fontSize: 25),
        ),
        backgroundColor: Color(0xFF5bb580),
      ),
      body: ColoredBox(
          color: Color(0xFFf3f3f3),
          child: Center(
            child: Image(
              image: AssetImage("assets/img/error.png"),
            ),
          )),
    );
  }
}
