import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/services/keyboard_key.g.dart';
import 'package:oceanoasis/components/boxCollider.dart';

class MyGame extends FlameGame
    with HasKeyboardHandlerComponents, HasCollisionDetection {
  late SpriteComponent backgroundImage;
  late TiledComponent mapComponent;
  late Sprite player;
  late BirdPlayer birdPlayer;
  @override
  Future<void> onLoad() async {
    final worldCollider = WorldCollider()..size = Vector2.all(1000);
    //load images and spritesheet
    await Flame.images.load('main-menu-background.jpg');
    await Flame.images.load('temp1-player.jpeg');
    await Flame.images.load('bird-flying-2.png');

    backgroundImage = SpriteComponent.fromImage(
        Flame.images.fromCache('main-menu-background.jpg'));
    camera = CameraComponent.withFixedResolution(width: 1100, height: 1100);
    camera.viewfinder
      ..zoom = 1
      ..anchor = Anchor.topLeft;

    mapComponent =
        await TiledComponent.load('earth-map-tileset.tmx', Vector2.all(8));
    birdPlayer = BirdPlayer();

    world.add(mapComponent);
    world.add(birdPlayer);
    // Calculate the initial position to center the birdPlayer in the camera
    birdPlayer.position = Vector2(
      camera.viewport.size.x / 2 - birdPlayer.size.x / 2,
      camera.viewport.size.y / 2 - birdPlayer.size.y / 2,
    );
    // camera.follow(birdPlayer);
  }

  @override
  void update(double dt) {
    super.update(dt);
  }
}

class BirdPlayer extends SpriteAnimationComponent
    with KeyboardHandler, HasGameReference<MyGame> {
  int horizontalDirection = 0;
  int verticalDirection = 0;
  final Vector2 velocity = Vector2.zero();
  final double moveSpeed = 100;
  BirdPlayer()
      : super.fromFrameData(
            Flame.images.fromCache('bird-flying-2.png'),
            SpriteAnimationData.sequenced(
                amount: 6, // Number of frames in your animation
                stepTime: 0.1, // Duration of each frame
                textureSize: Vector2(32, 32)));

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

  @override
  void update(double dt) {
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
}
