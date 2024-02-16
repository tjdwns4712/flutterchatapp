import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String userId;
  final String message;
  final Color messageColor;
  final Alignment alignment;
  final CrossAxisAlignment idAligment;

  const ChatBubble({
    super.key,
    required this.userId,
    required this.message,
    required this.messageColor,
    required this.alignment,
    required this.idAligment,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: idAligment,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          child: Text(
            userId,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: messageColor,
          ),
          child: Text(
            message,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
