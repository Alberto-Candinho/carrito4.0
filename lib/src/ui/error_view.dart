import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ErrorView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Shopping Lists')),
      body: ColoredBox(
        color: Colors.yellow,
        child: Text('Error'),
      ),
    );
  }
}