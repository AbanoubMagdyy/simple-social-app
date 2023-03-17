import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../components/components.dart';
import '../modules/add_post_screen.dart';
import '../shared/social_cubit/cubit.dart';
import '../shared/social_cubit/stares.dart';
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
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Media X',
              style: TextStyle(color: defColor),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: defColor,
            onPressed: () {
              navigateTo(context, const AddPostScreen());
            },
            child: const Icon(
              Icons.add,
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: AnimatedBottomNavigationBar(
            backgroundColor: defColor,
            inactiveColor: Colors.white,
            gapLocation: GapLocation.center,
            onTap: (int index) {
              cubit.changeBNB(index);
            },
            activeIndex: cubit.currantIndex,
            icons: icons,
          ),
          body: cubit.screens[cubit.currantIndex],
          //other params
        );
      },
    );
  }
}
