import 'package:flutter/material.dart';
import 'package:wheresapp/widgets/message.dart';

class Chat extends StatefulWidget {
  const Chat({Key? key, required this.name}) : super(key: key);

  final String name;

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  //List<Message> _buildMessages() {
  //  //return
  //}
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: [
          AppBar(
            iconTheme: IconThemeData(color: Theme.of(context).primaryColorDark),
            title: Text(
              widget.name,
              style: TextStyle(
                  color: Theme.of(context).textTheme.headlineSmall!.color),
            ),
            centerTitle: false,
            backgroundColor: Theme.of(context).backgroundColor,
          ),
          Expanded(
            child: ListView(
              children: const [
                Message(message: 'hello world', type: MessageType.sender),
                Message(message: 'hello you', type: MessageType.receiver),
                Message(message: 'hello world', type: MessageType.sender),
                Message(message: 'hello you', type: MessageType.receiver),
                Message(message: 'hello world', type: MessageType.sender),
                Message(message: 'hello you', type: MessageType.receiver),
                Message(message: 'hello world', type: MessageType.sender),
                Message(message: 'hello you', type: MessageType.receiver),
                Message(message: 'hello world', type: MessageType.sender),
                Message(message: 'hello you', type: MessageType.receiver),
                Message(message: 'hello world', type: MessageType.sender),
                Message(message: 'hello you', type: MessageType.receiver),
                Message(message: 'hello world', type: MessageType.sender),
                Message(message: 'hello you', type: MessageType.receiver),
                Message(message: 'hello world', type: MessageType.sender),
                Message(message: 'hello you', type: MessageType.receiver),
                Message(message: 'hello world', type: MessageType.sender),
                Message(message: 'hello you', type: MessageType.receiver),
                Message(message: 'hello world', type: MessageType.sender),
                Message(message: 'hello you', type: MessageType.receiver),
                Message(message: 'hello world', type: MessageType.sender),
                Message(message: 'hello you', type: MessageType.receiver),
                Message(message: 'hello world', type: MessageType.sender),
                Message(message: 'hello you', type: MessageType.receiver),
                Message(message: 'hello world', type: MessageType.sender),
                Message(message: 'hello you', type: MessageType.receiver),
                Message(message: 'hello world', type: MessageType.sender),
                Message(message: 'hello you', type: MessageType.receiver),
                Message(message: 'hello world', type: MessageType.sender),
                Message(message: 'hello you', type: MessageType.receiver),
                Message(message: 'hello world', type: MessageType.sender),
                Message(message: 'hello you', type: MessageType.receiver),
                Message(message: 'hello world', type: MessageType.sender),
                Message(message: 'hello you', type: MessageType.receiver),
                Message(message: 'hello world', type: MessageType.sender),
                Message(message: 'hello you', type: MessageType.receiver),
                Message(message: 'hello world', type: MessageType.sender),
                Message(message: 'hello you', type: MessageType.receiver),
                Message(message: 'hello world', type: MessageType.sender),
                Message(message: 'hello you', type: MessageType.receiver),
                Message(message: 'hello world', type: MessageType.sender),
                Message(message: 'hello you', type: MessageType.receiver)
              ],
            ),
          ),
          Container(
            height: 50,
            color: Theme.of(context).shadowColor,
          )
        ],
      ),
    );
  }
}
