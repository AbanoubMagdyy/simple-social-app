import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:simple_social_app/shared/social_bloc/states.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../../components/constants.dart';
import '../../models/social_model/massage_model.dart';
import '../../models/social_model/post_model.dart';
import '../../models/social_model/user_model.dart';
import '../../screens/feeds_screen.dart';
import '../../screens/chat_screen.dart';
import '../../screens/profile_screen.dart';
import '../../screens/setting_screen.dart';


class SocialCubit extends Cubit<SocialStates> {
  SocialCubit() : super(SocialInitial());

  static SocialCubit get(context) => BlocProvider.of(context);

  List<Widget> screens = const [
    FeedsScreen(),
    ChatScreen(),
    ProfileScreen(),
    SettingScreen()
  ];

  int currantIndex = 0;

  void changeBNB(int index) {
    currantIndex = index;
    emit(ChangeBNB());
  }

  SocialUserModel? userModel;

  void getUserData() {
    if(id != ''){
      emit(LeadingGetUserData());
      FirebaseFirestore.instance.collection('users').doc(id).get().then((value) {
        userModel = SocialUserModel.fromJson(value.data()!);
        getPosts();
        getAllUsers();
        emit(SuccessGetUserData());
      },
      ).catchError((error) {
        if (kDebugMode) {
          print(error.toString());
        }
        emit(ErrorGetUserData());
      },
      );
    }

  }

  bool emoji = true;

  void changeEmoji() {
    emoji = !emoji;
    emit(ChangeEmoji());
  }


  ImagePicker imagePicker = ImagePicker();
  File? profileImage;
  File? postImage;


  Future<void> getProfileImageFromGallery() async {
    final XFile? pickedFile =
    await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      emit(SuccessImage());
    } else {
      emit(ErrorImage());
    }
  }
  Future<void> getPostImageFromGallery() async {
    final XFile? pickedFile =
    await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      postImage = File(pickedFile.path);
      emit(SuccessImage());
    } else {
      emit(ErrorImage());
    }
  }

String imageProfilePath ='';

  Future<void> updateProfileImage() async {
    String imagePath =
        'users/${Uri.file(profileImage!.path).pathSegments.last}';
    try {
      await firebase_storage.FirebaseStorage.instance
          .ref()
          .child(imagePath)
          .putFile(profileImage!);

      final downloadURL = await firebase_storage.FirebaseStorage.instance
          .ref(imagePath)
          .getDownloadURL();

      imageProfilePath = downloadURL;
      emit(SuccessUploadProfile());
    } catch (error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ErrorUploadProfile());
    }
  }

  Future<void> updateUser({
    required String name,
    required String bio,
  }) async {
    emit(LeadingUpdateUserData());

    if(profileImage == null) {
     await FirebaseFirestore.instance
          .collection('users')
          .doc(userModel!.uid)
          .update({
        'name' : name,
        'bio' : bio
      })
          .then((value) {
        emit(SuccessUpdateUserData());
        getUserData();
      }).catchError((error) {
        if (kDebugMode) {
          print(error.toString());
        }
        emit(ErrorUpdateUserData());
      });
    }else{
      await updateProfileImage();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userModel!.uid)
          .update({
        'name' : name,
        'bio' : bio,
        'profile' : imageProfilePath
      })
          .then((value) {
        emit(SuccessUpdateUserData());
        getUserData();
      }).catchError((error) {
        if (kDebugMode) {
          print(error.toString());
        }
        emit(ErrorUpdateUserData());
      });
    }

  }



  void removeImagePost() {
    postImage = null;
    emit(RemoverImagePost());
  }

  void createPost({
    required String dateTime,
    String? imagePost,
    required String textPost,
  }) {
    emit(LeadingCreatePost());
    PostModel model = PostModel(
      userID: userModel!.uid,
      postID: '',
      peopleWhoInteracted: [],
      showDetails: true,
        datetime: dateTime,
        imagePost: imagePost ?? '',
        name: userModel!.name,
        imageProfile: userModel!.profile,
        textPost: textPost,
        numberOfReacts: 0,
    );
    FirebaseFirestore.instance
        .collection('Posts')
        .add(model.toMap())
        .then((value) {
          updatePostID(value.id);
      emit(SuccessCreatePost());
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ErrorCreatePost());
    });
  }

  Future<void> updatePostID(String id) async {
    await  FirebaseFirestore.instance
        .collection('Posts').doc(id).update(
      {'Post ID': id},
    ).then((value) {
      emit(SuccessUpdatePostID());
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ErrorUpdatePostID());
    });
  }


  void upLoadPostImage({
    required String dateTime,
    required String textPost,
  }) {
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('Posts/${Uri.file(postImage!.path).pathSegments.last}')
        .putFile(postImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        createPost(dateTime: dateTime, imagePost: value, textPost: textPost);
      }).catchError((error) {
        if (kDebugMode) {
          print(error.toString());
        }
        emit(ErrorImagePost());
      });
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ErrorImagePost());
    });
  }

  List<PostModel> posts = [];
  List<PostModel> myPosts = [];
  List<String> postsId = [];

  Future<void> getPosts() async {
    posts = [];
    myPosts = [];
    emit(LeadingGetPosts());
    FirebaseFirestore.instance.collection('Posts').get().then((value) {
      for (var element in value.docs) {
        if(element['User ID'] == userModel!.uid){
          myPosts.add(PostModel.fromJson(element.data()));
        }
        postsId.add(element.id);
        posts.add(PostModel.fromJson(element.data()));
      }
      emit(SuccessGetPosts());
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ErrorGetPosts());
    });
  }

  Future<void> likePost({
    required String postId,
    required int index,
  required bool interactedBefore
  }) async {
    var list = posts[index].peopleWhoInteracted;
    if(interactedBefore){
      list.remove(userModel?.uid);
      FirebaseFirestore.instance
          .collection('Posts')
          .doc(postId)
          .update(
        {
          'Number Of Reacts': FieldValue.increment(-1),
          'People who interacted': list,
        },
      ).then((value) {
        emit(SuccessGetLikes());
      }).catchError((error) {
        if (kDebugMode) {
          print(error.toString());
        }
        emit(ErrorGetLikes());
      });
    }else{
      list.add(userModel?.uid);
      FirebaseFirestore.instance
          .collection('Posts')
          .doc(postId)
          .update(
        {
          'Number Of Reacts': FieldValue.increment(1),
          'People who interacted': list, // Convert the set to a list
        },
      ).then((value) {
        emit(SuccessGetLikes());
      }).catchError((error) {
        if (kDebugMode) {
          print(error.toString());
        }
        emit(ErrorGetLikes());
      });
    }

  }

  List<SocialUserModel> users = [];

  void getAllUsers() {
    users =[];
    emit(LeadingGetAllUser());
      FirebaseFirestore.instance.collection('users').get().then((value) {
        for (var element in value.docs) {
          if (element['uid'] != userModel!.uid) {
            users.add(SocialUserModel.fromJson(element.data()));
          }
        }
        emit(SuccessGetAllUser());
      }).catchError((error) {
        if (kDebugMode) {
          print(error.toString());
        }
        emit(ErrorGetAllUser());
      });

  }



  void sendMessage({
    required String message,
    required String receiverId,
  }) {
    DateTime now = DateTime.now();
    String time = DateFormat.jm().format(now);
    emit(LeadingSendMessage());
    MessageModel model = MessageModel(
      dateTime: now,
        message: message,
        time: time,
        senderId: userModel!.uid,
        receiverId: receiverId,
    );

    /// my massage
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uid)
        .collection('Chats')
        .doc(receiverId)
        .collection('Messages')
        .add(model.toMap())
        .then((value) {
      emit(SuccessSendMessage());
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ErrorSendMessage());
    });

    /// receiver massage
    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('Chats')
        .doc(userModel!.uid)
        .collection('Messages')
        .add(model.toMap())
        .then((value) {
      emit(SuccessSendMessage());
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ErrorSendMessage());
    });
  }

  List<MessageModel> messages =[];

  Future<void> getMessages({required String receiverId }) async {
    messages =[];
    FirebaseFirestore.instance.collection('users')
        .doc(userModel!.uid)
        .collection('Chats')
        .doc(receiverId)
        .collection('Messages')
        .orderBy('datetime')
        .snapshots()
        .listen((event) async {
      messages =[];
      for (var element in event.docs) {
          messages.add(MessageModel.fromJson(element.data()));
        }
          emit(SuccessGetMessages());
    });
  }


  void togglePostVisibility(int index) {
    posts[index].showDetails = !posts[index].showDetails;
    emit(PostTextVisibilityChanged());
  }

  void changeReacts(int index ,interactedBefore ) {
    if(interactedBefore){
      posts[index].numberOfReacts -= 1;
    }else{
      posts[index].numberOfReacts += 1;
    }
    emit(ChangeLoveIcon());
  }


  bool showPost = false;
  void profileVisibilityChanged(){
    showPost = !showPost;
    emit(ProfileVisibilityChanged());
  }

}
