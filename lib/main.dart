import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:oceanoasis/homescreen.dart';
import 'package:oceanoasis/mainmenu.dart';
import 'package:desktop_window/desktop_window.dart';

void main() async {
  // final game = MyGame();
   WidgetsFlutterBinding.ensureInitialized();
  await windowsConfig();
  runApp(MaterialApp(
    theme: ThemeData(fontFamily: 'Retro Gaming'),
    home: MainWidget(),
  ));
}

//Windows setup
Future windowsConfig() async {
  await DesktopWindow.setWindowSize(Size(500, 500));
  await DesktopWindow.setMinWindowSize(Size(400, 400));
  await DesktopWindow.setMaxWindowSize(Size(800, 800));
  // await DesktopWindow.setFullScreen(true);
  // await DesktopWindow.setFullScreen(false);
}
