import 'package:flutter/material.dart';
import 'package:wheresapp/models/message_model.dart';

class MessageFromAuthor extends StatelessWidget {
  const MessageFromAuthor({Key? key, required this.messageModel})
      : super(key: key);

  final MessageModel messageModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.topRight,
        child: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                  topLeft: Radius.circular(8))),
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Text(
                messageModel.value,
                style: Theme.of(context).textTheme.bodyMedium,
                softWrap: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MessageFromCorrespondent extends StatelessWidget {
  const MessageFromCorrespondent({Key? key, required this.messageModel})
      : super(key: key);

  final MessageModel messageModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.topLeft,
        child: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
              borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                  topRight: Radius.circular(8))),
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                messageModel.value,
                style: Theme.of(context).textTheme.bodyMedium,
                softWrap: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MessageFactory {
  MessageFactory({required this.messageModel});

  MessageModel messageModel;

  StatelessWidget get message {
    if (messageModel.type == MessageType.fromAuthor) {
      return MessageFromAuthor(messageModel: messageModel);
    }

    return MessageFromCorrespondent(messageModel: messageModel);
  }
}
