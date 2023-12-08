import 'package:flutter/material.dart';
import 'package:simple_social_app/screens/sign_up_screen.dart';
import '../../styles/colors.dart';
import '../components/components.dart';
import 'login_screen.dart';

class HelloScreen extends StatelessWidget {
  final int requiredHeight = 750;
  const HelloScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final heightScreenSize = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            if(requiredHeight < heightScreenSize)
            /// logo and title
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /// logo
                  const Image(
                    image: AssetImage('assets/image/x icon.png'),
                    height: 150,
                    fit: BoxFit.contain,
                  ),
                  /// title
                  Text(
                    'Media X\n   APP',
                    style: TextStyle(
                        color: defColor,
                        letterSpacing: 5,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ///sign up and buttons
            Expanded(
              flex: 2,
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      /// sign up
                      const Text(
                        'SIGN UP',
                        style: TextStyle(
                            color: secondColor,
                            letterSpacing: 5,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'it\'s easier to sign up now',
                        style: TextStyle(
                            color: secondColor,
                            letterSpacing: 3,
                            fontSize: 12,
                            height: 2,
                        ),
                      ),
                      /// Continue with Facebook
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 25),
                        child: defContainer(
                            onTap: () {},
                            text: 'Continue with Facebook',
                            icon: true,
                            isRightIcon: false,
                        ),
                      ),
                      /// continue with email
                      InkWell(
                        onTap: () {
                          navigateTo(context, SignInScreen());
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 60),
                          height: 40,
                          decoration: BoxDecoration(
                              color: Colors.black,
                              boxShadow: const [
                                BoxShadow(spreadRadius: 2, color: secondColor)
                              ],
                              borderRadius: BorderRadius.circular(50),
                          ),
                          child: const Center(
                            child: FittedBox(
                              child: Text(
                                'i\'ll use email or phone',
                                style: TextStyle(color: secondColor, fontSize: 15),
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
                          children:  [
                            icon('assets/image/social_media/googleplus.png'),
                            icon('assets/image/social_media/linkedin.png'),
                            icon('assets/image/social_media/twitter x.png'),
                          ],
                        ),
                      ),
                      FittedBox(
                        child: Row(
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
  }



  Widget icon(image)=>Padding(
    padding: const EdgeInsets.only(left: 15),
    child: CircleAvatar(
      radius: 25,
      backgroundImage: AssetImage(image),
    ),
  );
}
