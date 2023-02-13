import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wheresapp/api/chat_controller.dart';
import 'package:wheresapp/models/chat_model.dart';
import 'package:wheresapp/providers/session_provider.dart';
import 'package:wheresapp/security/key_generator.dart';
import 'package:wheresapp/utils/string_extensions.dart';
import 'package:wheresapp/views/chat.dart';
import 'package:wheresapp/widgets/chat_card.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  bool expandedSearchBar = false;

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
            ChatModel chat = ChatModel(data, index, author: username);

            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => Chat(chat: chat)));
              },
              child: ChatCard(
                name: chat.correspondent.capitalize(),
                lastMessage: chat.lastMessage,
                time: chat.time,
              ),
            );
          }),
        );
      },
    );
  }

  _expandSearchBar() {
    setState(() {
      expandedSearchBar = !expandedSearchBar;
    });
  }

  FocusNode _newChatFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    String username = ref.read(SessionProvider.session).user.username;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      drawer: const Drawer(),
      appBar: AppBar(
        centerTitle: false,
        title: expandedSearchBar ? null : const Text("Where's App"),
        actions: expandedSearchBar
            ? [
                TextField(
                  decoration: InputDecoration(
                      fillColor: Theme.of(context).backgroundColor),
            onSubmitted: (search) => _expandSearchBar(),
          )
        ]
            : [
          IconButton(
              onPressed: _expandSearchBar, icon: const Icon(Icons.search))
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
                    title: Text('Start new chat'),
                    content: TextField(
                      focusNode: _newChatFocusNode,
                      decoration: const InputDecoration(
                        hintText: 'Enter your friend\'s username',
                      ),
                      onSubmitted: (username) async {
                        String key = await KeyGenerator.generateKey();
                        ChatController.createChat(
                            ref.read(SessionProvider.session).user.username,
                            username);
                        Navigator.of(context).pop();
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
