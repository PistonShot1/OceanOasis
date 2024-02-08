import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oceanoasis/homescreen.dart';

class JoystickPlayer extends SpriteAnimationComponent
    with HasGameReference<MyGame>, CollisionCallbacks, KeyboardHandler {
  late final Vector2 _lastSize = size.clone();
  late final Transform2D _lastTransform = transform.clone();
  final int playerScene;
  //Debug variables
  final _collisionStartColor = Colors.amber;
  final _defaultColor = Colors.cyan;
  final JoystickComponent joystick;

  //Hitbox for player
  late ShapeHitbox hitbox;

  //movement variables
  int horizontalDirection = 0;
  int verticalDirection = 0;
  final Vector2 velocity = Vector2.zero();
  final double moveSpeed = 300; //this the speed
  double maxSpeed = 200.0; //ignore this , this for joystick
  final double pushAwaySpeed = 200.0;

  double? playerhealth;
  JoystickPlayer(
      {required this.joystick,
      required Vector2 position,
      required this.playerScene,
      this.playerhealth = 0})
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

  //JUN RONG HERE FOR COLLISION ON PLAYER!!
  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);

    //DEBUG
    hitbox.paint.color = _collisionStartColor;


  }

  @override
  void onCollisionEnd(PositionComponent other) {
    // TODO: implement onCollisionEnd

    //DEBUG
    hitbox.paint.color = _defaultColor;



    super.onCollisionEnd(other);
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    movementKey(keysPressed);
    return true;
  }

  void movementKey(Set<LogicalKeyboardKey> keysPressed) {
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
  }

  set setHealth(double value) {
    playerhealth = value;
  }
}
