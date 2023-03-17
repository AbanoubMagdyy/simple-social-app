abstract class SocialLogiInStates{}

class SocialLogiInInitialState extends SocialLogiInStates{}

class SocialChangeIcon extends SocialLogiInStates{}

class LeadingSocialLogiInState extends SocialLogiInStates{}
class SuccessSocialLogiInState extends SocialLogiInStates{
  String uid;
  SuccessSocialLogiInState(this.uid);
}
class ErrorSocialLogiInState extends SocialLogiInStates{
  String error;
  ErrorSocialLogiInState(this.error);
}
