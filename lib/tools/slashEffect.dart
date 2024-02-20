import 'dart:async';
import 'dart:ui' hide Image;

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/image_composition.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:oceanoasis/routes/homescreen.dart';
import 'package:oceanoasis/wasteComponents/newspaper.dart';

class SlashEffect extends SpriteAnimationComponent
    with CollisionCallbacks, HasGameReference<MyGame> {
  final String id;
  SlashEffect(Image image, this.id,
      {required int amount,
      required double stepTime,
      required Vector2 textureSize})
      : super.fromFrameData(
            image,
            SpriteAnimationData.sequenced(
              amount: amount,
              stepTime: stepTime,
              textureSize: textureSize,
            ));
  @override
  FutureOr<void> onLoad() {
    // TODO: implement onLoad
    opacity = 1;
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
  void onMount() {
    // TODO: implement onMount
    Future.delayed(const Duration(milliseconds: 300), () {
      removeFromParent();
    });
    super.onMount();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    // TODO: implement onCollision

    super.onCollision(intersectionPoints, other);
  }
}
