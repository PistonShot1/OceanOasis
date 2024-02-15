import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:oceanoasis/components/joystickplayer.dart';
import 'package:oceanoasis/homescreen.dart';
import 'package:oceanoasis/tools/slashEffect.dart';

class NewsPaper extends SpriteComponent
    with CollisionCallbacks, TapCallbacks, HasGameReference<MyGame> {
  late ShapeHitbox hitbox;
  final _collisionStartColor = Colors.amber;
  final _defaultColor = Colors.green;
  static double points = 5;
  static String id = 'Paper';
  NewsPaper({required Vector2 position})
      : super.fromImage(Flame.images.fromCache('waste/newspaper.png'),
            position: position, size: Vector2.all(64));

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
    if (isLoaded) {
      if (startDecay) {
        Future.delayed(const Duration(seconds: 5), () async {
          decay();
        });
      }
      startDecay = false;
    }
    super.update(dt);
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
          player.addLoad(NewsPaper.points);
        },
      ),
    ]);
  }

  @override
  void onTapUp(TapUpEvent event) {
    // TODO: implement onTapUp
    collect(game.player);
    removeFromParent();
    super.onTapUp(event);
  }

  void decay() {
    if (isMounted) {
      removeFromParent();
    }
  }

  void loadPuzzle() {}
}
