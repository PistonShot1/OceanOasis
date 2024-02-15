import 'dart:async';
import 'dart:ui' hide Image;

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/image_composition.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:oceanoasis/homescreen.dart';
import 'package:oceanoasis/wasteComponents/newspaper.dart';

class SlashEffect extends SpriteComponent
    with CollisionCallbacks, HasGameReference<MyGame> {
  final String id;
  SlashEffect(Image image, this.id) : super.fromImage(image);
  @override
  FutureOr<void> onLoad() {
    // TODO: implement onLoad
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke;
    add(RectangleHitbox()
      ..paint = paint
      ..renderShape = true
      ..collisionType = CollisionType.active);
    return super.onLoad();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    // TODO: implement onCollision

    super.onCollision(intersectionPoints, other);
  }
}
