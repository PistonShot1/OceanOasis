import 'dart:io';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/geometry.dart';
import 'package:flame/image_composition.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:flutter/services.dart';
import 'package:oceanoasis/components/maps/underwater/events/longswordfish.dart';
import 'package:oceanoasis/components/maps/underwater/playerhealth.dart';
import 'package:oceanoasis/components/maps/underwater/inputAttack.dart';
import 'package:oceanoasis/components/maps/underwater/underwater_scene.dart';
import 'package:oceanoasis/my_game.dart';
import 'package:oceanoasis/property/defaultgameProperty.dart';
import 'package:oceanoasis/components/shoptools/slash_effect.dart';
import 'package:oceanoasis/components/shoptools/tools.dart';
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
  bool isHitAnimationPlaying =
      false; //this variables acts as pause flag to stop spamming on hit action
  List<double> movementBoundary = [];

  //Facing direction
  String curfacingdirection = 'East';
  Map<LogicalKeyboardKey, String> keyfacingDirections = {
    LogicalKeyboardKey.keyA: 'West',
    LogicalKeyboardKey.keyD: 'East'
  };
  double facingDirectionnum = 1;

  //player properties
  double? maxLoad;
  int breathingSeconds = 10;
  int maxbreathingDuration = 10;
  PlayerHealth playerHealth = PlayerHealth(health: 3);
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

  bool playerVulnerability = true;

  UnderwaterScene sceneRef;
  JoystickPlayer({
    required this.joystick,
    required Vector2 position,
    required this.playerScene,
    required this.swimimage,
    required this.swimanimationData,
    required this.sceneRef,
    this.hitAnimation,
    this.breathingAnimation,
  }) : super.fromFrameData(swimimage, swimanimationData,
            anchor: Anchor.center, position: position);

  @override
  Future<void> onLoad() async {
    //FOR DEBUG

    hitbox = CircleHitbox(radius: 10, position: size * 0.5);
    add(hitbox);

    //Current Tool held
    if (playerScene == 0) {
      add(currentToolOrigin
        ..position = Vector2(
            size.x / sqrt(pow(scale.x, 2)), size.y / sqrt(pow(scale.y, 2))));
      updateCurrentTool(currentTool);
    }

    if (Platform.isAndroid || Platform.isIOS) {
      game.camera.viewport.add(AttackInput(playerRef: this)
        ..position = sceneRef.tiledMap.size - Vector2.all(200));
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

    if (movementBoundary.isNotEmpty) {
      position.x = position.x.clamp(movementBoundary[0], movementBoundary[1]);
      position.y = position.y.clamp(movementBoundary[2], movementBoundary[3]);
    }
    //Movement for WASD
    velocity.x = horizontalDirection * moveSpeed;
    velocity.y = verticalDirection * moveSpeed;
    position += velocity * dt;

    if (horizontalDirection < 0 && scale.x > 0) {
      flipHorizontally();
      facingDirectionnum = facingDirectionnum * -1;
    } else if (horizontalDirection > 0 && scale.x < 0) {
      flipHorizontally();
      facingDirectionnum = facingDirectionnum * -1;
    }

    //Movement for Joystick
    if (!joystick.delta.isZero()) {
      // print(joystick.delta);
      // print(joystick.delta.screenAngle());
      if ((joystick.direction == JoystickDirection.left ||
              joystick.direction == JoystickDirection.upLeft ||
              joystick.direction == JoystickDirection.downLeft) &&
          scale.x > 0) {
        flipHorizontally();
        facingDirectionnum = facingDirectionnum * -1;
      } else if ((joystick.direction == JoystickDirection.right ||
              joystick.direction == JoystickDirection.upRight ||
              joystick.direction == JoystickDirection.downRight) &&
          scale.x < 0) {
        flipHorizontally();
        facingDirectionnum = facingDirectionnum * -1;
      }
      print('Angle ${joystick.delta.screenAngle() * 180 / pi}');
      _lastSize.setFrom(size);
      _lastTransform.setFrom(transform);
      position.add(joystick.relativeDelta * moveSpeed * dt);
      // angle = joystick.delta.screenAngle();
    }

    super.update(dt);
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

  void hitAction(Set<LogicalKeyboardKey>? keysPressed) {
    // print('Current facing direciton : $facingDirectionnum');
    bool condition = false;
    if (Platform.isWindows || Platform.isMacOS) {
      (keysPressed!.contains(LogicalKeyboardKey.space) &&
              !isHitAnimationPlaying)
          ? condition = true
          : condition = false;
    } else if (Platform.isAndroid || Platform.isIOS) {
      (!isHitAnimationPlaying) ? condition = true : condition = false;
    }
    if (condition) {
      //on hit animation , reset velocity, horizontal and vertical direction (to avoid update on position on long press)
      isHitAnimationPlaying = true;
      velocity = Vector2.zero();
      horizontalDirection = 0;
      verticalDirection = 0;
      currentToolOrigin.add(
          RotateEffect.by(tau, EffectController(duration: 0.1), onComplete: () {
        isHitAnimationPlaying = false;
        currentTool.hitbox.collisionType = CollisionType.inactive;
      }));

      if (currentTool.slashEffect != null) {
        final component = SlashEffect.createInstance(
            slashEffect: currentTool.slashEffect!, playerRef: this)
          ..anchor = Anchor.center
          ..position = position;
        (facingDirectionnum < 0) ? component.flipHorizontally() : '';
        parent!.add(component); //Parent is component with underwaterworld
      }
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
    playerHealth.health = value;
  }

  void hit(double value) {
    if (playerVulnerability) {
      playerVulnerability = false;
      game.camera.viewport.remove(playerHealth);
      playerHealth = PlayerHealth(health: playerHealth.health - value);

      Future.delayed(const Duration(seconds: 1), () {
        playerVulnerability = true;
      });
      final effect = ColorEffect(
        Colors.red,
        EffectController(duration: 0.5, alternate: true, repeatCount: 1),
      );

      effect.onComplete = () {
        effect.reset();
      };

      add(effect);
      // effect.reset();
      game.camera.viewport.add(playerHealth);
    }
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
