import 'dart:async';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:oceanoasis/routes/homescreen.dart';

class WorldCollider extends PositionComponent
    with CollisionCallbacks, HasGameReference<MyGame> {
  final _defaultColor = Colors.cyan;
  late ShapeHitbox hitbox;
  @override
  bool get debugMode => true;
  final bool onHitCallback;
  WorldCollider({required this.onHitCallback});
  @override
  FutureOr<void> onLoad() {
    final defaultPaint = Paint()
      ..color = _defaultColor
      ..style = PaintingStyle.stroke;
    hitbox = RectangleHitbox()
      ..paint = defaultPaint
      ..renderShape = true;
    add(hitbox);
    return super.onLoad();
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    // TODO: implement onCollisionStart
    print('This box was hit');
    if (onHitCallback) {
      // game.camera.follow(game.birdPlayer);
    }
    super.onCollisionStart(intersectionPoints, other);
  }
}
