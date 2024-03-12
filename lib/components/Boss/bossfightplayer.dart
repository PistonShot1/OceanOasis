import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/image_composition.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:flutter/services.dart';
import 'package:oceanoasis/components/Boss/playerBar.dart';
import 'package:oceanoasis/property/defaultgameProperty.dart';
import 'package:oceanoasis/routes/gameplay.dart';
import 'package:oceanoasis/tools/tools.dart';

class BossFightPlayer extends SpriteAnimationComponent
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
  late int facingDirection = 1;
  int horizontalDirection = 0;
  int verticalDirection = 0;
  final Vector2 velocity = Vector2.zero();
  double moveSpeed = 300;

  late final World currentWorld;

  double currentHealth = 100;
  final double maxHealth = 100;

  late bool canDamage = true;

  Tools currentTool = WeaponProperty.weapons[0]['weapon']!;

  double currentEnergyLevel = 0;
  final double MaxEnergyLevel = 100;

  List<double> playerBoundary = [];

  final takeDamageEffect = SequenceEffect([
    ColorEffect(
      const Color(0x00FF0000),
      EffectController(duration: 1),
      opacityFrom: 0,
      opacityTo: 0.8,
    ),
    ColorEffect(
      const Color(0x00FF0000),
      EffectController(duration: 1),
      opacityTo: 0,
    ),
  ]);

  final chargeEnergyEffect = SequenceEffect([
    ColorEffect(
      Color.fromARGB(255, 2, 27, 255),
      EffectController(duration: 1),
      opacityFrom: 0,
      opacityTo: 0.8,
    ),
    ColorEffect(
      Color.fromARGB(255, 0, 60, 255),
      EffectController(duration: 1),
      opacityTo: 0,
    ),
  ]);

  BossFightPlayer({
    required this.currentWorld,
    required this.joystick,
    required Vector2 position,
    required this.playerScene,
    required this.image,
    required this.animationData,
  }) : super.fromFrameData(image, animationData,
            anchor: Anchor.center, position: position);

  @override
  Future<void> onLoad() async {
    takeDamageEffect.removeOnFinish = false;
    chargeEnergyEffect.removeOnFinish = false;
    add(chargeEnergyEffect);
    add(takeDamageEffect);
    //--- FOR DEBUG---
    final defaultPaint = Paint()
      ..color = _defaultColor
      ..style = PaintingStyle.stroke;
    //-----

    hitbox = CircleHitbox.relative(0.8, parentSize: size);
    add(hitbox);
  }

  @override
  void onMount() {
    add(PlayerBar(position: Vector2(0, -20), playerRef: this));
    super.onMount();
  }

  @override
  void update(double dt) {
    if (currentHealth < 0) {
      gameOver();
    }
    if (playerBoundary.isNotEmpty) {
      position.x = position.x.clamp(playerBoundary[0], playerBoundary[1]);
      position.y = position.y.clamp(playerBoundary[2], playerBoundary[3]);
    }

    if (!joystick.delta.isZero()) {
      _lastSize.setFrom(size);
      _lastTransform.setFrom(transform);
      position.add(joystick.relativeDelta * moveSpeed * dt);
    }

    velocity.x = horizontalDirection * moveSpeed;
    velocity.y = verticalDirection * moveSpeed;
    position += velocity * dt;

    if (horizontalDirection < 0 && scale.x > 0) {
      flipHorizontally();
      facingDirection = -1;
    } else if (horizontalDirection > 0 && scale.x < 0) {
      flipHorizontally();
      facingDirection = 1;
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
    add(currentTool
      ..scale = Vector2.all(0.5)
      ..position = Vector2.all(20));
    add(currentTool
      ..scale = Vector2.all(0.5)
      ..position = Vector2.all(20));
  }

  void hitAction() {}

  Vector2 getPlayerPosition() {
    return super.position;
  }

  void takeDamage(double damage) {
    currentHealth = currentHealth - damage;
    // ignore: avoid_print
    print(currentHealth);
    takeDamageEffect.reset();
  }

  void gameOver() {
    // ignore: avoid_print
    print("game end");
    super.removeFromParent();
  }

  void chargeEnergy(double energy) {
    chargeEnergyEffect.reset();
    currentEnergyLevel = currentEnergyLevel + energy;

    // ignore: avoid_print
    print(currentEnergyLevel);
  }

  set setPlayerBoundary(List<double> list) {
    playerBoundary = list;
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    // TODO: implement onKeyEvent
    movementKey(keysPressed);
    return super.onKeyEvent(event, keysPressed);
  }
}
