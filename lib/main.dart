import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';
import 'package:oceanoasis/tiledcomponenet.dart';

void main() {
  final game = MyGame();
  runApp(GameWidget(game: game));
}
