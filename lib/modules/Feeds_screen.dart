import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/social_model/post_model.dart';
import '../shared/social_cubit/cubit.dart';
import '../shared/social_cubit/stares.dart';
import '../styles/colors.dart';

class FeedsScreen extends StatelessWidget {
  const FeedsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return ConditionalBuilder(
            condition: SocialCubit.get(context).posts.length > 0,
            builder: (context) => Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListView.separated(
                    itemBuilder: (context, index) => postItem(
                        SocialCubit.get(context).posts[index], index, context),
                    separatorBuilder: (context, index) => const SizedBox(
                          height: 8,
                        ),
                    itemCount: SocialCubit.get(context).posts.length)),
            fallback: (context) => Center(
                child: CircularProgressIndicator(
              color: defColor,
            )),
          );
        });
  }

  Widget postItem(PostModel model, index, context) => Container(
        decoration: BoxDecoration(
          color: Colors.black,
          border: Border.all(color: defColor),
          borderRadius: BorderRadius.circular(20),
        ),
        height: model.imagePost != '' ? 360 : 170,
        padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// information
            Row(
              children: [
                /// image
                CircleAvatar(
                  radius: 22,
                  backgroundImage: NetworkImage(model.imageProfile),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        model.name,
                        style: TextStyle(color: defColor, height: 1),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(model.datetime,
                          style: TextStyle(color: defColor, height: 1)),
                    ],
                  ),
                ),
                Icon(
                  Icons.more_horiz,
                  color: defColor,
                )
              ],
            ),

            /// image post
            if (model.imagePost != '')
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  child: Image(
                    image: NetworkImage(model.imagePost),
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.fill,
                  ),
                ),
              ),

            ///text post
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                model.textPost,
                //  maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.end,
                style: TextStyle(
                  color: defColor,
                ),
              ),
            ),

            const Spacer(),

            /// liked
            Row(
              children: [
                /// icon
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: () {
                          SocialCubit.get(context).likePost(
                              SocialCubit.get(context).postsId[index]);
                        },
                        icon: Icon(
                          Icons.favorite_outline,
                          color: defColor,
                        ),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Text(
                        'like',
                        style: TextStyle(color: defColor),
                      ),
                    ],
                  ),
                ),

                ///  like number
                Expanded(
                  child: Text(
                    'Liked by ${SocialCubit.get(context).likes[index]}',
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      color: defColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
}
