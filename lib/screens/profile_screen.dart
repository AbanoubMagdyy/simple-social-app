import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_social_app/components/constants.dart';
import 'package:simple_social_app/models/social_model/post_model.dart';
import '../shared/social_bloc/cubit.dart';
import '../shared/social_bloc/states.dart';
import '../styles/colors.dart';

class ProfileScreen extends StatelessWidget {
  final int requiredHeight = 420;
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
     PostModel? post;
     int postIndex = 0;
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        final cubit = SocialCubit.get(context);
        final model = cubit.userModel;
        return LayoutBuilder(
          builder: (context,covariant) {
            double availableHeight = covariant.maxHeight;
            return Stack(
              alignment: Alignment.bottomRight,
              children: [
                /// profile  background
                Container(
                  height: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: CachedNetworkImageProvider(model!.profile),
                    ),
                  ),
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
                if(requiredHeight < availableHeight)
                Padding(
                  padding:  EdgeInsets.only(top: availableHeight/3.5),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    height: double.infinity,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                        color: Colors.black,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20),),),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: CachedNetworkImageProvider(model.profile),
                        ),
                        ///name
                        Text(
                          model.name,
                          style: TextStyle(
                              color: defColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),

                        ///bio
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            model.bio,
                            style: TextStyle(
                                color: defColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                        ),

                        /// information about me
                        Row(
                          children: [
                            /// posts
                            item(text: 'Posts', number: cubit.myPosts.length),

                            ///followers
                            item(text: 'Followers'),

                            ///following
                            item(text: 'Following'),
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Expanded(
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 8.0,
                              mainAxisSpacing: 8.0,
                            ),
                            itemCount: cubit.myPosts.length,
                            itemBuilder: (context, index) => InkWell(
                              onTap: () {
                                post = cubit.myPosts[index];
                                index = index;
                                cubit.profileVisibilityChanged();
                              },
                              child: Container(
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadiusDirectional.circular(
                                    10,
                                  ),
                                  border: Border.all(
                                    color: defColor,
                                    width: 1,
                                  ),
                                ),
                                child: postItem(cubit.myPosts[index].imagePost),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),

                if (cubit.showPost && post != null)
                  postItemIfIClick(post!, postIndex,context)
              ],
            );
          }
        );
      },
    );
  }

  Widget item({int number = 400, required String text}) => Expanded(
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Text(
                    number.toString(),
                    style: TextStyle(
                        color: defColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  ),
                  const SizedBox(height: 5),
                  FittedBox(
                    child: Text(
                      text,
                      style: TextStyle(
                          color: defColor.withOpacity(0.4),
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 1,
              height: 40,
              color: defColor.withOpacity(0.4),
            ),
          ],
        ),
      );

  Widget postItem(image) => image == ''
      ? Image.asset(
          'assets/image/x icon.png',
        )
      : getNetworkImage(url: image);

  Widget postItemIfIClick(PostModel model, index,context) => BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Center(
        child:Container(
          margin: const EdgeInsets.symmetric(horizontal: 30),
          padding: const EdgeInsets.all(15),
          color: Colors.black,
          height: 400,
          child: Row(
            children: [
              /// image
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(right: 10),
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadiusDirectional.circular(10),
                    border: Border.all(color: defColor, width: 1),
                  ),
                  child: model.imagePost != ''
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: getNetworkImage(
                      url: model.imagePost,
                      width: double.infinity,
                    ),
                  )
                      : Image.asset(
                    'assets/image/x icon.png',
                    width: double.infinity,
                  ),
                ),
              ),

              /// text and love icon
              Expanded(
                child: Text(
                  model.textPost,
                  maxLines: 15,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                    color: secondColor,
                    fontSize: 18,
                  ),
                ),
              ),
              /// exit icon
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: () {
                    SocialCubit.get(context).profileVisibilityChanged();
                  },
                  color: secondColor,
                  icon: const Icon(
                    Icons.highlight_remove_sharp,
                    size: 35,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
  );
}