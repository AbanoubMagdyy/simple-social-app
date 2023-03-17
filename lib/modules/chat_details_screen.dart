import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../components/components.dart';
import '../models/social_model/massage_model.dart';
import '../models/social_model/user_model.dart';
import '../shared/social_cubit/cubit.dart';
import '../shared/social_cubit/stares.dart';
import '../styles/colors.dart';

/// error

class ChatDetailsScreen extends StatelessWidget {
  ChatDetailsScreen(this.userModel, {Key? key}) : super(key: key);
  static var text = TextEditingController();
  static FocusNode focus = FocusNode();

  SocialUserModel userModel;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        SocialCubit.get(context).getMassages(receiverId: userModel.uid);
        return BlocConsumer<SocialCubit, SocialStates>(
          listener: (context, state) {},
          builder: (context, state) {
            var cubit = SocialCubit.get(context);
            return Scaffold(
              backgroundColor: defColor,
              body: SafeArea(
                child: Column(
                  children: [
                    ///information
                    Container(
                      color: defColor,
                      height: 90,
                      width: double.infinity,
                      child: Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(Icons.arrow_back)),

                          /// image
                          CircleAvatar(
                            radius: 25,
                            backgroundImage: NetworkImage(userModel.profile),
                          ),
                          const SizedBox(
                            width: 10,
                          ),

                          ///name
                          Expanded(child: Text(userModel.name)),
                        ],
                      ),
                    ),

                    ///my message
                    Expanded(
                      child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.black,
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListView.separated(
                              itemBuilder: (context, index) {
                                var massage =
                                    SocialCubit.get(context).massages[index];
                                if (SocialCubit.get(context).userModel!.uid ==
                                    massage.senderId) {
                                  return myMassage(massage);
                                } else {
                                  return receiverMassage(massage);
                                }
                              },
                              separatorBuilder: (context, index) =>
                                  const SizedBox(
                                height: 5,
                              ),
                              itemCount:
                                  SocialCubit.get(context).massages.length,
                            ),
                          )),
                    ),

                    ///textField and emoji icon
                    Container(
                      color: Colors.black,
                      width: double.infinity,
                      child: Column(
                        children: [
                          ///textField and emoji icon
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Row(
                                      children: [
                                        /// emoji icon
                                        IconButton(
                                            onPressed: () {
                                              cubit.changeEmoji();
                                              focus.unfocus();
                                              focus.canRequestFocus = false;
                                            },
                                            icon: const Icon(
                                                Icons.emoji_emotions_outlined)),

                                        ///textField
                                        Expanded(
                                          child: TextFormField(
                                            focusNode: focus,
                                            controller: text,
                                            onTap: () {
                                              if (cubit.emoji == false) {
                                                cubit.changeEmoji();
                                              }
                                            },
                                            decoration: const InputDecoration(
                                              border: OutlineInputBorder(
                                                borderSide: BorderSide.none,
                                              ),
                                              hintText: 'Type your message...',
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                /// send icon
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: CircleAvatar(
                                    radius: 25,
                                    backgroundColor: defColor,
                                    child: IconButton(
                                      onPressed: () {
                                        SocialCubit.get(context).sendMassage(
                                            massage: text.text,
                                            datetime: DateTime.now().toString(),
                                            receiverId: userModel.uid);
                                      },
                                      icon: const Icon(
                                        Icons.send_outlined,
                                        size: 25,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),

                          /// emoji
                          Offstage(
                            offstage: cubit.emoji,
                            child: SizedBox(
                              height: 400,
                              child: emoji(text),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget myMassage(MassageModel model) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Align(
          alignment: Alignment.topLeft,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(5),
                topLeft: Radius.circular(5),
                bottomRight: Radius.circular(5),
              ),
            ),
            padding: const EdgeInsetsDirectional.all(7),
            child: Text(model.massage),
          ),
        ),
      );

  Widget receiverMassage(MassageModel model) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Align(
          alignment: Alignment.topRight,
          child: Container(
            decoration: BoxDecoration(
              color: defColor,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(5),
                topLeft: Radius.circular(5),
                bottomLeft: Radius.circular(5),
              ),
            ),
            padding: const EdgeInsetsDirectional.all(7),
            child: Text(model.massage),
          ),
        ),
      );
}
