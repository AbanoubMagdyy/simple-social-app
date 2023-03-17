class MassageModel {
  late  String massage;
  late String senderId;
  late String receiverId;
  late String datetime;

  MassageModel(
      {required this.massage,
        required this.datetime,
        required this.senderId,
        required this.receiverId,
      });

  MassageModel.fromJson(Map<String, dynamic> json) {
    receiverId = json['receiverId'];
    senderId = json['senderId'];
    datetime = json['datetime'];
    massage = json['massage'];
  }

  Map<String, dynamic> toMap() {
    return {
      'receiverId': receiverId,
      'datetime': datetime,
      'senderId': senderId,
      'massage': massage,
    };
  }
}
