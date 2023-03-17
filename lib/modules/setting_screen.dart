import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../styles/colors.dart';
import '../components/components.dart';
import '../components/constants.dart';
import '../shared/social_cubit/cubit.dart';
import '../shared/social_cubit/stares.dart';
import 'edit_screen.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({Key? key}) : super(key: key);

  static var email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  /// image
                  CircleAvatar(
                    radius: 55,
                    backgroundImage: NetworkImage(
                        SocialCubit.get(context).userModel!.profile),
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  /// edit
                  item(
                      onTap: () {
                        navigateTo(context, const EditScreen());
                      },
                      icon: Icons.edit,
                      text: 'Edit Profile'),
                  const SizedBox(
                    height: 15,
                  ),

                  /// log out
                  item(
                      onTap: () {
                        submit(context);
                      },
                      icon: Icons.login_outlined,
                      text: 'Log out')
                ],
              ),
            ),
          );
        });
  }

  Widget item({
    required Function() onTap,
    required IconData icon,
    required String text,
  }) =>
      InkWell(
        onTap: onTap,
        highlightColor: defColor.withOpacity(.8),
        splashColor: defColor,
        child: SizedBox(
          height: 50,
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: defColor,
                child: Icon(icon),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                text,
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 17, color: defColor),
              )
            ],
          ),
        ),
      );
}
