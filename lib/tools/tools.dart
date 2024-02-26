import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/image_composition.dart';
import 'package:flame_noise/flame_noise.dart';
import 'package:flutter/material.dart';
import 'package:oceanoasis/tools/slashEffect.dart';

class Tools extends SpriteComponent with CollisionCallbacks {
  String? id;
  RectangleHitbox hitbox = RectangleHitbox();
  SlashEffect? slashEffect;

  Tools(
      {required Sprite sprite,
      required Vector2 size,
      required Vector2 position,
      this.slashEffect,
      this.id})
      : super(
          sprite: sprite,
          position: position,
          size: size,
        );

  @override
  FutureOr<void> onLoad() {
    // TODO: implement onLoad
    add(hitbox);
    return super.onLoad();
  }
}
