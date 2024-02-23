import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:oceanoasis/tools/slashEffect.dart';

class WeaponSlashEffect extends SlashEffect {
  WeaponSlashEffect(super.image, super.id,
      {required super.stepTime,
      required super.frameAmount,
      required super.frameSize});
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
}
