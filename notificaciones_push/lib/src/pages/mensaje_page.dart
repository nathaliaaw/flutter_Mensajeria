import 'package:flutter/material.dart';

class MensajePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments ?? 'No data';

    return Scaffold(
      appBar: AppBar(
        title: Text('Mensaje'),
      ),
      body: Center(
        child: Text('$args', style: TextStyle(fontSize: 30)),
      ),
    );
  }
}