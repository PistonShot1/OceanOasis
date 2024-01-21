import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:oceanoasis/homescreen.dart';
import 'package:oceanoasis/mainmenu.dart';

void main() {
  // final game = MyGame();
  runApp(MaterialApp(
    theme: ThemeData(fontFamily: 'Retro Gaming'),
    home: MainWidget(),
  ));
}
