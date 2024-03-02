import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'dart:ui' as ui;

import 'package:oceanoasis/routes/gameplay.dart';

class CircularMaskComponent extends PositionComponent
    with HasGameReference<MyGame> {
  final double radius;

  CircularMaskComponent({required this.radius});

  @override
  void render(ui.Canvas canvas) {
    final screenSize = game.size;
    final paint = ui.Paint()..color = const ui.Color.fromARGB(255, 255, 0, 0);

    // Draw an opaque rectangle that covers the entire screen
    canvas.drawRect(ui.Rect.fromLTWH(0, 0, screenSize.x, screenSize.y), paint);

    // Change the blend mode to clear to make the circle transparent
    paint.blendMode = ui.BlendMode.clear;

    // Draw the transparent circle in the middle of the screen
    canvas.drawCircle(screenSize.toOffset() * 0.5, radius, paint);
  }
}
