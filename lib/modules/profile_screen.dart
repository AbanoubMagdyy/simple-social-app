import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../shared/social_cubit/cubit.dart';
import '../shared/social_cubit/stares.dart';
import '../styles/colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var model = SocialCubit.get(context).userModel;
          return Stack(
            alignment: Alignment.bottomRight,
            children: [
              /// profile  background
              Container(
                height: double.infinity,
                decoration: BoxDecoration(
                    image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(model!.profile),
                )),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 2.2,
                  ),
                  child: Container(
                    decoration:
                        BoxDecoration(color: Colors.white.withOpacity(0.0)),
                  ),
                ),
              ),

              /// information
              Stack(
                alignment: Alignment.topCenter,
                children: [
                  ///body
                  Padding(
                    padding: const EdgeInsets.only(top: 120),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      height: double.infinity,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                          color: Colors.black,
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(20))),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 50,
                          ),

                          ///name
                          Text(
                            model.name,
                            style: TextStyle(
                                color: defColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                          const SizedBox(height: 15),

                          ///bio
                          Text(
                            model.bio,
                            style: TextStyle(
                                color: defColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                          const SizedBox(height: 15),

                          /// information about me
                          Row(
                            children: [
                              /// posts
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      '700 ',
                                      style: TextStyle(
                                          color: defColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      'Posts ',
                                      style: TextStyle(
                                          color: defColor.withOpacity(0.4),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 1,
                                height: 40,
                                color: defColor.withOpacity(0.4),
                              ),

                              ///followers
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      '700 ',
                                      style: TextStyle(
                                          color: defColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      'Followers ',
                                      style: TextStyle(
                                          color: defColor.withOpacity(0.4),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 1,
                                height: 40,
                                color: defColor.withOpacity(0.4),
                              ),

                              ///following
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      '700 ',
                                      style: TextStyle(
                                          color: defColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      'Following ',
                                      style: TextStyle(
                                          color: defColor.withOpacity(0.4),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  /// image profile
                  Padding(
                    padding: const EdgeInsets.only(top: 70),
                    child: CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(model.profile),
                    ),
                  )
                ],
              )
            ],
          );
        });
  }
}
