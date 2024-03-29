import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wheresapp/api/chat_controller.dart';
import 'package:wheresapp/api/key_controller.dart';
import 'package:wheresapp/data/database.dart';
import 'package:wheresapp/models/chat_model.dart';
import 'package:wheresapp/security/key_generator.dart';
import 'package:wheresapp/utils/string_extensions.dart';
import 'package:wheresapp/views/chat.dart';
import 'package:wheresapp/views/login.dart';
import 'package:wheresapp/widgets/chat_card.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends ConsumerState<HomePage> {
  _showDeleteChatDialog(String chatId) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              icon: const Icon(Icons.delete),
              title: const Text('Delete chat?'),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel')),
                  ElevatedButton(
                      onPressed: () => ChatController.deleteChat(chatId)
                          .whenComplete(() => Navigator.of(context).pop()),
                      child: const Text('Delete'))
                ],
              ),
            ));
  }

  Widget _buildChats(String username) {
    return StreamBuilder<QuerySnapshot>(
      stream: ChatController.getChats(username),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final data = snapshot.requireData;
        return ListView.builder(
          itemCount: data.size,
          itemBuilder: ((context, index) {
            ChatModel chat = ChatModel(data, index);

            String key = Database(chatId: chat.id).key;

            if (key.isEmpty) {
              ChatController.isChatValidated(chat.id).then((isChatValidated) {
                ChatController.isAuthor(chat.id, username).then((isAuthor) {
                  if (!isChatValidated && !isAuthor) {
                    KeyController.sendCorrespondentKeys(chat.id, username);
                  }
                  if (isChatValidated && isAuthor) {
                    KeyController.getCorrespondentKeys(chat.id)
                        .then((correspondentKeys) {
                      final privateNumber =
                          Database(chatId: chat.id).privateNumber;

                      KeyGenerator.generateSecret(
                          chat.id, correspondentKeys, privateNumber);
                    });
                  }
                });
              });
            }

            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => Chat(chat: chat)));
              },
              onLongPress: () => _showDeleteChatDialog(chat.id),
              child: ChatCard(chatModel: chat),
            );
          }),
        );
      },
    );
  }

  _logout(BuildContext context) {
    Database().deleteCredentials();
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => Login()));
  }

  final FocusNode _newChatFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    String username = Database().username;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        centerTitle: false,
        title: const Text("Where's App"),
        actions: [
          Center(
            child: Text(
              username.capitalize(),
              style: const TextStyle(fontSize: 20),
            ),
          ),
          IconButton(
              onPressed: () => _logout(context),
              icon: const Icon(Icons.exit_to_app))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _buildChats(username),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: const Text('Start new chat'),
                    content: TextField(
                      focusNode: _newChatFocusNode,
                      decoration: const InputDecoration(
                        hintText: 'Enter your friend\'s username',
                      ),
                      onSubmitted: (username) async {
                        try {
                          ChatController.createChat(
                                  Database().username, username)
                              .whenComplete(() => Navigator.of(context).pop());
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(e.toString()),
                            duration: const Duration(seconds: 2),
                          ));
                        }
                      },
                    ),
                  ));
          _newChatFocusNode.requestFocus();
        },
        tooltip: 'New Chat',
        backgroundColor: Theme.of(context).primaryColorDark,
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
