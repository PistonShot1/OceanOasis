import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:oceanoasis/routes/gameplay.dart';

class RectangleCollidable extends PositionComponent
    with CollisionCallbacks, HasGameReference<MyGame> {
  final _collisionStartColor = Colors.amber;
  final _defaultColor = Colors.red;
  final bool _camerafollow;
  late ShapeHitbox hitbox;

  RectangleCollidable(
    Vector2 position,
    Vector2 size,
    this._camerafollow,
  ) : super(
          position: position,
          size: size,
          anchor: Anchor.topLeft,
        );

  @override
  Future<void> onLoad() async {
    final defaultPaint = Paint()
      ..color = _defaultColor
      ..style = PaintingStyle.stroke;
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
}
