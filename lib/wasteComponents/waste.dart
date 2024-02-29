import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:oceanoasis/property/defaultgameProperty.dart';
import 'package:oceanoasis/property/playerProperty.dart';
import 'package:oceanoasis/routes/gameplay.dart';
import 'package:oceanoasis/tools/slashEffect.dart';
import 'package:oceanoasis/tools/tools.dart';

class Waste extends SpriteComponent
    with CollisionCallbacks, HasGameReference<MyGame> {
  late ShapeHitbox hitbox;
  final _collisionStartColor = Colors.amber;
  final _defaultColor = Colors.green;
  int decayTime;
  final WasteType wasteType;
  double points;
  Map<String, Component> wastechildren;

  //Optional characteristic
  double? density;
  
  Waste({
    required Sprite sprite,
    required this.wasteType,
    required this.points,
    required this.decayTime,
    required this.wastechildren,
  }) : super(sprite: sprite);

  Waste.clone(Waste waste, ComponentKey? key)
      : this(
            sprite: waste.sprite!,
            wasteType: waste.wasteType,
            points: waste.points,
            decayTime: waste.decayTime,
            wastechildren: waste.wastechildren);

  bool startDecay = true;
  @override
  FutureOr<void> onLoad() {
    // TODO: implement onLoad
    final defaultPaint = Paint()
      ..color = _defaultColor
      ..style = PaintingStyle.stroke;
    hitbox = RectangleHitbox()
      ..paint = defaultPaint
      ..renderShape = true
      ..collisionType = CollisionType.passive;
    add(hitbox);

    return super.onLoad();
  }

  @override
  void update(double dt) {
    // TODO: implement update

    super.update(dt);
  }

  @override
  void onMount() {
    // TODO: implement onMount
    decay();
    super.onMount();
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    hitbox.paint.color = _collisionStartColor;

    //when player slashes the waste
    detectSlash(other);
  }

  void detectSlash(PositionComponent other) {
    if (other is SlashEffect) {
      for (WasteType element in other.slashType) {
        if (wasteType == element) {
          collect(game.playerData);
        }
      }
    } else if (other is Tools) {
      for (WasteType element in other.slashType!) {
        if (wasteType == element) {
          collect(game.playerData);
        }
      }
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    // TODO: implement onCollision

    super.onCollision(intersectionPoints, other);
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
    if (!isColliding) {
      hitbox.paint.color = _defaultColor;
    }
  }

  //when player interacts with it, it will be removed and points will be added
  void collect(PlayerProperty player) {
    addAll([
      OpacityEffect.fadeOut(
        EffectController(duration: 1),
        target: this,
        onComplete: () {
          removeFromParent();
          player.addScore(points);
          player.addWasteScore(wasteType);
        },
      ),
    ]);
  }

  void decay() {
    if (isLoaded) {
      if (startDecay) {
        Future.delayed(Duration(seconds: decayTime), () async {
          if (isMounted) {
            removeFromParent();
          }
        });
      }
      startDecay = false;
    }
  }

  void loadPuzzle() {}
  @override
  void onRemove() {
    // TODO: implement onRemove
    super.onRemove();
  }
}
