import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_social_app/screens/hello_screen.dart';
import 'package:simple_social_app/shared/sign_up_bloc/states.dart';
import '../../styles/colors.dart';
import 'package:toasty_snackbar/toasty_snackbar.dart';
import '../components/components.dart';
import '../main.dart';
import '../network/local/shared_prefrence.dart';
import 'login_screen.dart';
import '../shared/sign_up_bloc/cubit.dart';

class SignInScreen extends StatelessWidget {
  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController conformPassword = TextEditingController();
  final GlobalKey<FormState> form = GlobalKey<FormState>();

  SignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignUpCubit(),
      child: BlocConsumer<SignUpCubit, SignUpStates>(
        listener: (context, state) {
          if (state is ErrorSignUpState) {
            String inputText = state.error;
            String resultText =
                inputText.replaceAll(RegExp(r'\[.*?\]'), '').trim();

            context.showToastySnackbar('error', resultText, AlertType.error);
          } else if (state is SuccessSignUpState) {
            SharedHelper.saveData('Is Logged', true);
            SharedHelper.saveData('uid', state.uid).then(
              (value) {
                context.showToastySnackbar(
                    'Success', 'create account success', AlertType.success);
                navigateAndFinish(context, const MyApp());
              },
            );
          }
        },
        builder: (context, state) {
          var cubit = SignUpCubit.get(context);
          return WillPopScope(
            onWillPop: () async {
              navigateAndFinish(context, const HelloScreen());
              return false;
            },
            child: Scaffold(
              body: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// image
                    const Image(
                      image: AssetImage(
                        'assets/image/signup_login/sign_up.png',
                      ),
                      height: 180,
                    ),

                    /// textField and button
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
                                  /// name
                                  defTextFormField(
                                    validator: 'Name must be not empty',
                                    controller: name,
                                    hint: 'Enter your full name',
                                    leftIcon: Icons.person_outline_sharp,
                                  ),

                                  ///email
                                  defTextFormField(
                                    validator: 'Email must be not empty',
                                    controller: email,
                                    hint: 'Enter your email address',
                                    leftIcon: Icons.email_outlined,
                                    keyboard: TextInputType.emailAddress,
                                  ),

                                  /// password
                                  defTextFormField(
                                    maxLines: 1,

                                    onPressedIcon: () {
                                      cubit.changePassIcon();
                                    },
                                    isPassword: cubit.passIcon,
                                    validator: 'Password must be not empty',
                                    controller: password,
                                    hint: 'Enter password',
                                    leftIcon: Icons.lock_outline,
                                    rightIcon: cubit.passIcon
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    keyboard: TextInputType.visiblePassword,
                                  ),

                                  /// conform password
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 15),
                                    child: TextFormField(
                                      keyboardType: TextInputType.visiblePassword,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Conform password must be not empty';
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
                                          borderRadius:
                                              BorderRadius.circular(25.0),
                                        ),
                                        hintText: 'Enter conform password',
                                        prefixIcon:
                                            const Icon(Icons.lock_outline),
                                        suffixIcon: IconButton(
                                          onPressed: () {
                                            cubit.changeConformIcon();
                                          },
                                          icon: Icon(
                                            cubit.conformIcon
                                                ? Icons.visibility_off_outlined
                                                : Icons.visibility_outlined,
                                          ),
                                        ),
                                        filled: true,
                                        fillColor: secondColor,
                                      ),
                                    ),
                                  ),

                                  /// create account button
                                  Visibility(
                                    visible: state is! LeadingSignUpState,
                                    replacement: fallBack(),
                                    child: InkWell(
                                      onTap: () {
                                        if (form.currentState!.validate()) {
                                          cubit.signIn(email.text, password.text,
                                              name.text);
                                        }
                                      },
                                      child: Material(
                                        elevation: 15,
                                        shadowColor: defColor,
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(25),
                                        ),
                                        child: Container(
                                          height: 50,
                                          padding: const EdgeInsetsDirectional
                                              .symmetric(
                                            horizontal: 20,
                                          ),
                                          decoration: BoxDecoration(
                                            color: defColor,
                                            borderRadius:
                                                BorderRadius.circular(25),
                                          ),
                                          child: Row(
                                            children: const [
                                              Text(
                                                'Create Account',
                                                style: TextStyle(
                                                    color: secondColor,
                                                    fontSize: 15),
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

                                  /// log in
                                  FittedBox(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          'Already have a account?',
                                          style: TextStyle(
                                              color: secondColor,
                                              letterSpacing: 1,
                                              fontSize: 12,
                                              height: 2),
                                        ),
                                        MaterialButton(
                                          onPressed: () {
                                            navigateTo(
                                                context, SocialLoginScreen());
                                          },
                                          textColor: defColor,
                                          padding:
                                              const EdgeInsetsDirectional.only(
                                                  start: 5),
                                          minWidth: 1,
                                          child: const Text(
                                            'log in',
                                            style: TextStyle(
                                              decoration:
                                                  TextDecoration.underline,
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
                    )
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
