class PostModel {
  late  String name;
  late String imageProfile;
  late String uid;
  late String textPost;
  late String imagePost;
  late String datetime;

  PostModel(
      {required this.uid,
        required this.datetime,
        required this.imagePost,
        required this.name,
        required this.imageProfile,
        required this.textPost,
      });

  PostModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    imageProfile = json['imageProfile'];
    textPost = json['textPost'];
    imagePost = json['imagePost'];
    datetime = json['datetime'];
    uid = json['uid'];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'datetime': datetime,
      'textPost': textPost,
      'imagePost': imagePost,
      'uid': uid,
      'imageProfile': imageProfile,
    };
  }
}
