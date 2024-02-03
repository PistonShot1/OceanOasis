import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oceanoasis/homescreen.dart';

class JoystickPlayer extends SpriteAnimationComponent
    with HasGameReference<MyGame>, CollisionCallbacks, KeyboardHandler {
  double maxSpeed = 200.0;
  late final Vector2 _lastSize = size.clone();
  late final Transform2D _lastTransform = transform.clone();
  final _collisionStartColor = Colors.amber;
  final _defaultColor = Colors.cyan;
  final JoystickComponent joystick;
  late ShapeHitbox hitbox;
  int horizontalDirection = 0;
  int verticalDirection = 0;
  final Vector2 velocity = Vector2.zero();
  final double moveSpeed = 100;
  final double pushAwaySpeed = 200.0; // Adjust based on your preference

  JoystickPlayer(this.joystick, Vector2 position)
      : super.fromFrameData(
            Flame.images.fromCache('character2-swim1.png'),
            SpriteAnimationData.sequenced(
                amount: 6, // Number of frames in your animation
                stepTime: 0.15, // Duration of each frame
                textureSize: Vector2(48, 48)),
            size: Vector2.all(80),
            anchor: Anchor.center,
            position: position);

  @override
  Future<void> onLoad() async {
    //FOR DEBUG
    final defaultPaint = Paint()
      ..color = _defaultColor
      ..style = PaintingStyle.stroke;
    hitbox = RectangleHitbox()
      ..paint = defaultPaint //FOR DEBUG
      ..renderShape = true;
    add(hitbox);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!joystick.delta.isZero() && activeCollisions.isEmpty) {
      _lastSize.setFrom(size);
      _lastTransform.setFrom(transform);
      position.add(joystick.relativeDelta * maxSpeed * dt);
      angle = joystick.delta.screenAngle();
    }

    velocity.x = horizontalDirection * moveSpeed;
    velocity.y = verticalDirection * moveSpeed;
    position += velocity * dt;

    if (horizontalDirection < 0 && scale.x > 0) {
      flipHorizontally();
    } else if (horizontalDirection > 0 && scale.x < 0) {
      flipHorizontally();
    }
    super.update(dt);
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    // TODO: implement onCollisionStart
    super.onCollisionStart(intersectionPoints, other);
    hitbox.paint.color = _collisionStartColor;
    // print(intersectionPoints);d
    // // Calculate the collision normal (direction away from the collision)
    // final collisionNormal = (position - other.position).normalized();

    // // Set the new velocity away from the collision
    // velocity.setFrom(collisionNormal * pushAwaySpeed);

    // // Optionally, you can adjust the position slightly to avoid immediate re-collision
    // position += collisionNormal * 10;
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    horizontalDirection = 0;
    verticalDirection = 0;
    horizontalDirection += (keysPressed.contains(LogicalKeyboardKey.keyA) ||
            keysPressed.contains(LogicalKeyboardKey.arrowLeft))
        ? -1
        : 0;
    horizontalDirection += (keysPressed.contains(LogicalKeyboardKey.keyD) ||
            keysPressed.contains(LogicalKeyboardKey.arrowRight))
        ? 1
        : 0;
    verticalDirection += (keysPressed.contains(LogicalKeyboardKey.keyW) ||
            keysPressed.contains(LogicalKeyboardKey.arrowUp))
        ? -1
        : 0;
    verticalDirection += (keysPressed.contains(LogicalKeyboardKey.keyS) ||
            keysPressed.contains(LogicalKeyboardKey.arrowDown))
        ? 1
        : 0;
    return true;
  }
}
