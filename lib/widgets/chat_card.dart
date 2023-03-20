import 'package:flutter/material.dart';

import '../models/chat_model.dart';

class ChatCard extends StatefulWidget {
  const ChatCard({Key? key, required this.chatModel}) : super(key: key);

  final ChatModel chatModel;

  @override
  ChatCardState createState() => ChatCardState();
}

class ChatCardState extends State<ChatCard> {
  double height = 80;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
            border: Border.all(
                color: Colors.transparent,
                width: 1.0,
                style: BorderStyle.solid),
            borderRadius: const BorderRadius.all(Radius.circular(8.0))),
        height: height,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(right: 20),
                child: CircleAvatar(radius: 20),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FittedBox(
                      child: Text(widget.chatModel.correspondents.join(','),
                          style: Theme.of(context).textTheme.headlineSmall),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 50,
                child: Column(
                  children: [
                    Text(
                        '${widget.chatModel.time.hour.toString()}:${widget.chatModel.time.minute.toString()}'),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
