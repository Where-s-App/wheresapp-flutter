import 'package:flutter/material.dart';

class ChatCard extends StatefulWidget {
  const ChatCard(
      {Key? key,
      required this.name,
      required this.lastMessage,
      required this.time})
      : super(key: key);

  final String name;
  final String lastMessage;
  final DateTime time;
  @override
  _ChatCardState createState() => _ChatCardState();
}

class _ChatCardState extends State<ChatCard> {
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
                      child: Text(widget.name,
                          style: Theme.of(context).textTheme.headlineSmall),
                    ),
                    Text(widget.lastMessage.length > 50
                        ? '${widget.lastMessage.substring(0, 40)}...'
                        : widget.lastMessage)
                  ],
                ),
              ),
              SizedBox(
                width: 50,
                child: Column(
                  children: [
                    Text(
                        '${widget.time.hour.toString()}:${widget.time.minute.toString()}'),
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
