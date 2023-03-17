import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_social_app/modules/log_in/states.dart';

import '../../components/constants.dart';

class SocialLogInCubit extends Cubit<SocialLogiInStates> {
  SocialLogInCubit() : super(SocialLogiInInitialState());

  static SocialLogInCubit get(context) => BlocProvider.of(context);

  bool password = true;
  IconData rightIcon = Icons.visibility_off_outlined;

  void changePassIcon() {
    password = !password;
    rightIcon = password ? Icons.visibility_off_outlined : Icons.visibility;
    emit(SocialChangeIcon());
  }

  void logIn(
    String email,
    String password,
  ) {
    emit(LeadingSocialLogiInState());
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      id = value.user!.uid;
      emit(SuccessSocialLogiInState(value.user!.uid));
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ErrorSocialLogiInState(error.toString()));
    });
  }
}
