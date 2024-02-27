import 'dart:async';
import 'dart:ui' hide Image;

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/image_composition.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:oceanoasis/components/Boss/crabBoss.dart';
import 'package:oceanoasis/property/defaultgameProperty.dart';
import 'package:oceanoasis/routes/gameplay.dart';
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
  Effect? effects;
  SlashEffect(this.spriteSheetImage, this.slashType,
      {required this.frameAmount,
      required this.stepTime,
      required this.frameSize,
      required this.toolType,
      this.damage,
      this.effects})
      : super.fromFrameData(
            spriteSheetImage,
            SpriteAnimationData.sequenced(
              amount: frameAmount,
              stepTime: stepTime,
              textureSize: frameSize,
            ));
  SlashEffect.clone(SlashEffect slashEffect)
      : this(slashEffect.spriteSheetImage, slashEffect.slashType,
            damage: slashEffect.damage,
            frameAmount: slashEffect.frameAmount,
            frameSize: slashEffect.frameSize,
            stepTime: slashEffect.stepTime,
            toolType: slashEffect.toolType);
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

    // Future.delayed(Duration(milliseconds: animation!.frames.length * 100), () {
    //   removeFromParent();
    // });
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
    // TODO: implement onCollisionStart
    if (other is crabBoss) {
      print('Crabboss was hit');
    } else if (other is ScreenHitbox) {
      print('Screenhitbox was hit');
    }

    if (other is Waste) {
      removeFromParent();
    }
    super.onCollisionStart(intersectionPoints, other);
  }

  @override
  void onRemove() {
    // TODO: implement onRemove
    super.onRemove();
  }

  void hitEffect() {
    // effects = MoveEffect.by(Vector2(200, 0), EffectController(duration: 0.8),
    //     onComplete: () {
    //   removeFromParent();
    // });
    if (effects != null) {
      add(effects!);
    }
  }
}
