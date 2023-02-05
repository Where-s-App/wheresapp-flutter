import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wheresapp/models/message_model.dart';

class ChatModel {
  ChatModel(QuerySnapshot<Object?> snapshot, int index) {
    _document = snapshot.docs[index];
  }

  late final QueryDocumentSnapshot<Object?> _document;

  String get id => _document.id;

  dynamic get users => _document['users'].where((element) => element != 'luis');
  String get name => users.firstWhere((user) => user != 'luis');

  late final List<dynamic> _messages = _document['messages'];

  List<MessageModel> get messages => _getMessages();

  List<MessageModel> _getMessages() {
    List<MessageModel> messages = [];

    _messages.forEach((element) {
      messages.add(MessageModel(element));
    });

    return messages;
  }

  String get lastMessage => messages.last.value;
  DateTime get time => messages.last.time;
}
