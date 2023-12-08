import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  late  String message;
  late String senderId;
  late String receiverId;
  late String time;
  late DateTime dateTime;

  MessageModel(
      {required this.message,
        required this.time,
        required this.senderId,
        required this.receiverId,
        required this.dateTime,
      });

  MessageModel.fromJson(Map<String, dynamic> json) {
    receiverId = json['Receiver ID'];
    senderId = json['Sender ID'];
    time = json['Time'];
    Timestamp firestoreTimestamp = json['datetime'];
    DateTime date = firestoreTimestamp.toDate();
    dateTime = date;
    message = json['Message'];
  }

  Map<String, dynamic> toMap() {
    return {
      'Receiver ID': receiverId,
      'Time': time,
      'Sender ID': senderId,
      'Message': message,
      'datetime': dateTime,
    };
  }
}
