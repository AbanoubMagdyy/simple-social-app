import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../components/components.dart';
import '../shared/social_bloc/cubit.dart';
import '../shared/social_bloc/states.dart';
import '../styles/colors.dart';

class EditScreen extends StatelessWidget {
  final double requiredWidth = 250;
 final bio = TextEditingController();
 final name = TextEditingController();
   EditScreen({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = SocialCubit.get(context);
          var profileImage = cubit.profileImage;
          var userModel = cubit.userModel;
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
                    ),),
            actions: [
              if(state is LeadingUpdateUserData)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: fallBack(),
              )
            ],
            ),
            body: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  final double availableWidth = constraints.maxWidth;
                  double radius = constraints.maxWidth / 4;
                return Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          /// image
                          Stack(
                            alignment: AlignmentDirectional.topEnd,
                            children: [
                              if (profileImage == null)
                                InkWell(
                                  onTap: () {
                                    cubit.getProfileImageFromGallery();
                                  },
                                  child: CircleAvatar(
                                    radius: radius,
                                    backgroundColor: secondColor,
                                    child: CircleAvatar(
                                      backgroundImage: CachedNetworkImageProvider(
                                        cubit.userModel!.profile,
                                      ),
                                      radius: radius -10,
                                    ),
                                  ),
                                ),
                              if (profileImage != null)
                                InkWell(
                                  onTap: () {
                                    cubit.getProfileImageFromGallery();
                                  },
                                  child: CircleAvatar(
                                    radius: radius,
                                    backgroundColor: secondColor,
                                    child: CircleAvatar(
                                      backgroundImage: FileImage(
                                          profileImage),
                                      radius: radius-10,
                                    ),
                                  ),
                                ),
                              if(requiredWidth + 140 <= availableWidth)
                                Padding(
                                  padding: const EdgeInsets.only(top: 15),
                                  child: CircleAvatar(
                                    radius: radius - (radius - 30),
                                    backgroundColor: secondColor,
                                    child: IconButton(
                                      onPressed: () {
                                        cubit.getProfileImageFromGallery();
                                      },
                                      icon:  Icon(
                                        Icons.photo,
                                        size: 30,
                                        color: defColor,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),

                          const SizedBox(
                            height: 20,
                          ),

                          ///name
                          defTextFormField(
                              controller: name,
                              validator: 'validator',
                              leftIcon: Icons.person_outline,
                          ),

                          ///bio
                          defTextFormField(
                              controller: bio,
                              validator: 'validator',
                              maxLines: null,
                              maxLength: 300,
                              leftIcon: Icons.list_alt,
                          ),


                          defContainer(
                              onTap: () {
                                cubit
                                    .updateUser(name: name.text, bio: bio.text);
                              },
                              icon: false,
                              isRightIcon: false,
                              text: 'Update')
                        ],
                      ),
                    ),
                  ),
                );
              }
            ),
          );
        },
    );
  }
}
