import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_social_app/shared/bloc_observer.dart';
import 'package:simple_social_app/shared/social_bloc/cubit.dart';
import 'package:simple_social_app/styles/themes.dart';
import 'components/constants.dart';
import 'layout/social_app_screen.dart';
import 'network/local/shared_prefrence.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedHelper.init();
  await Firebase.initializeApp();
  Bloc.observer = MyBlocObserver();
  id =  SharedHelper.getData('uid') ?? '' ;
  runApp( const MyApp());
}

class MyApp extends StatelessWidget {

   const MyApp({super.key,Key? kKey});


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context)=>SocialCubit()..getUserData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.dark,
        darkTheme: dark,
        home: const SocialHomeScreen(),
      ),
    );
  }
}
