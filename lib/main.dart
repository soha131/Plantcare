import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:plantcare/splash.dart';
import 'login.dart';
import 'model/detect_cubit.dart';
import 'model/history_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // لازم تحطي Firebase.init هنا

  FacebookAuth.instance.webAndDesktopInitialize(
    appId: "707160041912269",
    cookie: true,
    xfbml: true,
    version: "v19.0",
  );

  runApp(

      MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MultiBlocProvider(
        providers: [
        BlocProvider(create: (context) => DiseaseDetectionCubit()),
          BlocProvider(create: (context) => HistoryCubit()),


    ], child: MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
        routes: {
          '/login': (context) => LoginScreen(), // اسم الشاشة اللي بيرجع لها بعد تسجيل الخروج
        }

    ));
  }
}

