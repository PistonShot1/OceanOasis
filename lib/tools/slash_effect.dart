import 'dart:async';
import 'dart:ui' hide Image;

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/image_composition.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:oceanoasis/components/Boss/crabBoss.dart';
import 'package:oceanoasis/maps/underwater/joystickplayer.dart';
import 'package:oceanoasis/property/defaultgameProperty.dart';
import 'package:oceanoasis/routes/gameplay.dart';
import 'package:oceanoasis/tools/magnet_effect.dart';
import 'package:oceanoasis/tools/rubbish_picker_effect.dart';
import 'package:oceanoasis/wasteComponents/waste.dart';

class SlashEffect extends SpriteAnimationComponent
    with CollisionCallbacks, HasGameReference<MyGame> {
  final int? damage; //(used for boss fight scenario)

  final Image spriteSheetImage;
  final double stepTime;
  final Vector2 frameSize;
  final int frameAmount;
  final List<WasteType> slashType;
  final String toolType;
  List<Effect>? effects;
  JoystickPlayer? playerRef;
  SlashEffect(this.spriteSheetImage, this.slashType,
      {required this.frameAmount,
      required this.stepTime,
      required this.frameSize,
      required this.toolType,
      this.damage,
      this.effects,
      this.playerRef})
      : super.fromFrameData(
            spriteSheetImage,
            SpriteAnimationData.sequenced(
              amount: frameAmount,
              stepTime: stepTime,
              textureSize: frameSize,
            ));
  SlashEffect.clone(
      {required SlashEffect slashEffect, required JoystickPlayer playerRef})
      : this(slashEffect.spriteSheetImage, slashEffect.slashType,
            damage: slashEffect.damage,
            frameAmount: slashEffect.frameAmount,
            frameSize: slashEffect.frameSize,
            stepTime: slashEffect.stepTime,
            toolType: slashEffect.toolType,
            effects: slashEffect.effects,
            playerRef: playerRef);
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

    hitEffect();
    super.onMount();
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    // TODO: implement onCollisionEnd

    super.onCollisionEnd(other);
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    //remove the bullet when it hit ANY waste

    super.onCollisionStart(intersectionPoints, other);
  }

  @override
  void onRemove() {
    // TODO: implement onRemove
    super.onRemove();
  }

  void hitEffect() {
    if (effects != null) {
      addAll(effects!);
    }
  }

  static SlashEffect createInstance(
      {required SlashEffect slashEffect, required JoystickPlayer playerRef}) {
    if (slashEffect is RubbishPickerEffect) {
      return RubbishPickerEffect.clone(
          slashEffect: slashEffect, playerRef: playerRef);
    } else if (slashEffect is MagnetEffect) {
      return MagnetEffect.clone(slashEffect: slashEffect, playerRef: playerRef);
    }
    // Handle other types of slash effects as needed
    throw ArgumentError('Unknown type of slashEffect');
  }
}
