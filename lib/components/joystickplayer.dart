import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/image_composition.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:flutter/services.dart';
import 'package:oceanoasis/homescreen.dart';
import 'package:oceanoasis/property/defaultgameProperty.dart';
import 'package:oceanoasis/tools/papercollector.dart';
import 'package:oceanoasis/wasteComponents/newspaper.dart';
import 'dart:math';

class JoystickPlayer extends SpriteAnimationComponent
    with HasGameReference<MyGame>, CollisionCallbacks, KeyboardHandler {
  late final Vector2 _lastSize = size.clone();
  late final Transform2D _lastTransform = transform.clone();
  final int playerScene;

  Image image;
  SpriteAnimationData animationData;
  SpriteAnimationComponent? body;
  SpriteAnimation? hitAnimation;
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
  bool isHitAnimationPlaying = false;

  String curfacingdirection = 'East';
  Map<LogicalKeyboardKey, String> keyfacingDirections = {
    LogicalKeyboardKey.keyA: 'West',
    LogicalKeyboardKey.keyD: 'East'
  };
  //player properties
  double? playerhealth;
  ValueNotifier<double> currentLoad = ValueNotifier<double>(0);
  double? maxLoad;

  //Inventory & tools
  Map<String, SpriteComponent>? playerInventory;
  PaperCollector currentTool = ToolSlashProperty.toolIcon[0]['tool']!; //default tool , need to see user data/state

  JoystickPlayer(
      {required this.joystick,
      required Vector2 position,
      required this.playerScene,
      required this.image,
      required this.animationData,
      this.playerhealth = 0})
      : body = SpriteAnimationComponent.fromFrameData(image, animationData,
            size: Vector2.all(128), anchor: Anchor.center, position: position);

  @override
  Future<void> onLoad() async {
    playerInventory = {
      'tool1': PaperCollector(
        sprite: Sprite(Flame.images.fromCache('tools/tool1.png')),
        size: Vector2.all(32),
        position: Vector2(-16, 24),
      )..anchor = Anchor.center,
      'tool2': PaperCollector(
          sprite: Sprite(Flame.images.fromCache('tools/tool2.png')),
          position: Vector2(-16, 24),
          size: Vector2.all(32))
        ..anchor = Anchor.center,
      'tool3': PaperCollector(
          sprite: Sprite(Flame.images.fromCache('tools/tool3.png')),
          position: Vector2(-16, 24),
          size: Vector2.all(32))
        ..anchor = Anchor.center
    };
    //FOR DEBUG
    hitAnimation = SpriteAnimation.fromFrameData(
        Flame.images.fromCache('main-character-1/Attack.png'),
        SpriteAnimationData.sequenced(
            amount: 6, // Number of frames in your animation
            stepTime: 0.1, // Duration of each frame
            textureSize: Vector2(48, 48)));
    final defaultPaint = Paint()
      ..color = _defaultColor
      ..style = PaintingStyle.stroke;
    hitbox = RectangleHitbox()
      ..paint = defaultPaint //FOR DEBUG
      ..renderShape = true;
    add(body!);
    body!.add(hitbox);

    //Current Tool held
    add(currentTool);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!joystick.delta.isZero() && activeCollisions.isEmpty) {
      // print(joystick.delta);
      // print(joystick.delta.screenAngle());

      print('Angle ${joystick.delta.screenAngle() * 180 / pi}');
      _lastSize.setFrom(size);
      _lastTransform.setFrom(transform);
      position.add(joystick.relativeDelta * maxSpeed * dt);
      // angle = joystick.delta.screenAngle();
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
    if (other is NewsPaper) {
      // other.collect(this);
    }
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
    trackFacingDirection(keysPressed);
    hitAction(keysPressed);
    return true;
  }

  void hitAction(Set<LogicalKeyboardKey> keysPressed) {
    if (keysPressed.contains(LogicalKeyboardKey.keyH) &&
        !isHitAnimationPlaying) {
      isHitAnimationPlaying = true;
      body?.animation = hitAnimation;
      add(currentTool.slashEffect!
        ..anchor = Anchor.center
        ..size = Vector2.all(64)
        ..position = Vector2(60, 0));

      Future.delayed(const Duration(milliseconds: 100 * 6), () {
        //reset back to original position after attack animation finish
        body?.animation = SpriteAnimation.fromFrameData(image, animationData);
        //remove slash effect upon complete slashing animation
        remove(currentTool.slashEffect!);
        isHitAnimationPlaying = false;
      });
    }
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

  void addLoad(double value) {
    currentLoad.value += value;
  }

  set setPosition(Vector2 value) {
    position = value;
  }

  set setSpeed(double speed) {
    speed = speed;
  }

  set setImage(Image image) {
    image = image;
  }

  set setanimationData(SpriteAnimationData animationData) {
    animationData = animationData;
  }

  set setBody(SpriteAnimationComponent data) {
    body = data;
  }

  //TODO : This logic works atm but check later
  void setCurrentTool(PaperCollector component) {
    remove(currentTool);
    currentTool = component;
    add(currentTool);
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
}
