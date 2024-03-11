import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/image_composition.dart';
import 'package:flame/particles.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/src/services/hardware_keyboard.dart';
import 'package:flutter/src/services/keyboard_key.g.dart';
import 'package:oceanoasis/maps/overworld/collision_block.dart';
import 'package:oceanoasis/maps/overworld/custom_hitbox.dart';
import 'package:oceanoasis/maps/overworld/ladder.dart';
import 'package:oceanoasis/maps/overworld/utils.dart';
import 'package:oceanoasis/routes/gameplay.dart';

enum PlayerState {
  idle,
  running,
  jumping,
  falling,
  hit,
  appearing,
  disappearing,
  climbing
}

class OverworldPlayer extends SpriteAnimationGroupComponent
    with HasGameReference<MyGame>, KeyboardHandler, CollisionCallbacks {
  late JoystickComponent joystick;
  late final Vector2 _lastSize = size.clone();
  late final Transform2D _lastTransform = transform.clone();
  OverworldPlayer({
    required this.joystick,
    position,
  }) : super(position: position);

  final double stepTime = 0.05;
  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;
  late final SpriteAnimation climbingAnimation;
  // late final SpriteAnimation hitAnimation;

  final double _gravity = 200;
  final double _jumpForce = 260;
  final double _terminalVelocity = 300;
  double horizontalMovement = 0;
  double verticalMovement = 0;
  double moveSpeed = 200;
  double climbingSpeed = 100;
  Vector2 startingPosition = Vector2.zero();
  Vector2 velocity = Vector2.zero();
  bool isOnGround = false;
  bool hasJumped = false;
  bool gotHit = false;

  bool canClimb = false;
  bool isClimbing = false;
  bool reachedCheckpoint = false;
  List<CollisionBlock> collisionBlocks = [];
  CustomHitbox hitbox = CustomHitbox(
    offsetX: 0,
    offsetY: 0,
    width: 32,
    height: 20,
  );
  double fixedDeltaTime = 1 / 60;
  double accumulatedTime = 0;

  @override
  FutureOr<void> onLoad() {
    _loadAllAnimations();
    // debugMode = true;

    startingPosition = Vector2(position.x, position.y);

    // add(RectangleHitbox(
    //   position: Vector2(hitbox.offsetX, hitbox.offsetY),
    //   size: Vector2(hitbox.width, hitbox.height),
    // ));

    add(CompositeHitbox(children: [
      RectangleHitbox(
        position: Vector2(hitbox.offsetX, hitbox.offsetY),
        size: Vector2(hitbox.width, hitbox.height),
      ),
      RectangleHitbox(position: Vector2(0, 32), size: Vector2(32, 16))
    ]));
    return super.onLoad();
  }

  @override
  void update(double dt) {
    accumulatedTime += dt;

    while (accumulatedTime >= fixedDeltaTime) {
      if (!gotHit && !reachedCheckpoint) {
        _updatePlayerState();
        _updatePlayerMovement(fixedDeltaTime);
        _checkHorizontalCollisions();

        if (!canClimb) {
          _applyGravity(fixedDeltaTime);
          _checkVerticalCollisions();
        }
      }

      accumulatedTime -= fixedDeltaTime;
    }

    super.update(dt);
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    horizontalMovement = 0;
    verticalMovement = 0;
    final isLeftKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyA) ||
        keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    final isRightKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyD) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight);

    horizontalMovement += isLeftKeyPressed ? -1 : 0;
    horizontalMovement += isRightKeyPressed ? 1 : 0;

    if (canClimb) {
      final isUpKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyW) ||
          keysPressed.contains(LogicalKeyboardKey.arrowUp);
      final isDownKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyS) ||
          keysPressed.contains(LogicalKeyboardKey.arrowDown);
      climbMovement(isUpKeyPressed, isDownKeyPressed);
    }
    return super.onKeyEvent(event, keysPressed); // TODO: implement onKeyEvent
  }


  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    // TODO: implement onCollision
    if (other is LadderComponent) {
      canClimb = true;
      (position.y > other.position.y &&
              position.y < (other.position.y + other.size.y))
          ? isClimbing = true
          : isClimbing = false;
      position.y = position.y
          .clamp(other.position.y - 48, other.position.y + other.size.y - 20);
    }
    super.onCollision(intersectionPoints, other);
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    // TODO: implement onCollisionEnd
    if (other is LadderComponent) {
      canClimb = false;
      isClimbing = false;
    }
    super.onCollisionEnd(other);
  }

  void _loadAllAnimations() {
    idleAnimation = SpriteAnimation.fromFrameData(
        Flame.images.fromCache('main-character-1/Idle-2.png'),
        SpriteAnimationData.sequenced(
            amount: 4, stepTime: 0.1, textureSize: Vector2(32, 48)));
    runningAnimation = SpriteAnimation.fromFrameData(
        Flame.images.fromCache('main-character-1/Walk.png'),
        SpriteAnimationData.sequenced(
            amount: 6, stepTime: 0.15, textureSize: Vector2(32, 48)));
    // hitAnimation = _spriteAnimation('Hit', 7)..loop = false;
    climbingAnimation = SpriteAnimation.fromFrameData(
        Flame.images.fromCache('main-character-1/Climb.png'),
        SpriteAnimationData.sequenced(
            amount: 6, stepTime: 0.1, textureSize: Vector2(32, 48)));
    // List of all animations
    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.running: runningAnimation,
      PlayerState.climbing: climbingAnimation
    };

    // Set current animation
    current = PlayerState.idle;
  }

  void _updatePlayerState() {
    PlayerState playerState = PlayerState.idle;

    if (velocity.x < 0 && scale.x > 0) {
      flipHorizontallyAroundCenter();
    } else if (velocity.x > 0 && scale.x < 0) {
      flipHorizontallyAroundCenter();
    }

    if (Platform.isWindows) {
      // Check if moving, set running
      if (velocity.x > 0 || velocity.x < 0) playerState = PlayerState.running;

      // check if Falling set to falling
      if (velocity.y > 0) playerState = PlayerState.idle;

      // Checks if jumping, set to jumping
      if (velocity.y < 0) playerState = PlayerState.idle;
    } else if (Platform.isAndroid) {
      if (!joystick.delta.isZero() &&
          (joystick.direction == JoystickDirection.left ||
              joystick.direction == JoystickDirection.upLeft ||
              joystick.direction == JoystickDirection.downLeft ||
              joystick.direction == JoystickDirection.right ||
              joystick.direction == JoystickDirection.upRight ||
              joystick.direction == JoystickDirection.downRight)) {
        playerState = PlayerState.running;
      } else if (joystick.direction == JoystickDirection.up ||
          joystick.direction == JoystickDirection.down && isClimbing) {
        playerState = PlayerState.climbing;
      }
    }

    if (isClimbing && !isOnGround) playerState = PlayerState.climbing;
    current = playerState;
  }

  void _updatePlayerMovement(double dt) {
    // if (velocity.y > _gravity) isOnGround = false; // optional
    velocity.x = horizontalMovement * moveSpeed;
    position.x += velocity.x * dt;

    if (isClimbing) {
      velocity.y = verticalMovement * climbingSpeed;
      position.y += velocity.y * dt;
    } else {
      velocity.y = verticalMovement * moveSpeed;
      position.y += velocity.y * dt;
    }

    //Movement for Joystick
    if (!joystick.delta.isZero() &&
            joystick.direction != JoystickDirection.upLeft ||
        joystick.direction != JoystickDirection.upRight ||
        joystick.direction != JoystickDirection.downLeft ||
        joystick.direction != JoystickDirection.downRight) {
      // print(joystick.delta);
      // print(joystick.delta.screenAngle());
      if ((joystick.direction == JoystickDirection.left ||
              joystick.direction == JoystickDirection.upLeft ||
              joystick.direction == JoystickDirection.downLeft) &&
          scale.x > 0) {
        flipHorizontally();
      } else if ((joystick.direction == JoystickDirection.right ||
              joystick.direction == JoystickDirection.upRight ||
              joystick.direction == JoystickDirection.downRight) &&
          scale.x < 0) {
        flipHorizontally();
      }

      _lastSize.setFrom(size);
      _lastTransform.setFrom(transform);
      position.add(joystick.relativeDelta * moveSpeed * dt);
      // angle = joystick.delta.screenAngle();
    }
  }

  void _checkHorizontalCollisions() {
    for (final block in collisionBlocks) {
      if (!block.isPlatform) {
        if (checkCollision(this, block)) {
          if (velocity.x > 0) {
            velocity.x = 0;
            position.x = block.x - hitbox.offsetX - hitbox.width;
            break;
          }
          if (velocity.x < 0) {
            velocity.x = 0;
            position.x = block.x + block.width + hitbox.width + hitbox.offsetX;
            break;
          }
        }
      }
    }
  }

  void _applyGravity(double dt) {
    velocity.y += _gravity;
    velocity.y = velocity.y.clamp(-_jumpForce, _terminalVelocity);
    position.y += velocity.y * dt;
  }

  void _checkVerticalCollisions() {
    for (final block in collisionBlocks) {
      if (block.isPlatform) {
        if (checkCollision(this, block)) {
          if (velocity.y > 0) {
            velocity.y = 0;
            position.y = block.y - hitbox.height - hitbox.offsetY;
            isOnGround = true;
            break;
          }
        }
      } else {
        if (checkCollision(this, block)) {
          if (velocity.y > 0) {
            velocity.y = 0;
            position.y = block.y - hitbox.height - hitbox.offsetY;
            isOnGround = true;
            break;
          }
          if (velocity.y < 0) {
            velocity.y = 0;
            position.y = block.y + block.height - hitbox.offsetY;
          }
        }
      }
    }
  }

  void climbMovement(bool upkey, bool downkey) {
    isOnGround = false;
    verticalMovement += upkey ? -1 : 0;
    verticalMovement += downkey ? 1 : 0;
  }
}
