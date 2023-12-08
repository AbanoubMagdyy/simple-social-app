class PostModel {
  late  String name;
  late String imageProfile;
  late String textPost;
  late String imagePost;
  late String datetime;
  late String postID;
  late String userID;
 late bool showDetails;
 late int numberOfReacts;
 late List peopleWhoInteracted;

  PostModel(
      {
        required this.numberOfReacts,
        required this.datetime,
        required this.peopleWhoInteracted,
        required this.imagePost,
        required this.name,
        required this.imageProfile,
        required this.textPost,
        required this.showDetails,
        required this.postID,
        required this.userID,
      });

  PostModel.fromJson(Map<String, dynamic> json) {
    name = json['Name'];
    postID = json['Post ID'];
    imageProfile = json['Image Profile'];
    textPost = json['Text Post'];
    imagePost = json['Image Post'];
    datetime = json['datetime'];
    numberOfReacts = json['Number Of Reacts'];
    showDetails = json['Show Details'];
    peopleWhoInteracted = json['People who interacted'];
    userID = json['User ID'];
  }

  Map<String, dynamic> toMap() {
    return {
      'Name': name,
      'datetime': datetime,
      'Text Post': textPost,
      'Image Post': imagePost,
      'Number Of Reacts': numberOfReacts,
      'Image Profile': imageProfile,
      'Show Details': showDetails,
      'People who interacted': peopleWhoInteracted,
      'Post ID': postID,
      'User ID': userID,
    };
  }
}
