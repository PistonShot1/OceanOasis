import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart' hide Route;
import 'package:oceanoasis/components/joystickplayer.dart';
import 'package:oceanoasis/homescreen.dart';
import 'package:oceanoasis/maps/pacific.dart';
import 'package:oceanoasis/maps/pacificunderwater.dart';

class Whirlpool extends PositionComponent
    with HasGameReference<MyGame>, CollisionCallbacks {
  final _collisionStartColor = Colors.amber;
  final _defaultColor = Colors.black;
  late ShapeHitbox hitbox;

  Whirlpool(Vector2 position, Vector2 size)
      : super(
          position: position,
          size: size,
          anchor: Anchor.topLeft,
        );

  @override
  Future<void> onLoad() async {
    //For debug
    final defaultPaint = Paint()
      ..color = _defaultColor
      ..style = PaintingStyle.stroke;
    //add hitbox as child
    hitbox = RectangleHitbox()
      ..paint = defaultPaint
      ..renderShape = true;
    add(hitbox);
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    hitbox.paint.color = _collisionStartColor;

    if (other is JoystickPlayer) {
      print('player trying to enter whirlpool');
      
      game.router.pushReplacement(
          Route(() => PacificOceanUnderwater(
              key: ComponentKey.named(PacificOceanUnderwater.id))),
          name: PacificOceanUnderwater.id);
    }
    //Navigate into underwater
  }

  @override
  void update(double dt) {
    // TODO: implement update
    // if (game.findByKeyName(PacificOcean.id) != null) {
    //   if (game.findByKeyName(PacificOcean.id)!.isLoading) {}
    // }
    super.update(dt);
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
    if (!isColliding) {
      hitbox.paint.color = _defaultColor;
    }
  }
}
