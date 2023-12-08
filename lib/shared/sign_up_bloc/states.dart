abstract class SignUpStates {}

class SignUpInitialState extends SignUpStates {}

class ChangeIcon extends SignUpStates {}

class LeadingSignUpState extends SignUpStates {}

class SuccessSignUpState extends SignUpStates {
  String uid;

  SuccessSignUpState(this.uid);
}

class ErrorSignUpState extends SignUpStates {
  String error;

  ErrorSignUpState(this.error);
}

class SuccessCreateUserState extends SignUpStates {}

class ErrorCreateUserState extends SignUpStates {}
