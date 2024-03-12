import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:oceanoasis/firebase_options.dart';
import 'package:oceanoasis/property/userprofile.dart';
import 'package:oceanoasis/routes/mainmenu.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); //For Flame purpose

  //Android
  //Initialize firebase and ask for sign in request
  if (!Platform.isWindows) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  //Windows
  // if (Platform.isWindows) {
  //   await windowManager.ensureInitialized();
  //   await windowsConfig();
  // }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserProfile(),
        )
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(fontFamily: 'Retro Gaming'),
          home: const MainMenu()),
    ),
  );
  
}

//Windows setup
Future windowsConfig() async {
  await WindowManager.instance.setFullScreen(true);
}
