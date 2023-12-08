import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toasty_snackbar/toasty_snackbar.dart';
import '../../styles/colors.dart';
import '../components/components.dart';
import '../main.dart';
import '../network/local/shared_prefrence.dart';
import '../shared/login_bloc/cubit.dart';
import '../shared/login_bloc/states.dart';
import 'hello_screen.dart';
import 'sign_up_screen.dart';

class SocialLoginScreen extends StatelessWidget {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final  GlobalKey<FormState> form = GlobalKey<FormState>();
  SocialLoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SocialLogInCubit(),
      child: BlocConsumer<SocialLogInCubit, SocialLogiInStates>(
        listener: (context, state) {
          if (state is ErrorSocialLogiInState) {

            String inputText = state.error;
            String resultText = inputText.replaceAll(RegExp(r'\[.*?\]'), '').trim();

            context.showToastySnackbar('error', resultText, AlertType.error);

          } else if (state is SuccessSocialLogiInState) {
            SharedHelper.saveData('Is Logged', true);
            SharedHelper.saveData('uid', state.uid).then((value) {
              context.showToastySnackbar(
                  'Success', 'login success', AlertType.success);
              navigateAndFinish(context, const MyApp());
            },
            );
          }
        },
        builder: (context, state) {
          var cubit = SocialLogInCubit.get(context);
          return Scaffold(
            body: WillPopScope(
              onWillPop: () async {
                navigateAndFinish(context, const HelloScreen());
                return false;
              },
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// image
                    const Image(
                      image: AssetImage(
                        'assets/image/signup_login/log_in.png',
                      ),
                      height: 180,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Form(
                          key: form,
                          child: Center(
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  defTextFormField(
                                      validator: 'email must be not empty',
                                      controller: email,
                                      keyboard: TextInputType.emailAddress,
                                      hint: 'Enter your email',
                                      leftIcon: Icons.email_outlined,
                                  ),
                                  defTextFormField(
                                      onPressedIcon: () {
                                        cubit.changePassIcon();
                                      },
                                      isPassword: cubit.password,
                                      validator: 'password must be not empty',
                                      controller: password,
                                      hint: 'Enter password',
                                      leftIcon: Icons.lock_outline,
                                      rightIcon: cubit.rightIcon,
                                      keyboard: TextInputType.visiblePassword,
                                  maxLines: 1,
                                  ),

                                  Visibility(
                                    visible: state is! LeadingSocialLogiInState,
                                    replacement: fallBack(),
                                    child: InkWell(
                                            onTap: () {
                                              if (form.currentState!.validate()) {
                                                cubit.logIn(email.text, password.text);
                                              }
                                            },
                                      child: Material(
                                        elevation: 15,
                                        shadowColor: defColor,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(50),
                                        ),
                                        child: Container(
                                          height: 50,
                                          padding:
                                          const EdgeInsetsDirectional.symmetric(
                                              horizontal: 20,
                                          ),
                                          decoration: BoxDecoration(
                                              color: defColor,
                                              borderRadius:
                                              BorderRadius.circular(50),
                                          ),
                                          child: Row(
                                            children: const [
                                              Text(
                                                'Log in',
                                                style: TextStyle(
                                                    color: secondColor,
                                                    fontSize: 15,
                                                ),
                                              ),
                                              Spacer(),
                                              Icon(
                                                Icons.arrow_forward_rounded,
                                                color: secondColor,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  FittedBox(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      textBaseline: TextBaseline.alphabetic,
                                      crossAxisAlignment: CrossAxisAlignment.baseline,
                                      children: [
                                        const Text(
                                          'Don\'t have an account?',
                                          style: TextStyle(
                                              color: secondColor,
                                              letterSpacing: 1,
                                              fontSize: 12,
                                              height: 2,
                                          ),
                                        ),
                                        MaterialButton(
                                          onPressed: () {
                                            navigateTo(context, SignInScreen());
                                          },
                                          textColor: defColor,
                                          padding: const EdgeInsetsDirectional.only(start: 5),
                                          minWidth: 1,
                                          child: const Text(
                                            'Create Account',
                                            style: TextStyle(
                                              decoration: TextDecoration.underline,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
