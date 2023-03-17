import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter/foundation.dart' as foundation;
import '../styles/colors.dart';

Widget loginButton({
  double width = double.infinity,
  Color background = Colors.blue,
  Color colorText = Colors.white,
  bool uppercaseText = true,
  required void Function() onPressed,
  required String text,
}) =>
    Container(
      width: width,
      color: background,
      child: MaterialButton(
        onPressed: onPressed,
        child: Text(
          uppercaseText ? text.toUpperCase() : text,
          style: TextStyle(
            color: colorText,
          ),
        ),
      ),
    );

Widget textFormField({
  void Function()? onPressedIconButton,
  void Function()? onTap,
  required TextEditingController controller,
  required TextInputType textType,
  IconData? suffix,
  IconData? prefix,
  bool isPassword = false,
  String? labelText,
  String validatorText = '',
  double height = 50,
}) =>
    SizedBox(
      height: height,
      child: TextFormField(
        onTap: onTap,
        controller: controller,
        validator: (value) {
          if (value!.isEmpty) {
            return validatorText;
          }
          return null;
        },
        keyboardType: textType,
        obscureText: isPassword,
        onFieldSubmitted: (String value) {
          if (kDebugMode) {
            print(value);
          }
        },
        onChanged: (String value) {
          if (kDebugMode) {
            print(value);
          }
        },
        decoration: InputDecoration(
          labelText: labelText,
          prefixIcon: Icon(prefix),
          suffixIcon: IconButton(
            onPressed: onPressedIconButton,
            icon: Icon(suffix),
          ),
          border: const OutlineInputBorder(),
        ),
      ),
    );

Widget defContainer({
  required Function() onTap,
  double elevation = 15,
  double height = 50,
  double width = double.infinity,
  required bool icon,
  required bool isRightIcon,
  required String text,
}) =>
    InkWell(
      onTap: onTap,
      child: Material(
        elevation: elevation,
        shadowColor: defColor,
        borderRadius: const BorderRadius.all(Radius.circular(50)),
        child: Container(
          height: height,
          width: width,
          padding: const EdgeInsetsDirectional.all(8),
          decoration: BoxDecoration(
              color: defColor, borderRadius: BorderRadius.circular(50)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon == true)
                  const Image(
                    image: AssetImage('assets/image/facebook.png'),
                    height: 30,
                  ),
                if (icon == true)
                  const SizedBox(
                    width: 26,
                  ),
                Text(
                  text,
                  style: const TextStyle(color: Colors.white, fontSize: 17),
                ),
                if (isRightIcon == true) const Spacer(),
                if (isRightIcon == true)
                  const Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                  )
              ],
            ),
          ),
        ),
      ),
    );

Widget defTextFormField({
  required TextEditingController controller,
  TextInputType keyboard = TextInputType.name,
  String? hint,
  bool isPassword = false,
  Function()? onPressedIcon,
  required String validator,
  IconData? leftIcon,
  IconData? rightIcon,
}) =>
    TextFormField(
      keyboardType: keyboard,
      validator: (value) {
        if (value!.isEmpty) {
          return validator;
        }
        return null;
      },
      obscureText: isPassword,
      controller: controller,
      decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          hintText: hint,
          prefixIcon: Icon(leftIcon),
          suffixIcon: IconButton(
            onPressed: onPressedIcon,
            icon: Icon(rightIcon),
          ),
          filled: true,
          fillColor: HexColor('#fbfbfb')),
    );

void navigateTo(context, widget) =>
    Navigator.push(context, MaterialPageRoute(builder: (context) => widget));

void navigateAndFinish(context, widget) => Navigator.pushAndRemoveUntil(
    context, MaterialPageRoute(builder: (context) => widget), (route) => false);

Widget emoji(TextEditingController controller) => EmojiPicker(
      onEmojiSelected: (category, emoji) {
        controller.text = controller.text;
      },
      textEditingController: controller,
      // pass here the same [TextEditingController] that is connected to your input field, usually a [TextFormField]
      config: Config(
        columns: 7,
        emojiSizeMax: 32 *
            (foundation.defaultTargetPlatform == TargetPlatform.iOS
                ? 1.30
                : 1.0),
        // Issue: https://github.com/flutter/flutter/issues/28894
        verticalSpacing: 0,
        horizontalSpacing: 0,
        gridPadding: EdgeInsets.zero,
        // initCategory: Category.RECENT,
        bgColor: const Color(0xFFF2F2F2),
        indicatorColor: Colors.blue,
        iconColor: Colors.grey,
        iconColorSelected: Colors.blue,
        backspaceColor: Colors.blue,
        skinToneDialogBgColor: Colors.white,
        skinToneIndicatorColor: Colors.grey,
        enableSkinTones: true,
        showRecentsTab: true,
        recentsLimit: 28,
        noRecents: const Text(
          'No Recent',
          style: TextStyle(fontSize: 20, color: Colors.black26),
          textAlign: TextAlign.center,
        ),
        // Needs to be const Widget
        loadingIndicator: const SizedBox.shrink(),
        // Needs to be const Widget
        tabIndicatorAnimDuration: kTabScrollDuration,
        categoryIcons: const CategoryIcons(),
        buttonMode: ButtonMode.MATERIAL,
      ),
    );
