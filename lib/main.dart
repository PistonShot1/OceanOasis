import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';
import 'package:oceanoasis/mainmenu.dart';

void main() {
  final game = MyGame();
  runApp(GameWidget(game: game));
}
