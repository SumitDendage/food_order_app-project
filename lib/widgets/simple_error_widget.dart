import 'package:flutter/material.dart';

class SimpleErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const SimpleErrorWidget({required this.message, required this.onRetry, Key? key}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Text(message),
        SizedBox(height: 8),
        ElevatedButton(onPressed: onRetry, child: Text('Retry'))
      ]),
    );
  }
}
