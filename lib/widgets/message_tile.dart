import 'package:flutter/material.dart';

class MessageTile extends StatefulWidget {
  final String message;
  final String sender;
  final bool sentByMe;

  const MessageTile({
    Key? key,
    required this.message,
    required this.sender,
    required this.sentByMe,

  }) : super(key: key);

  @override
  State<MessageTile> createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  @override
  Widget build(BuildContext context) {

    return Container(
      
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.sender.toUpperCase(),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13,fontWeight: FontWeight.bold ),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(widget.message, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16),)
        ],
      ),
    );
  }
}