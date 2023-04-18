import 'package:flutter/material.dart';

import '../message.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    Key? key,
    required this.message,
  }) : super(key: key);

  final Message message;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('${message.uid}:'),
        Text(message.message),
      ],
    );
  }
}
