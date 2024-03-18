import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:oceanoasis/components/maps/underwater/underwater_scene.dart';

enum Acidity { high, medium, low }

class PHBar extends SpriteComponent {
  UnderwaterScene sceneRef;
  Paint defaultPaint = Paint()..color = Colors.green;
  Acidity currentAcidityLevel = Acidity.low;

  PHBar({required this.sceneRef})
      : super.fromImage(Flame.images.fromCache('ui/stamina-bar.png'));
  @override
  FutureOr<void> onLoad() {
    anchor = Anchor.bottomCenter;
    flipVertically();
    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    double barHeight =
        (sceneRef.currentacidityLevel / sceneRef.maxacidityLevel) * size.y;
    canvas.drawRect(Rect.fromLTWH(0, 0, 16, barHeight), defaultPaint);
    super.render(canvas);
  }

  @override
  void update(double dt) {
    _updateAcidity(sceneRef.currentacidityLevel);
    super.update(dt);
  }

  void _updateAcidity(double acidityLevel) {
    if (acidityLevel > 66) {
      defaultPaint.color = Colors.red;
      currentAcidityLevel = Acidity.high;
    } else if (acidityLevel > 33) {
      defaultPaint.color = Colors.amber;
      currentAcidityLevel = Acidity.medium;
    } else {
      defaultPaint.color = Colors.green;
      currentAcidityLevel = Acidity.low;
    }
  }
}
