import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/image_composition.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:flutter/services.dart';
import 'package:oceanoasis/property/defaultgameProperty.dart';
import 'package:oceanoasis/routes/homescreen.dart';
import 'package:oceanoasis/tools/tools.dart';

class OverworldPlayer extends SpriteAnimationComponent
    with HasGameReference<MyGame>, CollisionCallbacks, KeyboardHandler {
  final int playerScene;
  Image image;
  SpriteAnimationData animationData;
  SpriteComponent currentToolIndicator = SpriteComponent.fromImage(
      Flame.images.fromCache('ui/selected-item-ui.png'));

  late final Vector2 _lastSize = size.clone();
  late final Transform2D _lastTransform = transform.clone();
  final _collisionStartColor = Colors.amber;
  final _defaultColor = Colors.cyan;
  final JoystickComponent joystick;
  late ShapeHitbox hitbox;
  int horizontalDirection = 0;
  int verticalDirection = 0;
  final Vector2 velocity = Vector2.zero();
  double moveSpeed = 300;

  Tools currentTool = WeaponProperty.weapons[0]['weapon']!;

  OverworldPlayer({
    required this.joystick,
    required Vector2 position,
    required this.playerScene,
    required this.image,
    required this.animationData,
  }) : super.fromFrameData(image, animationData,
            anchor: Anchor.center, position: position);

  @override
  Future<void> onLoad() async {
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
      position.add(joystick.relativeDelta * moveSpeed * dt);
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

  set setPosition(Vector2 value) {
    position = value;
  }

  void updateCurrentTool(Tools component) {
    if (currentTool.isMounted) {
      currentTool.removeFromParent();
    }
    currentTool = component;
    add(currentTool..scale=Vector2.all(0.5)..position=Vector2.all(20));
  }

  void hitAction() {}
}
