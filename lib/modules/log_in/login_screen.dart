import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_social_app/modules/log_in/states.dart';
import 'package:toasty_snackbar/toasty_snackbar.dart';
import '../../../layout/social_app_screen.dart';
import '../../../styles/colors.dart';
import '../../components/components.dart';
import '../../network/local/shared_prefrence.dart';
import '../sign_in/sign_in_screen.dart';
import 'cubit.dart';

class SocialLoginScreen extends StatelessWidget {
  SocialLoginScreen({Key? key}) : super(key: key);
  static TextEditingController email = TextEditingController();
  static TextEditingController password = TextEditingController();
  GlobalKey<FormState> form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SocialLogInCubit(),
      child: BlocConsumer<SocialLogInCubit, SocialLogiInStates>(
        listener: (context, state) {
          if (state is ErrorSocialLogiInState) {
            context.showToastySnackbar('error', state.error, AlertType.error);
          } else if (state is SuccessSocialLogiInState) {
            SharedHelper.saveData('uid', state.uid).then((value) {
              context.showToastySnackbar(
                  'Success', 'login success', AlertType.success);
              navigateAndFinish(context, const SocialHomeScreen());
            });
          }
        },
        builder: (context, state) {
          var cubit = SocialLogInCubit.get(context);
          return Scaffold(
            body: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  const Image(
                    image: AssetImage(
                      'assets/image/signin_login/1.png',
                    ),
                    height: 250,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Form(
                        key: form,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            defTextFormField(
                                validator: 'email must be not empty',
                                controller: email,
                                keyboard: TextInputType.emailAddress,
                                hint: 'Enter your mail',
                                leftIcon: Icons.email_outlined),
                            const SizedBox(
                              height: 15,
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
                                keyboard: TextInputType.visiblePassword),
                            const SizedBox(
                              height: 15,
                            ),
                            ConditionalBuilder(
                              condition: state is! LeadingSocialLogiInState,
                              builder: (context) => defContainer(
                                  onTap: () {
                                    if (form.currentState!.validate()) {
                                      cubit.logIn(email.text, password.text);
                                    }
                                  },
                                  icon: false,
                                  text: 'Log in',
                                  isRightIcon: true),
                              fallback: (context) => Center(
                                child: CircularProgressIndicator(
                                  color: defColor,
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              textBaseline: TextBaseline.alphabetic,
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              children: [
                                const Text(
                                  'Don\'t have an account?',
                                  style: TextStyle(
                                      color: Colors.white,
                                      letterSpacing: 1,
                                      fontSize: 12,
                                      height: 2),
                                ),
                                MaterialButton(
                                  onPressed: () {
                                    navigateTo(context, SignInScreen());
                                  },
                                  textColor: defColor,
                                  padding: EdgeInsetsDirectional.zero,
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
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
