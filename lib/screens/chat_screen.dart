import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../components/components.dart';
import '../models/social_model/user_model.dart';
import '../shared/social_bloc/cubit.dart';
import '../shared/social_bloc/states.dart';
import '../styles/colors.dart';
import 'chat_details_screen.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView.separated(
                itemBuilder: (context, index) =>
                    chatItem(context, SocialCubit.get(context).users[index]),
                separatorBuilder: (context, index) => const SizedBox(
                      height: 10,
                    ),
                itemCount: SocialCubit.get(context).users.length),
          );
        });
  }

  Widget chatItem(context, SocialUserModel model) => InkWell(
        onTap: () {
          navigateTo(context, ChatDetailsScreen(model));
        },
        child: Container(
          padding: const EdgeInsetsDirectional.all(5),
          decoration: BoxDecoration(
            color: Colors.black,
            border: Border.all(color: defColor),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              /// image
              CircleAvatar(
                radius: 35,
                backgroundImage: CachedNetworkImageProvider(model.profile),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        model.name,
                        style: TextStyle(color: defColor, height: 1),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Icon(
                        Icons.arrow_forward_rounded,
                        color: defColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}
