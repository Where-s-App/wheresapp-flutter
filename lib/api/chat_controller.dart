import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

class ChatController {
  static Stream<QuerySnapshot> getChats(String username) {
    final chats = FirebaseFirestore.instance
        .collection('chats')
        .where('users', arrayContains: username)
        .snapshots();

    return chats;
  }

  static Future<void> sendMessage(
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

  static Future<void> createChat(String username, String otherUsername) {
    final chat = FirebaseFirestore.instance.collection('chats').doc();

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
