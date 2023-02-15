import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wheresapp/security/key_generator.dart';

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

  static Future<void> sendCorrespondentKeys(
      String chatId, String username) async {
    final chatPublicKeys = FirebaseFirestore.instance
        .collection('public-keys')
        .where('chatId', isEqualTo: chatId);

    await chatPublicKeys.get().then((keys) {
      bool hasOnlyAuthor = keys.size == 1;

      if (hasOnlyAuthor) {
        final publicKeyReference =
            FirebaseFirestore.instance.collection('public-keys');

        KeyGenerator keyGenerator = KeyGenerator(chatId);

        publicKeyReference.add({
          "correspondent": {
            "generator": keyGenerator.generator,
            "prime": keyGenerator.primeNumber,
            "result": keyGenerator.result,
          },
          "chatId": chatId
        });
      }
    });
  }

  static Future<void> sendMessage(
      String chatId, String username, String message) {
    final chat = FirebaseFirestore.instance.collection('chats').doc(chatId);

    return chat.update({
      'messages': FieldValue.arrayUnion([
        {
          'author': username,
          'value': message,
          'time': DateTime.now(),
        }
      ])
    });
  }

  static Future<void> createChat(String author, String correspondent) async {
    final chat = FirebaseFirestore.instance.collection('chats').doc();

    late bool isValidCorrespondent;

    await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: correspondent)
        .get()
        .then((data) => isValidCorrespondent =
            data.docs.first.data()['username'] != null &&
                author != correspondent);

    if (!isValidCorrespondent) {
      return Future.error('Correspondent does not exist');
    }

    KeyGenerator keyGenerator = KeyGenerator(chat.id);

    return chat.set({
      'author': author,
      'correspondent': correspondent,
      'users': [author, correspondent],
      'messages': [
        {
          'author': author,
          'value': 'Hello!',
          'time': DateTime.now(),
        }
      ]
    }).whenComplete(() {
      final publicKeys =
          FirebaseFirestore.instance.collection('public-keys').doc();

      publicKeys.set({
        'chatId': chat.id,
        'author': {
          'generator': keyGenerator.generator,
          'prime': keyGenerator.primeNumber,
          'result': keyGenerator.result,
        },
        'correspondent': {
          'generator': null,
          'prime': null,
          'result': null,
        }
      });
    });
  }

  static Future<void> createChatWithId(
      String chatId, String username, String otherUsername) {
    final chat = FirebaseFirestore.instance.collection('chats').doc(chatId);

    return chat.set({
      'users': [username, otherUsername],
      'messages': [
        {
          'user': username,
          'value': 'Hello!',
          'createdAt': DateTime.now(),
        }
      ]
    });
  }

  static Future<void> deleteChat(String chatId) {
    final chat = FirebaseFirestore.instance.collection('chats').doc(chatId);

    return chat.delete();
  }

  static Future<void> updateChat(
      String chatId, String username, String message) {
    final chat = FirebaseFirestore.instance.collection('chats').doc(chatId);

    return chat.update({
      'messages': FieldValue.arrayUnion([
        {
          'user': username,
          'value': message,
          'createdAt': DateTime.now(),
        }
      ])
    });
  }

  static Future<void> updateChatWithId(
      String chatId, String username, String message) {
    final chat = FirebaseFirestore.instance.collection('chats').doc(chatId);

    return chat.update({
      'messages': FieldValue.arrayUnion([
        {
          'user': username,
          'value': message,
          'createdAt': DateTime.now(),
        }
      ])
    });
  }
}
