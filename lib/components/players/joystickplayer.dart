import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/geometry.dart';
import 'package:flame/image_composition.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:flutter/services.dart';
import 'package:oceanoasis/routes/gameplay.dart';
import 'package:oceanoasis/property/defaultgameProperty.dart';
import 'package:oceanoasis/tools/tools.dart';
import 'dart:math';

class JoystickPlayer extends SpriteAnimationComponent
    with HasGameReference<MyGame>, CollisionCallbacks, KeyboardHandler {
  late final Vector2 _lastSize = size.clone();
  late final Transform2D _lastTransform = transform.clone();
  final int playerScene;

  SpriteComponent currentToolIndicator = SpriteComponent.fromImage(
      Flame.images.fromCache('ui/selected-item-ui.png'));

  Image swimimage;
  SpriteAnimationData swimanimationData;
  // SpriteAnimationComponent?
  //     idle; //Note : acts as the 'body' (the main character spriteanimationcomponent)
  SpriteAnimation? hitAnimation;
  SpriteAnimation? breathingAnimation;
  //Debug variables
  final _collisionStartColor = Colors.amber;
  final _defaultColor = Colors.cyan;
  final JoystickComponent joystick;

  //Hitbox for player
  late ShapeHitbox
      hitbox; //Note : hitbox is added to SpriteAnimationComponent (idle) instead of to the Joystickplayer, for better accuracy (so collision functions should be handled on the other object)

  //movement variables
  double horizontalDirection = 0;
  double verticalDirection = 0;
  Vector2 velocity = Vector2.zero();
  double moveSpeed = 300; //this the speed
  final double pushAwaySpeed = 200.0;
  bool isHitAnimationPlaying = false;
  List<double> movementBoundary = [];

  //Facing direction
  String curfacingdirection = 'East';
  Map<LogicalKeyboardKey, String> keyfacingDirections = {
    LogicalKeyboardKey.keyA: 'West',
    LogicalKeyboardKey.keyD: 'East'
  };

  //player properties
  ValueNotifier<double> currentLoad = ValueNotifier<double>(0);
  double? maxLoad;
  int breathingSeconds = 10;
  int maxbreathingDuration = 10;
  double playerHealth = 3;
  //Inventory & tools

  Tools currentTool = ToolSlashProperty.toolIcon[0]
      ['tool']!; //default tool , need to see user data/state
  PositionComponent currentToolOrigin = PositionComponent();
  //High tide event variable
  List<double> highTideSlower = [
    1,
    1,
    1,
    1
  ]; //effect for each : left,right,up,down

  JoystickPlayer({
    required this.joystick,
    required Vector2 position,
    required this.playerScene,
    required this.swimimage,
    required this.swimanimationData,
    this.hitAnimation,
    this.breathingAnimation,
  }) : super.fromFrameData(swimimage, swimanimationData,
            anchor: Anchor.center, position: position);

  @override
  Future<void> onLoad() async {
    //FOR DEBUG

    hitbox = RectangleHitbox();
    add(hitbox);

    //Current Tool held
    if (playerScene == 0) {
      add(currentToolOrigin
        ..position = Vector2(
            size.x / sqrt(pow(scale.x, 2)), size.y / sqrt(pow(scale.y, 2))));
      updateCurrentTool(currentTool);
    }
  }

  @override
  void onMount() {
    // TODO: implement onMount

    super.onMount();
  }

  @override
  void update(double dt) {
    super.update(dt);
    //Movement for joystick
    if (movementBoundary.isNotEmpty) {
      position.x = position.x.clamp(movementBoundary[0], movementBoundary[1]);
      position.y = position.y.clamp(movementBoundary[2], movementBoundary[3]);
    }

    if (!joystick.delta.isZero() && activeCollisions.isEmpty) {
      // print(joystick.delta);
      // print(joystick.delta.screenAngle());
      print('Angle ${joystick.delta.screenAngle() * 180 / pi}');
      _lastSize.setFrom(size);
      _lastTransform.setFrom(transform);
      position.add(joystick.relativeDelta * moveSpeed * dt);
      // angle = joystick.delta.screenAngle();
    }

    //Movement for WASD
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
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    // TODO: implement onKeyEvent
    hitAction(keysPressed);
    if (!isHitAnimationPlaying) {
      movementKey(keysPressed);
      // trackFacingDirection(keysPressed);
    }
    return super.onKeyEvent(event, keysPressed);
  }

  void hitAction(Set<LogicalKeyboardKey> keysPressed) {
    if (keysPressed.contains(LogicalKeyboardKey.space) &&
        !isHitAnimationPlaying) {
      //on hit animation , reset velocity, horizontal and vertical direction (to avoid movement while on hit animation)
      isHitAnimationPlaying = true;
      velocity = Vector2.zero();
      horizontalDirection = 0;
      verticalDirection = 0;
      // animation = hitAnimation;

      currentToolOrigin.add(
          RotateEffect.by(tau, EffectController(duration: 0.5), onComplete: () {
        isHitAnimationPlaying = false;
      }));

      add(currentTool.slashEffect!
        ..anchor = Anchor.center
        ..size = Vector2.all(64)
        ..position = Vector2(100, 0));

      // Future.delayed(const Duration(milliseconds: 600), () {
      //   //reset back to original position after attack animation finish
      //   animation = SpriteAnimation.fromFrameData(swimimage, swimanimationData);

      //   isHitAnimationPlaying = false;
      // });
    }
  }

  void movementKey(Set<LogicalKeyboardKey> keysPressed) {
    horizontalDirection = 0;
    verticalDirection = 0;
    horizontalDirection += (keysPressed.contains(LogicalKeyboardKey.keyA) ||
            keysPressed.contains(LogicalKeyboardKey.arrowLeft))
        ? (-1 * highTideSlower[0])
        : 0;
    horizontalDirection += (keysPressed.contains(LogicalKeyboardKey.keyD) ||
            keysPressed.contains(LogicalKeyboardKey.arrowRight))
        ? (1 * highTideSlower[1])
        : 0;
    verticalDirection += (keysPressed.contains(LogicalKeyboardKey.keyW) ||
            keysPressed.contains(LogicalKeyboardKey.arrowUp))
        ? (-1 * highTideSlower[2])
        : 0;
    verticalDirection += (keysPressed.contains(LogicalKeyboardKey.keyS) ||
            keysPressed.contains(LogicalKeyboardKey.arrowDown))
        ? (1 * highTideSlower[3])
        : 0;
  }

  void addLoad(double value) {
    currentLoad.value += value;
  }

  set setPosition(Vector2 value) {
    position = value;
  }

  set setSpeed(double speed) {
    moveSpeed = speed;
  }

  set setImage(Image image) {
    image = image;
  }

  set setanimationData(SpriteAnimationData animationData) {
    animationData = animationData;
  }

  set setbreathingSeconds(int value) {
    breathingSeconds = value;
  }

  set setPlayerHealth(double value) {
    playerHealth = value;
  }

  void setMovementBoundary(
      {required double maxX,
      required double minX,
      required double maxY,
      required double minY}) {
    movementBoundary = [minX, maxX, minY, maxY];
  }

  void updateCurrentTool(Tools component) {
    if (currentTool.isMounted) {
      currentTool.removeFromParent();
    }
    currentTool = component;

    currentToolOrigin.add(currentTool..angle = pi * 0.25);
  }

  void trackFacingDirection(Set<LogicalKeyboardKey> keysPressed) {
    if (keysPressed.contains(LogicalKeyboardKey.keyA) ||
        keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
      curfacingdirection = keyfacingDirections[LogicalKeyboardKey.keyA]!;
    } else if (keysPressed.contains(LogicalKeyboardKey.keyD) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
      curfacingdirection = keyfacingDirections[LogicalKeyboardKey.keyD]!;
    }
  }

  @override
  void onRemove() {
    // TODO: implement onRemove

    super.onRemove();
  }
}
