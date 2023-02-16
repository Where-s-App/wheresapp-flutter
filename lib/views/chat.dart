import 'package:flutter/material.dart';
import 'package:flutter_des/flutter_des.dart';
import 'package:hive/hive.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wheresapp/api/chat_controller.dart';
import 'package:wheresapp/models/chat_model.dart';
import 'package:wheresapp/models/message_model.dart';
import 'package:wheresapp/providers/session_provider.dart';
import 'package:wheresapp/widgets/message.dart';

class Chat extends ConsumerStatefulWidget {
  ChatModel chat;
  late String name;
  late List<MessageModel> messages;

  Chat({super.key, required this.chat}) {
    name = chat.correspondent;

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

  late String username;

  @override
  void initState() {
    super.initState();
    username = ref.read(SessionProvider.session).user.username;

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
      final secret = Hive.box('keys').get('${widget.chat.id}-secret');
      final decryptedMessage =
          await FlutterDes.decryptFromHex(message['value'], secret);

      message['value'] = decryptedMessage;
      messages.add(MessageModel(message, username));
    }
    setState(() {
      _messageEditorController.text = '';
      widget.messages = messages;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
            appBar: AppBar(
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
                        return Message(
                            message: message.value, type: message.type);
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
                              onPressed: () async {
                                if (_messageEditorController.text.isNotEmpty) {
                                  final username = ref
                                      .read(SessionProvider.session)
                                      .user
                                      .username;
                                  final secret = Hive.box('keys')
                                      .get('${widget.chat.id}-secret')
                                      .toString();
                                  final encryptedMessage =
                                      await FlutterDes.encryptToHex(
                                              _messageEditorController.text,
                                              secret) ??
                                          '';
                                  ChatController.sendMessage(widget.chat.id,
                                          username, encryptedMessage)
                                      .whenComplete(() {
                                    _updateChat();
                                  });
                                }
                              },
                              icon: const Icon(Icons.send))
                        ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
        ),
      );
  }
}
