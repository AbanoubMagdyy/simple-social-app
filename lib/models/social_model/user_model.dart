class SocialUserModel {
  late  String name;
  late String email;
  late  String password;
  late String profile;
  late String uid;
  late String bio;

  SocialUserModel(
      {required this.uid,
      required this.password,
      required this.email,
      required this.name,
      required this.profile,
      required this.bio,
      });

  SocialUserModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    bio = json['bio'];
    password = json['password'];
    profile = json['profile'];
    uid = json['uid'];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'profile': profile,
      'bio': bio,
      'password': password,
      'uid': uid,
      'email': email,
    };
  }
}
