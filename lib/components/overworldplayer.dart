import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/image_composition.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:flutter/services.dart';
import 'package:oceanoasis/routes/homescreen.dart';

class OverworldPlayer extends SpriteAnimationComponent
    with HasGameReference<MyGame>, CollisionCallbacks, KeyboardHandler {
  final int playerScene;
  Image image;
  SpriteAnimationData animationData;
  SpriteAnimationComponent? body;

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

  OverworldPlayer({
    required this.joystick,
    required Vector2 position,
    required this.playerScene,
    required this.image,
    required this.animationData,
    required Vector2 size,
  }) : body = SpriteAnimationComponent.fromFrameData(
             image,
            animationData,
            size: size,
            anchor: Anchor.center,
            position: position);

  @override
  Future<void> onLoad() async {
    
    add(body!);
    //--- FOR DEBUG---
    final defaultPaint = Paint()
      ..color = _defaultColor
      ..style = PaintingStyle.stroke;
    //-----
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

    if (horizontalDirection < 0 && body!.scale.x > 0) {
      body!.flipHorizontally();
    } else if (horizontalDirection > 0 && body!.scale.x < 0) {
      body!.flipHorizontally();
    }
    super.update(dt);
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    // TODO: implement onCollisionStart
    super.onCollisionStart(intersectionPoints, other);
    hitbox.paint.color = _collisionStartColor;
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
