import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wheresapp/data/database.dart';
import 'package:wheresapp/models/public_keys_model.dart';
import 'package:wheresapp/security/key_generator.dart';

import 'key_controller.dart';

class ChatController {
  static Stream<QuerySnapshot> getChats(String username) {
    final chats = FirebaseFirestore.instance
        .collection('chats')
        .where('users', arrayContains: username)
        .snapshots();

    return chats;
  }

  static Future<Map<String, dynamic>?> getChatWithId(String chatId) async {
    final chatReference =
        FirebaseFirestore.instance.collection('chats').doc(chatId);

    Map<String, dynamic>? chatData;

    await chatReference.get().then((chat) {
      chatData = chat.data();
    });

    return chatData;
  }

  static Future<bool> isAuthor(String chatId, String username) async {
    final chatPublicKeys = FirebaseFirestore.instance
        .collection('public-keys')
        .where('chatId', isEqualTo: chatId)
        .where('username', isEqualTo: username);

    late bool isAuthor;

    await chatPublicKeys.get().then((keys) {
      for (var chat in keys.docs) {
        final chatKeys = chat.data();
        isAuthor =
            chatKeys.keys.any((element) => element.toString() == 'author');
      }
    });

    return isAuthor;
  }

  static Future<bool> isChatValidated(String chatId) async {
    final publicKeys = FirebaseFirestore.instance
        .collection('public-keys')
        .where('chatId', isEqualTo: chatId);

    late bool valid;

    await publicKeys.get().then((keys) {
      valid = keys.size == 2;
    });

    return valid;
  }

  static Future<void> sendMessage(
      String chatId, String username, String message) {
    final chat = FirebaseFirestore.instance.collection('chats').doc(chatId);

    final time = DateTime.now();

    return chat.update({
      'messages': FieldValue.arrayUnion([
        {
          'author': username,
          'value': message,
          'time': time,
        }
      ])
    });
  }

  static Future<void> createChat(String username, String correspondent) async {
    final chat = FirebaseFirestore.instance.collection('chats').doc();

    late bool isValidCorrespondent;

    await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: correspondent)
        .get()
        .then((data) => isValidCorrespondent =
            data.docs.first.data()['username'] != null &&
                username != correspondent);

    if (!isValidCorrespondent) {
      return Future.error('Correspondent does not exist');
    }

    PublicKeysModel publicKeys = KeyGenerator.generateAuthorPublicKeys(chat.id);

    return chat.set({
      'author': username,
      'correspondent': correspondent,
      'users': [username, correspondent],
      'messages': []
    }).whenComplete(() {
      KeyController.sendAuthorKeys(chat.id, username, publicKeys);
    });
  }

  static Future<void> createChatWithId(
      String chatId, String username, String otherUsername) {
    final chat = FirebaseFirestore.instance.collection('chats').doc(chatId);

    return chat.set({
      'users': [username, otherUsername],
      'messages': []
    });
  }

  static Future<void> deleteChat(String chatId) async {
    final chat = FirebaseFirestore.instance.collection('chats').doc(chatId);

    chat.delete();

    final publicKeys = await FirebaseFirestore.instance
        .collection('public-keys')
        .where('chatId', isEqualTo: chatId)
        .get();

    for (var key in publicKeys.docs) {
      FirebaseFirestore.instance.collection('public-keys').doc(key.id).delete();
    }

    Database(chatId: chatId).deletePrivateKeys();
  }
}
