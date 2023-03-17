import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:simple_social_app/modules/sign_in/states.dart';
import '../../../styles/colors.dart';
import 'package:toasty_snackbar/toasty_snackbar.dart';
import '../../components/components.dart';
import '../../layout/social_app_screen.dart';
import '../../network/local/shared_prefrence.dart';
import '../log_in/login_screen.dart';
import 'cubit.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({Key? key}) : super(key: key);
  static TextEditingController name = TextEditingController();
  static TextEditingController email = TextEditingController();
  static TextEditingController password = TextEditingController();
  static TextEditingController conformPassword = TextEditingController();
  GlobalKey<FormState> form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignInCubit(),
      child: BlocConsumer<SignInCubit, SignInStates>(
        listener: (context, state) {
          if (state is ErrorSignInState) {
            context.showToastySnackbar('error', state.error, AlertType.error);
          } else if (state is SuccessSignInState) {
            SharedHelper.saveData('uid', state.uid).then((value) {
              context.showToastySnackbar(
                  'Success', 'create account success', AlertType.success);
              navigateAndFinish(context, const SocialHomeScreen());
            });
          }
        },
        builder: (context, state) {
          var cubit = SignInCubit.get(context);
          return Scaffold(
            body: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// image
                  const Image(
                    image: AssetImage(
                      'assets/image/signin_login/2.png',
                    ),
                    height: 200,
                  ),
                  /// textField and button
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Form(
                        key: form,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            /// name
                            defTextFormField(
                                validator: 'name must be not empty',
                                controller: name,
                                hint: 'Enter your full name',
                                leftIcon: Icons.person_outline_sharp),
                            ///email
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              child: defTextFormField(
                                  validator: 'email must be not empty',
                                  controller: email,
                                  hint: 'Enter your email address',
                                  leftIcon: Icons.email_outlined,
                                  keyboard: TextInputType.emailAddress),
                            ),
                            /// password
                            Padding(
                              padding: const EdgeInsets.only(bottom: 15),
                              child: defTextFormField(
                                  onPressedIcon: () {
                                    cubit.changePassIcon();
                                  },
                                  isPassword: cubit.passIcon,
                                  validator: 'password must be not empty',
                                  controller: password,
                                  hint: 'Enter password',
                                  leftIcon: Icons.lock_outline,
                                  rightIcon: cubit.rightIcon,
                                  keyboard: TextInputType.visiblePassword),
                            ),
                            /// conform password
                            Padding(
                              padding: const EdgeInsets.only(bottom: 15),
                              child: TextFormField(
                                keyboardType: TextInputType.visiblePassword,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'conformPassword must be not empty';
                                  } else if (password.text !=
                                      conformPassword.text) {
                                    return 'Is not equal the password';
                                  }
                                  return null;
                                },
                                obscureText: cubit.conformIcon,
                                controller: conformPassword,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25.0),
                                    ),
                                    hintText: 'Enter conform password',
                                    prefixIcon: const Icon(Icons.lock_outline),
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        cubit.changeConformIcon();
                                      },
                                      icon: Icon(cubit.conformRightIcon),
                                    ),
                                    filled: true,
                                    fillColor: HexColor('#fbfbfb')),
                              ),
                            ),
                            ConditionalBuilder(
                              condition: state is! LeadingSignInState,
                              builder: (context) => defContainer(
                                  onTap: () {
                                    if (form.currentState!.validate()) {
                                      cubit.signIn(
                                          email.text, password.text, name.text);
                                    }
                                  },
                                  icon: false,
                                  text: 'Create Account',
                                  isRightIcon: true),
                              fallback: (context) => Center(
                                child: CircularProgressIndicator(
                                  color: defColor,
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Already have a account?',
                                  style: TextStyle(
                                      color: Colors.white,
                                      letterSpacing: 1,
                                      fontSize: 12,
                                      height: 2),
                                ),
                                MaterialButton(
                                  onPressed: () {
                                    navigateTo(context, SocialLoginScreen());
                                  },
                                  textColor: defColor,
                                  padding: EdgeInsetsDirectional.zero,
                                  minWidth: 1,
                                  child: const Text(
                                    'log in',
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
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
