import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/image_composition.dart';
import 'package:flame_noise/flame_noise.dart';
import 'package:flutter/material.dart';
import 'package:oceanoasis/tools/slashEffect.dart';

class PaperCollector extends SpriteComponent with CollisionCallbacks {
  String? id;

  SlashEffect? slashEffect;
  String? slashType;
  PaperCollector(
      {required Sprite sprite,
      required Vector2 size,
      required Vector2 position,
      this.slashType,
      ComponentKey? key,
      this.slashEffect,
      this.id})
      : super(sprite: sprite, position: position, size: size, key: key);

  @override
  FutureOr<void> onLoad() {
    // TODO: implement onLoad

    //Debug
    

    return super.onLoad();
  }
}
