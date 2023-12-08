import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:simple_social_app/components/components.dart';
import '../../models/social_model/post_model.dart';
import '../components/constants.dart';
import '../shared/social_bloc/cubit.dart';
import '../shared/social_bloc/states.dart';
import '../styles/colors.dart';

class FeedsScreen extends StatelessWidget {
  final requiredWidth = 300;
  const FeedsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = SocialCubit.get(context);
        return Visibility(
          visible: cubit.posts.isNotEmpty,
          replacement: fallBack(),
          child: RefreshIndicator(
            onRefresh: ()=>cubit.getPosts(),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  if(state is LeadingGetPosts)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: LinearProgressIndicator(),
                  ),
                  Expanded(
                    child: ListView.separated(
                      itemBuilder: (context, index) => postItem(
                        cubit.posts[index],
                        index,
                      ),
                      separatorBuilder: (context, index) => const SizedBox(
                        height: 8,
                      ),
                      itemCount: cubit.posts.length,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget postItem(PostModel model, index) => LayoutBuilder(
    builder: (BuildContext context, BoxConstraints constraints ) {
        String apiTimeString = model.datetime;
        DateTime apiTime = DateTime.parse(apiTimeString);
        DateFormat formatter = DateFormat("yyyy-MM-dd h:mm a");
        String formattedTime = formatter.format(apiTime);
        double availableWidth = constraints.maxWidth;
       bool interactedBefore =  model.peopleWhoInteracted.contains(SocialCubit.get(context).userModel?.uid);
       int numberOfReacts = model.numberOfReacts;
        return  Stack(
          alignment: Alignment.bottomLeft,
          children: [
            /// image
            Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadiusDirectional.circular(10),
                border: Border.all(
                  color: defColor,
                  width: 1
                )
              ),
              child: model.imagePost != '' ?  Stack(
                alignment: Alignment.topRight,
                children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: getNetworkImage(
                      url:
                      model.imagePost,
                      width: double.infinity,
                    ),
                  ),
                  if(availableWidth > requiredWidth)
                    /// visibility icon
                    Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: CircleAvatar(
                      backgroundColor: secondColor,
                      radius: 20,
                        child: IconButton(onPressed: (){
                          SocialCubit.get(context).togglePostVisibility(index);
                        },
                          icon: Icon(model.showDetails ? Icons.visibility_off_sharp : Icons.visibility_outlined),
                        ),
                    ),
                  )
                ],
              ) : Image.asset('assets/image/x icon.png',width: double.infinity,),
            ),
            if(availableWidth > requiredWidth && model.showDetails)
            Container(
              margin: const EdgeInsetsDirectional.all(5),
              padding: const EdgeInsetsDirectional.all(10),
              decoration: BoxDecoration(
                color: defColor.withOpacity(.4),
                borderRadius: BorderRadiusDirectional.circular(5)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// user and post information
                  Row(
                    children: [
                      /// user image
                       CircleAvatar(
                        radius: 25,
                        backgroundImage:CachedNetworkImageProvider(model.imageProfile) ,
                      ),
                      const SizedBox(
                        width: 10,
                      ),

                      /// user name and pot datetime
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:  [
                            /// user name
                            Text(
                               model.name,
                              style: const TextStyle(
                                  color: secondColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),

                            /// post time and date
                            Text(
                              formattedTime,
                              style: const TextStyle(
                                  color: secondColor, height: 1),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  /// post text
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      /// post text
                       Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(model.textPost,
                              maxLines: 15,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.end,
                              style: const TextStyle(
                                  color: secondColor, fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          /// love icon
                          CircleAvatar(
                            backgroundColor: secondColor,
                            radius: 20,
                            child: IconButton(
                              onPressed: () {

                                SocialCubit.get(context).likePost(
                                  index: index,
                                  postId: model.postID,
                                  interactedBefore: interactedBefore
                                );
                                 SocialCubit.get(context).changeReacts(index,interactedBefore);
                              },
                              icon: Icon(
                                interactedBefore ? Icons.favorite :  Icons.favorite_outline,
                                color: defColor,
                              ),
                            ),
                          ),
                          /// number of reacts
                          if(numberOfReacts != 0)
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Text(
                              numberOfReacts.toString(),
                              textAlign: TextAlign.end,
                              style: const TextStyle(
                                color: secondColor,
                              ),
                          ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
  );
}
