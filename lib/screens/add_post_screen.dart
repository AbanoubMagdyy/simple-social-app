import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../components/components.dart';
import '../shared/social_bloc/cubit.dart';
import '../shared/social_bloc/states.dart';
import '../styles/colors.dart';

class AddPostScreen extends StatelessWidget {

  final text = TextEditingController();
  final double requiredHeight = 360;



  AddPostScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {
        if(state is SuccessCreatePost){
          SocialCubit.get(context).getPosts();
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        final cubit = SocialCubit.get(context);
        final postImage = cubit.postImage;
        return Scaffold(
          appBar:  AppBar(
              title: const Text(
                'Create Post',
              ),
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: defColor,
                  ),
              ),
            actions: [
              if(state is LeadingCreatePost)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: fallBack(),
                )
            ],
          ),
          body: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final double availableHeight = constraints.maxHeight;
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    if(requiredHeight < availableHeight)
                    /// my information
                    Row(
                      children: [
                        /// my photo
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: CachedNetworkImageProvider(
                              cubit.userModel!.profile,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),

                        ///my name
                        Expanded(
                          child: Text(
                            cubit.userModel!.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: defColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 10,),
                    /// text form field and photo post
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          /// text form field
                          Expanded(
                            flex: 2,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(width: 1.0, color: defColor),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: TextFormField(
                                controller: text,
                                maxLines: null,
                                maxLength: 500,
                                keyboardType: TextInputType.multiline,
                                style: TextStyle(color: defColor),
                                decoration:  InputDecoration(
                                  counterStyle: TextStyle(color: defColor), // Customize maxLength text color
                                  hintText: 'Enter your post',
                                  hintStyle: TextStyle(color: defColor),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.all(8.0),
                                ),
                              ),
                            ),
                          ),
                          ///  photo post
                          if (postImage != null && requiredHeight < availableHeight)
                            Expanded(
                              child: Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  Container(
                                    margin: const EdgeInsetsDirectional.all(5),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: FileImage(postImage),
                                            fit: BoxFit.fill,
                                        ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CircleAvatar(
                                      radius: 20,
                                      child: IconButton(
                                          onPressed: () {
                                            cubit
                                                .removeImagePost();
                                          },
                                          icon: const Icon(
                                              Icons.highlight_remove_sharp,
                                          ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),

                    if(requiredHeight - 200 < availableHeight)
                    /// add and post buttons
                    Row(
                      children: [
                        if(requiredHeight < availableHeight)
                        /// add photo
                        Expanded(
                            child: InkWell(
                              onTap: () {
                                cubit.getPostImageFromGallery();
                              },
                              child: Container(
                                height: 50,
                                margin: const EdgeInsetsDirectional.only(top:10 ,bottom: 10,end: 10),
                                padding: const EdgeInsetsDirectional.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  color: defColor,
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: Row(
                                  children: const [
                                    Icon(Icons.photo),
                                    Expanded(
                                      child: Text('Add photo',textAlign: TextAlign.center,
                                    ),
                                    )
                                  ],
                                ),
                              ),
                            ),

                        ),
                        ///post
                        Expanded(
                            child: InkWell(
                              onTap: () {
                                DateTime now = DateTime.now();
                                if (postImage == null) {
                                  cubit.createPost(
                                      dateTime: now.toString(), textPost: text.text);
                                } else {
                                  cubit.upLoadPostImage(
                                      dateTime: now.toString(), textPost: text.text);
                                }
                              },
                              child: Container(
                                height: 50,
                                margin: const EdgeInsetsDirectional.symmetric(vertical: 10),
                                padding: const EdgeInsetsDirectional.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  color: defColor,
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: Row(
                                  children: const [
                                    Icon(Icons.post_add),
                                    Expanded(
                                      child: Text('Post',textAlign: TextAlign.center,
                                    ),
                                    )
                                  ],
                                ),
                              ),
                            ),

                        ),
                      ],
                    ),
                  ],
                ),
              );
            }
          ),
        );
      },
    );
  }
}
