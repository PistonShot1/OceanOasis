import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/flame.dart';
import 'package:flame/geometry.dart';
import 'package:oceanoasis/property/defaultgameProperty.dart';
import 'package:oceanoasis/tools/slash_effect.dart';
import 'package:oceanoasis/wasteComponents/waste.dart';

class RubbishPickerEffect extends SlashEffect {
  bool specialEffect1 = true;
  bool ischildBullet = false;
  List<Effect> specificeffects = [];

  RubbishPickerEffect(super.spriteSheetImage, super.slashType,
      {required super.frameAmount,
      required super.stepTime,
      required super.frameSize,
      required super.toolType,
      super.effects});
  RubbishPickerEffect.clone(
      {required super.slashEffect, required super.playerRef})
      : super.clone();

  @override
  void onMount() {
    // TODO: implement onMount
    if (ischildBullet) {
      size = Vector2(32, 32);
      _moveEffect2();
    } else {
      size = Vector2(64, 32);
      _moveEffect();
    }
    addAll(specificeffects);
    super.onMount();
  }

  @override
  void update(double dt) {
    if (playerRef != null) {
      if (position.y < playerRef!.movementBoundary[2] && isMounted) {
        removeFromParent();
      }
    }
    super.update(dt);
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    // TODO: implement onCollisionStart
    if (other is Waste && specialEffect1) {
      specialEffect1 = false;
      _produceSpecialEffect1();
    }
    super.onCollisionStart(intersectionPoints, other);
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
    if (other is ScreenHitbox) {
      removeFromParent();
    }
  }

  void _moveEffect() {
    final xDirection = 1920 * playerRef!.facingDirectionnum;
    final yDirection = tan(angle) * 1920;
    final effect = MoveEffect.by(
        Vector2(xDirection, yDirection), EffectController(duration: 5),
        onComplete: () {});
    if (playerRef != null) {
      specificeffects.add(effect);
    }
  }

  void _moveEffect2() {
    final xDirection = 1920 * playerRef!.facingDirectionnum;
    double yDirection = tan(angle) * xDirection;
    final effect = MoveEffect.by(
        Vector2(xDirection, yDirection), EffectController(duration: 5),
        onComplete: () {});
    if (playerRef != null) {
      specificeffects.add(effect);
    }
  }
  

  void _produceSpecialEffect1() {
    List<double> shootAngles = [
      radians(45),
      radians(125),
    ];
    List<RubbishPickerEffect> childBullets = [];
    for (double element in shootAngles) {
      final component = _getChildBulletInstance()
        ..ischildBullet = true
        ..angle = element
        ..position = position
        ..specialEffect1 = false
        ..playerRef = playerRef;
      childBullets.add(component);
    }
    parent!.addAll(childBullets);
  }

  RubbishPickerEffect _getChildBulletInstance() {
    return RubbishPickerEffect(
      Flame.images.fromCache('tools/water-hit-effect-child.png'),
      [WasteType.paper, WasteType.plastic, WasteType.glass],
      frameAmount: 1,
      stepTime: 1,
      frameSize: Vector2(96, 96),
      toolType: 'WasteCollector',
    );
  }
}
