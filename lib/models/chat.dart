import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  ChatModel(QuerySnapshot<Object?> snapshot, int index) {
    _document = snapshot.docs[index];
  }

  late final QueryDocumentSnapshot<Object?> _document;

  dynamic get users => _document['users'].where((element) => element != 'root');
  String get name => users.firstWhere((user) => user != 'root');

  late final dynamic messages = _document['messages'];

  String get lastMessage => messages.last['value'];
  DateTime get time => messages.last['time'].toDate();
}
