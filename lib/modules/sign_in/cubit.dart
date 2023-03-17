import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_social_app/modules/sign_in/states.dart';
import '../../../models/social_model/user_model.dart';
import '../../components/constants.dart';

class SignInCubit extends Cubit<SignInStates> {
  SignInCubit() : super(SignInInitialState());

  static SignInCubit get(context) => BlocProvider.of(context);

  bool passIcon = true;
  bool conformIcon = true;
  IconData rightIcon = Icons.visibility_off_outlined;
  IconData conformRightIcon = Icons.visibility_off_outlined;

  void changePassIcon() {
    passIcon = !passIcon;
    rightIcon = passIcon ? Icons.visibility_off_outlined : Icons.visibility;
    emit(ChangeIcon());
  }

  void changeConformIcon() {
    conformIcon = !conformIcon;
    conformRightIcon =
        conformIcon ? Icons.visibility_off_outlined : Icons.visibility;
    emit(ChangeIcon());
  }

  void signIn(
    String email,
    String password,
    String name,
  ) {
    emit(LeadingSignInState());
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      id = value.user!.uid;
      createUser(
          id: value.user!.uid, password: password, email: email, name: name);
      emit(SuccessSignInState(value.user!.uid));
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ErrorSignInState(error.toString()));
    });
  }

  void createUser({
    required String id,
    required String password,
    required String email,
    required String name,
  }) {
    SocialUserModel model = SocialUserModel(
        uid: id,
        password: password,
        bio: 'Hello I\'m a  new here',
        email: email,
        name: name,
        profile:
            'https://img.freepik.com/free-psd/3d-illustration-person-with-sunglasses_23-2149436188.jpg?w=740&t=st=1674759542~exp=1674760142~hmac=0ea42f6fd4e37608d55a192a1e225aba679356dd84eb687035ae48d56d0e8b69',
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .set(model.toMap())
        .then((value) {
      emit(SuccessCreateUserState());
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ErrorCreateUserState());
    });
  }



}
