import 'package:flutter/material.dart';

class ErrorWidget extends StatelessWidget
{
  final String message;

  ErrorWidget(this.message);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Text(
          message,
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 24),
          textAlign: TextAlign.center,
        ),
      )
    );
  }
}

class ProcessingWidget extends StatelessWidget
{
  final String text;

  ProcessingWidget(this.text);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        semanticsLabel: text,
      ),
    );
  }
}