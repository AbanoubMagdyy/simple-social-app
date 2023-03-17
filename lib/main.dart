import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_social_app/shared/bloc_observer.dart';
import 'package:simple_social_app/shared/social_cubit/cubit.dart';
import 'package:simple_social_app/styles/themes.dart';
import 'components/constants.dart';
import 'layout/social_app_screen.dart';
import 'modules/hello_screen.dart';
import 'network/local/shared_prefrence.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedHelper.init();
  await Firebase.initializeApp();
  Bloc.observer = MyBlocObserver();
  id =  SharedHelper.getData('uid');
  if (kDebugMode) {
    print(id);
  }
  late Widget widget;
  if (id != null) {
    widget = const  SocialHomeScreen();
  } else {
    widget = const HelloScreen() ;
  }
  runApp(MyApp(widget));
}

class MyApp extends StatelessWidget {
  MyApp(this.screen, {Key? key}) : super(key: key);
  late Widget screen;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context)=>SocialCubit()..getUserData()..getPosts(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.dark,
        darkTheme: dark,
        home: screen,
      ),
    );
  }
}
