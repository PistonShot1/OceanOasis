import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:oceanoasis/components/maps/underwater/underwater_scene.dart';
import 'package:oceanoasis/property/game_properties.dart';
import 'package:oceanoasis/property/player_property.dart';
import 'package:oceanoasis/my_game.dart';
import 'package:oceanoasis/components/shoptools/slash_effect.dart';
import 'package:oceanoasis/components/shoptools/tools.dart';

class Waste extends SpriteComponent
    with CollisionCallbacks, HasGameReference<MyGame> {
  late ShapeHitbox hitbox;
  final _collisionStartColor = Colors.amber;
  final _defaultColor = Colors.green;
  int decayTime;
  final WasteType wasteType;

  final UnderwaterScene? sceneRef;

  double points;
  Map<String, Component> wastechildren;

  //Optional characteristic
  double? density;
  final moveEffect = MoveEffect.by(
    Vector2(0, -25),
    EffectController(duration: 1, reverseDuration: 1, infinite: true),
  );
  Waste({
    required Sprite sprite,
    required this.wasteType,
    required this.points,
    required this.decayTime,
    required this.wastechildren,
    this.sceneRef,
  }) : super(sprite: sprite);

  Waste.clone(Waste waste, ComponentKey? key, UnderwaterScene sceneRef)
      : this(
            sprite: waste.sprite!,
            wasteType: waste.wasteType,
            points: waste.points,
            decayTime: waste.decayTime,
            wastechildren: waste.wastechildren,
            sceneRef: sceneRef);

  bool startDecay = true;

  @override
  FutureOr<void> onLoad() {
    // TODO: implement onLoad
    hitbox = CircleHitbox()
      ..collisionType = CollisionType.passive;
    scale = Vector2.all(0.6);
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
    add(moveEffect);
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
          hitbox.collisionType = CollisionType.inactive;
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
          player.addScore();
          player.addplayerWasteScore(wasteType);

          player.addlevelScore();
          player.addlevelWasteScore(wasteType);
        },
      ),
    ]);
  }

  void decay() {
    if (isLoaded) {
      if (startDecay) {
        Future.delayed(Duration(seconds: decayTime), () async {
          if (isMounted) {
            if (sceneRef != null) {
              (sceneRef!.currentacidityLevel < sceneRef!.maxacidityLevel)
                  ? sceneRef?.currentacidityLevel += 5
                  : '';
            }
            removeFromParent();
          }
        });
        // Future.doWhile(() async {
        //   if (decayTime > 0) {
        //     await Future.delayed(Duration(seconds: 1), () {
        //       decayTime--;
        //     });
        //     return true;
        //   } else {
        //     removeFromParent();
        //     return false;
        //   }
        // });
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

  @override
  void render(Canvas canvas) {
    // TODO: implement render
    super.render(canvas);
  }
}
