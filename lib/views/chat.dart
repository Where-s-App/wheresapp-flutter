import 'package:flutter/material.dart';
import 'package:wheresapp/api/chat_controller.dart';
import 'package:wheresapp/models/chat_model.dart';
import 'package:wheresapp/models/message_model.dart';
import 'package:wheresapp/widgets/message.dart';

class Chat extends StatefulWidget {
  ChatModel chat;
  late String name;
  late List<MessageModel> messages;

  Chat({super.key, required this.chat}) {
    name = chat.name;
    messages = chat.messages;
  }

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final _messageEditorKey = GlobalKey<FormState>();

  final TextEditingController _messageEditorController =
      TextEditingController(text: '');

  _updateChat() async {
    Map<String, dynamic>? chatData;

    await ChatController.getChatWithId(widget.chat.id)
        .then((value) => chatData = value);

    List<dynamic> messageData = chatData!['messages'];

    List<MessageModel> messages = [];

    messageData.forEach((message) {
      messages.add(MessageModel(message));
    });
    setState(() {
      _messageEditorController.text = '';
      widget.messages = messages;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          children: [
            AppBar(
              iconTheme:
                  IconThemeData(color: Theme.of(context).primaryColorDark),
              title: Text(
                widget.name,
                style: TextStyle(
                    color: Theme.of(context).textTheme.headlineSmall!.color),
              ),
              centerTitle: false,
              backgroundColor: Theme.of(context).backgroundColor,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: widget.messages.length,
                itemBuilder: (context, index) {
                  MessageModel message = widget.messages[index];
                  return Message(message: message.value, type: message.type);
                },
              ),
            ),
            Container(
              height: 70,
              color: Theme.of(context).shadowColor,
              child: Form(
                key: _messageEditorKey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _messageEditorController,
                          decoration: InputDecoration(
                              labelText: 'Message',
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              filled: true,
                              fillColor: Theme.of(context).cardColor,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none)),
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            ChatController.sendMessage(widget.chat.id, 'luis',
                                    _messageEditorController.text)
                                .whenComplete(() => _updateChat());
                          },
                          icon: const Icon(Icons.send))
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
