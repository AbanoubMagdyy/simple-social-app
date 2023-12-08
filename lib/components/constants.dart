import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:simple_social_app/screens/hello_screen.dart';
import '../network/local/shared_prefrence.dart';
import 'components.dart';

String id = '';

void submit(context) {
  SharedHelper.deleteData('uid').then((value) {
    SharedHelper.deleteData('Is Logged')
        .then((value) => navigateAndFinish(context, const HelloScreen()));
  });
}

Widget getNetworkImage({
  required url,
  double? height,
  double? width,
}) =>
    CachedNetworkImage(
      imageUrl: url,
      height: height,
      width: width,
      fit: BoxFit.contain,
      placeholder: (context, url) => fallBack(),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
