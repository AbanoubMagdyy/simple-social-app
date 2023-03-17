import 'package:flutter/material.dart';
import 'package:simple_social_app/modules/sign_in/sign_in_screen.dart';
import '../../styles/colors.dart';
import '../components/components.dart';
import 'log_in/login_screen.dart';

class HelloScreen extends StatelessWidget {
  const HelloScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            /// logo and title
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Image(
                    image: AssetImage('assets/image/social.png'),
                    height: 150,
                    alignment: Alignment.bottomCenter,
                  ),
                  Text(
                    'SOCIAL',
                    style: TextStyle(
                        color: defColor,
                        letterSpacing: 5,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'APP',
                    style: TextStyle(
                        color: defColor, fontSize: 20, letterSpacing: 10),
                  ),
                ],
              ),
            ),
            ///sign up
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'SIGN UP',
                    style: TextStyle(
                        color: Colors.white,
                        letterSpacing: 5,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'it\'s easier to sign up now',
                    style: TextStyle(
                        color: Colors.white,
                        letterSpacing: 3,
                        fontSize: 12,
                        height: 2),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  /// Continue with Facebook
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: defContainer(
                        onTap: () {},
                        text: 'Continue with Facebook',
                        icon: true,
                        isRightIcon: false),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  /// continue with email
                  InkWell(
                    onTap: () {
                      navigateTo(context, SignInScreen());
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 80),
                      child: Container(
                        height: 40,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.black,
                            boxShadow: const [
                              BoxShadow(spreadRadius: 2, color: Colors.white)
                            ],
                            borderRadius: BorderRadius.circular(50)),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Center(
                            child: Text(
                              'i\'ll use email or phone',
                              style: TextStyle(color: Colors.white, fontSize: 15),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  ///icons
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        CircleAvatar(
                          radius: 15,
                          backgroundImage: AssetImage('assets/image/twitter.png'),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.black,
                          backgroundImage:
                              AssetImage('assets/image/googleplus.png'),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        CircleAvatar(
                          radius: 15,
                          backgroundImage: AssetImage('assets/image/linkedin.png'),
                        ),
                      ],
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
                          'Login',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
