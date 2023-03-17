abstract class SignInStates{}

class SignInInitialState extends SignInStates{}

class ChangeIcon extends SignInStates{}

class LeadingSignInState extends SignInStates{}
class SuccessSignInState extends SignInStates{
  String uid;
  SuccessSignInState(this.uid);
}
class ErrorSignInState extends SignInStates{
    String error;
  ErrorSignInState(this.error);
}


class SuccessCreateUserState extends SignInStates{
}
class ErrorCreateUserState extends SignInStates{
}