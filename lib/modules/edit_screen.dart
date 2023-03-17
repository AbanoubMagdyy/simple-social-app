import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../components/components.dart';
import '../shared/social_cubit/cubit.dart';
import '../shared/social_cubit/stares.dart';
import '../styles/colors.dart';

class EditScreen extends StatelessWidget {
  const EditScreen({Key? key}) : super(key: key);

  static var bio = TextEditingController();
  static var name = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var userModel = SocialCubit.get(context).userModel;
          var profile = SocialCubit.get(context).profileImage;
          name.text = userModel!.name;
          bio.text = userModel.bio;
          return Scaffold(
            appBar: AppBar(
                title: Text(
                  'Back',
                  style: TextStyle(color: defColor),
                ),
                titleSpacing: 0,
                leading: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: defColor,
                    ))),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    /// image
                    Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        Container(
                          height: 170,
                          width: double.infinity,
                          color: Colors.grey.withOpacity(0.5),
                          padding: const EdgeInsetsDirectional.all(10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    SocialCubit.get(context).getImage();
                                  },
                                  icon: const Icon(
                                    Icons.photo,
                                    size: 30,
                                  )),
                              const Spacer(),
                              if (profile != null)
                                TextButton(
                                    onPressed: () {
                                      SocialCubit.get(context)
                                          .uploadProfileImage(
                                              name: name.text, bio: bio.text);
                                    },
                                    child: const Text(
                                      'Edit',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 20),
                                    )),
                            ],
                          ),
                        ),

                        /// image
                        CircleAvatar(
                          radius: 60,
                          backgroundImage: profile == null
                              ? NetworkImage(userModel.profile)
                              : FileImage(profile) as ImageProvider,
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),

                    ///name
                    TextFormField(
                      controller: name,
                      style: TextStyle(color: defColor),
                      decoration: InputDecoration(
                          labelText: 'Name',
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 3, color: defColor),
                              borderRadius: BorderRadius.circular(10)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(width: 3, color: defColor),
                          )),
                    ),
                    const SizedBox(
                      height: 20,
                    ),

                    ///bio
                    TextFormField(
                      controller: bio,
                      style: TextStyle(color: defColor),
                      decoration: InputDecoration(
                          labelText: 'Bio',
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 3, color: defColor),
                              borderRadius: BorderRadius.circular(10)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(width: 3, color: defColor),
                          )),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    defContainer(
                        onTap: () {
                          SocialCubit.get(context)
                              .updateUser(name: name.text, bio: bio.text);
                        },
                        icon: false,
                        isRightIcon: false,
                        text: 'UpData')
                  ],
                ),
              ),
            ),
          );
        });
  }
}
