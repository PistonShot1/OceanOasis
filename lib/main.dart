import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:oceanoasis/firebase_options.dart';
import 'package:oceanoasis/property/userprofile.dart';
import 'package:oceanoasis/main_menu.dart';
import 'package:provider/provider.dart';

void main() async {

  //For Flame purpose
  WidgetsFlutterBinding.ensureInitialized(); 

  //Initialize firebase and ask for sign in request
  if (!Platform.isWindows) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

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
