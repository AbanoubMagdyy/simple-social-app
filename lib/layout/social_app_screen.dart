import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_social_app/network/local/shared_prefrence.dart';
import 'package:simple_social_app/screens/hello_screen.dart';
import '../components/components.dart';
import '../screens/add_post_screen.dart';
import '../shared/social_bloc/cubit.dart';
import '../shared/social_bloc/states.dart';
import '../styles/colors.dart';

class SocialHomeScreen extends StatelessWidget {
  const SocialHomeScreen({Key? key}) : super(key: key);
  static List<IconData> icons = [
    Icons.home_outlined,
    Icons.chat_outlined,
    Icons.person_outline,
    Icons.settings_sharp,
  ];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = SocialCubit.get(context);
        final pageController = PageController(initialPage: cubit.currantIndex);

        return FutureBuilder<bool>(
            future: isLogged(),
            builder: (context, AsyncSnapshot<bool> snapshot) {
              if (snapshot.hasData && snapshot.data!) {
                return Scaffold(
                  appBar: AppBar(
                    title: const Text(
                      'Media X',
                    ),
                  ),
                  floatingActionButton: FloatingActionButton(
                    backgroundColor: defColor,
                    onPressed: () {
                      navigateTo(context, AddPostScreen());
                    },
                    child: const Icon(
                      Icons.add,
                    ),
                  ),
                  floatingActionButtonLocation:
                      FloatingActionButtonLocation.centerDocked,
                  bottomNavigationBar: AnimatedBottomNavigationBar(
                    backgroundColor: defColor,
                    inactiveColor: secondColor,
                    gapLocation: GapLocation.center,
                    onTap: (int index) {
                      cubit.changeBNB(index);
                      pageController.animateToPage(cubit.currantIndex,
                          duration: const Duration(milliseconds: 1),
                          curve: Curves.ease);
                    },
                    activeIndex: cubit.currantIndex,
                    icons: icons,
                  ),
                  body: PageView(
                    controller: pageController,
                    children: cubit.screens,
                    onPageChanged: (int index) {
                      cubit.changeBNB(index);
                    },
                  ),
                  //other params
                );
              } else {
                return const HelloScreen();
              }
            },
        );
      },
    );
  }

  Future<bool> isLogged() async {
    return SharedHelper.getData('Is Logged') ?? false;
  }
}
