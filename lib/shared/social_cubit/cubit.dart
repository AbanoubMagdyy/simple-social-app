import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:simple_social_app/shared/social_cubit/stares.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../../components/constants.dart';
import '../../models/social_model/massage_model.dart';
import '../../models/social_model/post_model.dart';
import '../../models/social_model/user_model.dart';
import '../../modules/Feeds_screen.dart';
import '../../modules/chat_screen.dart';
import '../../modules/profile_screen.dart';
import '../../modules/setting_screen.dart';


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
    if (index == 1) {
      getAllUsers();
    }
    emit(ChangeBNB());
  }

  SocialUserModel? userModel;

  void getUserData() {
    emit(LeadingGetUserData());
    FirebaseFirestore.instance.collection('users').doc(id).get().then((value) {
      userModel = SocialUserModel.fromJson(value.data()!);
      emit(SuccessGetUserData());
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ErrorGetUserData());
    });
  }

  bool emoji = true;

  void changeEmoji() {
    emoji = !emoji;
    emit(ChangeEmoji());
  }

  File? profileImage;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      emit(SuccessImage());
    } else {
      if (kDebugMode) {
        print('No image selected.');
      }
      emit(ErrorImage());
    }
  }

  void uploadProfileImage({
    required String name,
    required String bio,
  }) {
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(profileImage!.path).pathSegments.last}')
        .putFile(profileImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        updateUser(name: name, bio: bio, profile: value);
        emit(SuccessUploadProfile());
      }).catchError((error) {
        if (kDebugMode) {
          print(error.toString());
        }
        emit(ErrorUploadProfile());
      });
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ErrorUploadProfile());
    });
  }

  void updateUser({
    required String name,
    required String bio,
    String? profile,
  }) {
    SocialUserModel model = SocialUserModel(
        uid: userModel!.uid,
        password: userModel!.password,
        email: userModel!.email,
        name: name,
        profile: profile ?? userModel!.profile,
        bio: bio);
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uid)
        .update(model.toMap())
        .then((value) {
      getUserData();
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ErrorUpdateUserData());
    });
  }

  File? postImage;

  Future getPostImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      postImage = File(pickedFile.path);
      emit(SuccessImage());
    } else {
      if (kDebugMode) {
        print('No image selected.');
      }
      emit(ErrorImage());
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
        uid: userModel!.uid,
        datetime: dateTime,
        imagePost: imagePost ?? '',
        name: userModel!.name,
        imageProfile: userModel!.profile,
        textPost: textPost);
    FirebaseFirestore.instance
        .collection('Posts')
        .add(model.toMap())
        .then((value) {
      emit(SuccessCreatePost());
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ErrorCreatePost());
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
  List<String> postsId = [];
  List<int> likes = [];

  void getPosts() {
    emit(LeadingGetPosts());
    FirebaseFirestore.instance.collection('Posts').get().then((value) {
      value.docs.forEach((element) {
        element.reference.collection('likes')
            .orderBy('datetime')
            .get().then((value) {
          likes.add(value.docs.length);
          postsId.add(element.id);
          posts.add(PostModel.fromJson(element.data()));
        }).catchError((error) {});
      });
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ErrorGetPosts());
    });
  }

  void likePost(String postId) {
    FirebaseFirestore.instance
        .collection('Posts')
        .doc(postId)
        .collection('likes')
        .doc(userModel!.uid)
        .set({'like': true}).then((value) {
      emit(SuccessGetLikes());
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ErrorGetLikes());
    });
  }

  List<SocialUserModel> users = [];

  void getAllUsers() {
    emit(LeadingGetAllUser());
    if (users.isEmpty) {
      FirebaseFirestore.instance.collection('users').get().then((value) {
        value.docs.forEach((element) {
          if (element.data()['uid'] != userModel!.uid) {
            users.add(SocialUserModel.fromJson(element.data()));
          }
        });
        emit(SuccessGetAllUser());
      }).catchError((error) {
        if (kDebugMode) {
          print(error.toString());
        }
        emit(ErrorGetAllUser());
      });
    }
  }

  void sendMassage({
    required String massage,
    required String datetime,
    required String receiverId,
  }) {
    emit(LeadingSendMassage());
    MassageModel model = MassageModel(
        massage: massage,
        datetime: datetime,
        senderId: userModel!.uid,
        receiverId: receiverId);

    /// my massage
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uid)
        .collection('chats')
        .doc(receiverId)
        .collection('massages')
        .add(model.toMap())
        .then((value) {
      emit(SuccessSendMassage());
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ErrorSendMassage());
    });

    /// receiver massage
    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(userModel!.uid)
        .collection('massages')
        .add(model.toMap())
        .then((value) {
      emit(SuccessSendMassage());
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ErrorSendMassage());
    });
  }



  List<MassageModel> massages =[];

  void getMassages({required String receiverId }){
    FirebaseFirestore.instance.collection('users')
        .doc(userModel!.uid)
        .collection('chats')
        .doc(receiverId)
        .collection('massages')
        .orderBy('datetime')
        .snapshots()
        .listen((event) {
          massages =[];
        event.docs.forEach((element) {
          massages.add(MassageModel.fromJson(element.data()));
        });
        emit(SuccessGetMassages());
    });
  }
}
