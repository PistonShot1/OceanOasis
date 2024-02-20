import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/image_composition.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:oceanoasis/components/joystickplayer.dart';
import 'package:oceanoasis/routes/homescreen.dart';
import 'package:oceanoasis/tools/slashEffect.dart';

class Waste extends SpriteComponent
    with CollisionCallbacks, HasGameReference<MyGame> {
  late ShapeHitbox hitbox;
  final _collisionStartColor = Colors.amber;
  final _defaultColor = Colors.green;
  int decayTime;
  final String id;
  double points;
  bool lastWaste =
      false; // default is false (this is a helper variable to detect last spawn in the tree)
  Waste({
    required Sprite sprite,
    required this.id,
    required this.points,
    required this.decayTime,
    ComponentKey? key,
  }) : super(sprite: sprite, size: Vector2.all(64), key: key);

  Waste.clone(Waste waste, ComponentKey? key)
      : this(
            sprite: waste.sprite!,
            id: waste.id,
            points: waste.points,
            decayTime: waste.decayTime,
            key: key);

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

    // add(MoveByEffect(
    //   Vector2(0, -10),
    //   EffectController(duration: 0.5, infinite: true),
    // ));
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
    if (other is SlashEffect && other.id.compareTo(id) == 0) {
      collect(game.player);
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
  void collect(JoystickPlayer player) {
    addAll([
      OpacityEffect.fadeOut(
        EffectController(duration: 1),
        target: this,
        onComplete: () {
          removeFromParent();
          player.addLoad(this.points);
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
  // Waste clone() {
  //   Waste newComponent =
  //       Waste(sprite: this.sprite!, id: this.id, points: this.points);
  //   return newComponent;
  // }
}