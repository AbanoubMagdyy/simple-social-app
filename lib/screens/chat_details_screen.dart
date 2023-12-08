import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../components/components.dart';
import '../models/social_model/massage_model.dart';
import '../models/social_model/user_model.dart';
import '../shared/social_bloc/cubit.dart';
import '../shared/social_bloc/states.dart';
import '../styles/colors.dart';

class ChatDetailsScreen extends StatelessWidget {
  final SocialUserModel userModel;
  final text = TextEditingController();
  final FocusNode focus = FocusNode();

  ChatDetailsScreen(this.userModel, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SocialCubit.get(context).getMessages(receiverId: userModel.uid);

    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = SocialCubit.get(context);
        List<DateTime> getUniqueDates() {
          return cubit.messages
              .map((message) => DateTime(message.dateTime.year,
                  message.dateTime.month, message.dateTime.day))
              .toSet()
              .toList();
        }

        List<MessageModel> getMessagesForDate(DateTime date) {
          return cubit.messages
              .where((message) =>
                  DateTime(message.dateTime.year, message.dateTime.month,
                      message.dateTime.day) ==
                  date)
              .toList();
        }

        List<DateTime> uniqueDates = getUniqueDates();
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
                      Expanded(
                          child: Text(
                        userModel.name,
                        style: const TextStyle(
                            color: secondColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      )),
                    ],
                  ),
                ),

                ///messages
                Visibility(
                  visible: cubit.messages.isNotEmpty,
                  replacement: Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                            color: defColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'Start messaging ${userModel.name}',
                            style: const TextStyle(color: secondColor),
                          ),
                        ),
                      ),
                    ),
                  ),
                  child: Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            if (index >= uniqueDates.length) {
                              return const SizedBox
                                  .shrink(); // Return an empty widget if index is out of bounds
                            }
                            DateTime date = uniqueDates[index];
                            List<MessageModel> messagesForDate =
                                getMessagesForDate(date);
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(5.0),
                                  decoration: BoxDecoration(
                                    color: defColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(formatDate(date),
                                      style: const TextStyle(
                                          fontSize: 16.0, color: secondColor)),
                                ),
                                if (messagesForDate.isNotEmpty)
                                  ...messagesForDate.map(
                                    (message) => Visibility(
                                      visible: SocialCubit.get(context)
                                              .userModel!
                                              .uid ==
                                          message.senderId,
                                      replacement: receiverMassage(message),
                                      child: myMassage(message),
                                    ),
                                  ),
                              ],
                            );
                          },
                          itemCount: SocialCubit.get(context).messages.length,
                        ),
                      ),
                    ),
                  ),
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
                                height: 60,
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
                                        Icons.emoji_emotions_outlined,
                                      ),
                                    ),

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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: CircleAvatar(
                                radius: 25,
                                backgroundColor: defColor,
                                child: IconButton(
                                  onPressed: () {
                                    SocialCubit.get(context).sendMessage(
                                        message: text.text,
                                        receiverId: userModel.uid);
                                    text.clear();
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
  }

  Widget myMassage(MessageModel model) => Padding(
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
            padding: const EdgeInsetsDirectional.all(5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    padding: const EdgeInsetsDirectional.all(8),
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.4),
                        borderRadius: BorderRadius.circular(8)),
                    child: Text(
                      model.message,
                      style: const TextStyle(color: secondColor),
                    )),
                Padding(
                  padding: const EdgeInsets.only(top: 2, left: 5),
                  child: Text(model.time,
                      style: TextStyle(
                        color: Colors.white.withOpacity(.4),
                      )),
                ),
              ],
            ),
          ),
        ),
      );

  Widget receiverMassage(MessageModel model) => Padding(
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
            padding: const EdgeInsetsDirectional.all(5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                    padding: const EdgeInsetsDirectional.all(8),
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.4),
                        borderRadius: BorderRadius.circular(8)),
                    child: Text(
                      model.message,
                      style: const TextStyle(color: secondColor),
                    )),
                Padding(
                  padding: const EdgeInsets.only(top: 2, left: 5),
                  child: Text(model.time,
                      style: TextStyle(
                        color: Colors.white.withOpacity(.4),
                      )),
                ),
              ],
            ),
          ),
        ),
      );

  String formatDate(DateTime date) {
    DateTime now = DateTime.now();
    var formattedDate = DateFormat('MMM d, yyyy').format(date);

    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return 'Today';
    } else if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day - 1) {
      return 'Yesterday';
    } else {
      return formattedDate;
    }
  }
}
