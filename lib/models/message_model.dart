import 'package:wheresapp/widgets/message.dart';

class MessageModel {
  MessageModel(this._message);

  final Map<String, dynamic> _message;

  String get value => _message['value'];
  DateTime get time => _message['time'].toDate();
  String get author => _message['author'];
  MessageType get type =>
      author == 'luis' ? MessageType.fromAuthor : MessageType.fromCorrespondent;
}
