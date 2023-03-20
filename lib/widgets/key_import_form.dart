import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:wheresapp/api/chat_controller.dart';
import 'package:wheresapp/api/key_controller.dart';
import 'package:wheresapp/models/public_keys_model.dart';
import 'package:wheresapp/security/key_generator.dart';

class KeyImportForm extends StatelessWidget {
  KeyImportForm({Key? key, required this.chatId}) : super(key: key);

  String chatId;
  final TextEditingController _textEditingController = TextEditingController();

  void importKeys() async {
    String username = Hive.box('session').get('username');

    await ChatController.isAuthor(chatId, username).then((isAuthor) async {
      PublicKeysModel keys = isAuthor
          ? await KeyController.getCorrespondentKeys(chatId)
          : await KeyController.getAuthorKeys(chatId);
      Hive.box('keys')
          .put('$chatId-privateNumber', int.parse(_textEditingController.text));
      KeyGenerator.generateSecret(
          chatId, keys, int.parse(_textEditingController.text));
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextField(
              controller: _textEditingController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                label: Text('Private Number'),
              )),
          ElevatedButton(
              onPressed: () {
                importKeys();
                Navigator.pop(context);
              },
              child: const Text('Import')),
        ],
      ),
    );
  }
}
