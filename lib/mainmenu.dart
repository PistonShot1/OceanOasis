import 'dart:ui';

import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

class MyGame extends FlameGame {
  late Sprite backgroundImage;

  @override
  Future<void> onLoad() async {
    await Flame.images.load('main-menu-background.jpg');
    backgroundImage =
        Sprite(Flame.images.fromCache('main-menu-background.jpg'));
  }

  @override
  void render(Canvas canvas) {
    // Clear the canvas
    canvas.drawRect(
        const Rect.fromLTWH(0, 0, double.infinity, double.infinity), Paint()..color = Colors.white);

    // Render the background image
    backgroundImage.renderRect(canvas, Rect.fromLTWH(0, 0, size.x, size.y));
  }
}
