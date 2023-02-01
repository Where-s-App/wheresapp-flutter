import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wheresapp/api/chat_controller.dart';
import 'package:wheresapp/models/chat.dart';
import 'package:wheresapp/utils/string_extensions.dart';
import 'package:wheresapp/views/chat.dart';
import 'package:wheresapp/widgets/chat_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool expandedSearchBar = false;
  Widget _buildChats() {
    return StreamBuilder<QuerySnapshot>(
      stream: ChatController.getChats('root'),
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

            return GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Chat(
                              name: chat.name.capitalize(),
                            )));
              },
              child: ChatCard(
                name: chat.name.capitalize(),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      drawer: Drawer(),
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
                    onPressed: _expandSearchBar, icon: Icon(Icons.search))
              ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _buildChats(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (() {
          print('');
        }),
        tooltip: 'New Chat',
        backgroundColor: Theme.of(context).primaryColorDark,
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
