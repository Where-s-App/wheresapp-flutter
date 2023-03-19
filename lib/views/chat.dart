import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wheresapp/api/chat_controller.dart';
import 'package:wheresapp/models/chat_model.dart';
import 'package:wheresapp/models/message_model.dart';
import 'package:wheresapp/security/encryptor.dart';
import 'package:wheresapp/widgets/message.dart';

class Chat extends ConsumerStatefulWidget {
  ChatModel chat;
  late List<MessageModel> messages;

  Chat({super.key, required this.chat}) {
    messages = chat.messages;
  }

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends ConsumerState<Chat> {
  final _messageEditorKey = GlobalKey<FormState>();

  final TextEditingController _messageEditorController =
      TextEditingController(text: '');

  late ScrollController _scrollController;

  String username = Hive.box('session').get('username');

  @override
  void initState() {
    super.initState();

    _updateChat();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: const Duration(microseconds: 1), curve: Curves.ease);
    });
  }

  _updateChat() async {
    Map<String, dynamic>? chatData;

    await ChatController.getChatWithId(widget.chat.id)
        .then((value) => chatData = value);

    List<dynamic> messageData = chatData!['messages'];

    List<MessageModel> messages = [];

    for (var message in messageData) {
      MessageEncryptor encryptor = MessageEncryptor(chatId: widget.chat.id);
      String decryptedMessage = encryptor.decrypt(message['value']);

      message['value'] = decryptedMessage;
      messages.add(MessageModel(message));
    }
    setState(() {
      _messageEditorController.text = '';
      widget.messages = messages;
    });
  }

  _sendMessage() async {
    if (_messageEditorController.text.isNotEmpty) {
      MessageEncryptor encryptor = MessageEncryptor(chatId: widget.chat.id);

      String encryptedMessage =
          encryptor.encrypt(_messageEditorController.text);

      await ChatController.sendMessage(
              widget.chat.id, username, encryptedMessage)
          .whenComplete(() {
        _updateChat();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(color: Theme.of(context).primaryColorDark),
            title: Text(
              widget.chat.correspondents.join(','),
              style: TextStyle(
                  color: Theme.of(context).textTheme.headlineSmall!.color),
            ),
            centerTitle: false,
            backgroundColor: Theme.of(context).backgroundColor,
          ),
          body: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget.messages.length,
                      itemBuilder: (context, index) {
                        MessageModel message = widget.messages[index];
                        return MessageFactory(messageModel: message).message;
                      },
                    ),
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
                              onPressed: () => _sendMessage(),
                              icon: const Icon(Icons.send))
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }
}
