
import 'package:flutter/material.dart';
import 'package:oceanoasis/routes/mainmenu.dart';

void main() async {
  // final game = MyGame();
  WidgetsFlutterBinding.ensureInitialized();
  // await windowManager.ensureInitialized();
  // await windowsConfig();
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Retro Gaming'),
      home: const MainMenu()));
}

//Windows setup
Future windowsConfig() async {
  // await DesktopWindow.setWindowSize(Size(500, 500));
  // await DesktopWindow.setMinWindowSize(Size(400, 400));
  // await DesktopWindow.setMaxWindowSize(Size(800, 800));
  // await DesktopWindow.setFullScreen(true);
  // await DesktopWindow.setFullScreen(false);
  // await WindowManager.instance.setFullScreen(true);
}
