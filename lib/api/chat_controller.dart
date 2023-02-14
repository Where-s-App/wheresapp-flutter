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

    KeyGenerator keyGenerator = KeyGenerator();

    return chat.set({
      'primeNumber': keyGenerator.primeNumber,
      'generator': keyGenerator.generator,
      'result': keyGenerator.result,
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
