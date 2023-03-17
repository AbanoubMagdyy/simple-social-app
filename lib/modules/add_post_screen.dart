import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../shared/social_cubit/cubit.dart';
import '../shared/social_cubit/stares.dart';
import '../styles/colors.dart';

class AddPostScreen extends StatelessWidget {
  const AddPostScreen({Key? key}) : super(key: key);
  static var text = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {
        if(state is SuccessCreatePost){
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        var postImage = SocialCubit.get(context).postImage;
        return Scaffold(
          appBar: AppBar(
              title: Text(
                'Create Post',
                style: TextStyle(color: defColor),
              ),
              titleSpacing: 0,
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: defColor,
                  ))),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                ///my
                Row(
                  children: [
                    /// my photo
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(
                          SocialCubit.get(context).userModel!.profile),
                    ),
                    const SizedBox(
                      width: 10,
                    ),

                    ///my name
                    Expanded(
                      child: Text(
                        SocialCubit.get(context).userModel!.name,
                        style: TextStyle(
                            color: defColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    )
                  ],
                ),

                /// text form field
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextFormField(
                        maxLines: 11,
                        controller: text,
                        style: TextStyle(color: defColor),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                      if (postImage != null)
                        Expanded(
                          child: Stack(
                            alignment: Alignment.topRight,
                            children: [
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: FileImage(postImage),
                                        fit: BoxFit.fill)),
                              ),
                              CircleAvatar(
                                radius: 20,
                                child: IconButton(
                                    onPressed: () {
                                      SocialCubit.get(context)
                                          .removeImagePost();
                                    },
                                    icon: const Icon(
                                        Icons.highlight_remove_sharp)),
                              )
                            ],
                          ),
                        ),
                    ],
                  ),
                ),

                /// add and post
                Row(
                  children: [
                    /// add
                    Expanded(
                      child: MaterialButton(
                        onPressed: () {
                          SocialCubit.get(context).getPostImage();
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.photo,
                              color: defColor,
                            ),
                            Expanded(
                              child: Text(
                                'Add photo',
                                maxLines: 1,
                                style: TextStyle(color: defColor),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),

                    ///post
                    Expanded(
                      child: MaterialButton(
                        onPressed: () {
                          DateTime now = DateTime.now();
                          if (postImage == null) {
                            SocialCubit.get(context).createPost(
                                dateTime: now.toString(), textPost: text.text);
                          } else {
                            SocialCubit.get(context).upLoadPostImage(
                                dateTime: now.toString(), textPost: text.text);
                          }
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.post_add,
                              color: defColor,
                            ),
                            Expanded(
                              child: Text(
                                'Post',
                                style: TextStyle(color: defColor),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
