import 'package:flutter/material.dart';

enum MessageType {
  fromAuthor,
  fromCorrespondent,
}

class Message extends StatefulWidget {
  const Message({Key? key, required this.message, required this.type})
      : super(key: key);

  final String message;
  final MessageType type;
  @override
  _MessageState createState() => _MessageState();
}

class _MessageState extends State<Message> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: widget.type == MessageType.fromAuthor
            ? Alignment.topRight
            : Alignment.topLeft,
        child: Container(
          decoration: BoxDecoration(
              color: widget.type == MessageType.fromAuthor
                  ? Theme.of(context).cardColor
                  : Theme.of(context).backgroundColor,
              borderRadius: widget.type == MessageType.fromAuthor
                  ? const BorderRadius.only(
                      bottomRight: Radius.circular(8),
                      bottomLeft: Radius.circular(8),
                      topLeft: Radius.circular(8))
                  : const BorderRadius.only(
                      bottomRight: Radius.circular(8),
                      bottomLeft: Radius.circular(8),
                      topRight: Radius.circular(8))),
          padding: const EdgeInsets.all(12),
          child: Text(
            widget.message,
            style: Theme.of(context).textTheme.bodyMedium,
            softWrap: true,
          ),
        ),
      ),
    );
  }
}
