import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart' hide Route;
import 'package:flutter/src/services/keyboard_key.g.dart';
import 'package:oceanoasis/maps/pacific.dart';
import 'package:oceanoasis/routes/maplevelselection.dart';

class MyGame extends FlameGame
    with HasKeyboardHandlerComponents, HasCollisionDetection {
  late SpriteComponent backgroundImage;
  List<Component> mainComponents = [];
  List<Component> gameComponents = [];
  late MapLevelSelection mapLevelSelection;
  final MediaQueryData screeninfo;
  late final RouterComponent router;
  MyGame(this.screeninfo);
  @override
  Future<void> onLoad() async {
    await loadAssets();
    print(screeninfo.size.width);
    print(screeninfo.size.height);
    //SET camera bound
    camera = CameraComponent.withFixedResolution(
      width: 1920,
      height: 1080,
    );
    camera.viewfinder
      ..zoom = 1
      ..anchor = Anchor.topLeft;
   
    router = RouterComponent(
        key: ComponentKey.named('RouterComponent'),
        initialRoute: 'MapLevelSelection',
        routes: {
          MapLevelSelection.id: Route(
            () =>
                MapLevelSelection(key: ComponentKey.named('MapLevelSelection')),
          ),
          PacificOcean.id: Route(PacificOcean.new),
        });

    world.add(router);
    // world.addAll(mainComponents);
  }

  Future<void> loadAssets() async {
    await Flame.images.load('bird-flying-2.png');
    await Flame.images.load('newspaper.png');
    await Flame.images.load('earth-map-final.jpeg');
    await Flame.images.load('character2-swim1.png');
    await Flame.images.load('map-location-icon.png');

    //NEXT Scene assets
    await Flame.images.load('scene-1.png');
  }

  @override
  void update(double dt) {
    super.update(dt);
  }

  @override
  void removeFromParent() {
    // TODO: implement removeFromParent
    super.removeFromParent();
  }
}

//UNUSED legit codes
// class BirdPlayer extends SpriteAnimationComponent
//     with KeyboardHandler, HasGameReference<MyGame>, CollisionCallbacks {
//   int horizontalDirection = 0;
//   int verticalDirection = 0;
//   final Vector2 velocity = Vector2.zero();
//   final double moveSpeed = 100;

//   final _collisionStartColor = Colors.amber;
//   final _defaultColor = Colors.cyan;
//   late ShapeHitbox hitbox;

//   BirdPlayer()
//       : super.fromFrameData(
//             Flame.images.fromCache('bird-flying-2.png'),
//             SpriteAnimationData.sequenced(
//                 amount: 6, // Number of frames in your animation
//                 stepTime: 0.1, // Duration of each frame
//                 textureSize: Vector2(32, 32)));

//   @override
//   bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
//     horizontalDirection = 0;
//     verticalDirection = 0;
//     horizontalDirection += (keysPressed.contains(LogicalKeyboardKey.keyA) ||
//             keysPressed.contains(LogicalKeyboardKey.arrowLeft))
//         ? -1
//         : 0;
//     horizontalDirection += (keysPressed.contains(LogicalKeyboardKey.keyD) ||
//             keysPressed.contains(LogicalKeyboardKey.arrowRight))
//         ? 1
//         : 0;
//     verticalDirection += (keysPressed.contains(LogicalKeyboardKey.keyW) ||
//             keysPressed.contains(LogicalKeyboardKey.arrowUp))
//         ? -1
//         : 0;
//     verticalDirection += (keysPressed.contains(LogicalKeyboardKey.keyS) ||
//             keysPressed.contains(LogicalKeyboardKey.arrowDown))
//         ? 1
//         : 0;
//     return true;
//   }

//   @override
//   FutureOr<void> onLoad() {
//     // TODO: implement onLoad
//     final defaultPaint = Paint()
//       ..color = _defaultColor
//       ..style = PaintingStyle.stroke;
//     hitbox = RectangleHitbox()
//       ..paint = defaultPaint
//       ..renderShape = true;
//     add(hitbox);

//     return super.onLoad();
//   }

//   @override
//   void update(double dt) {
//     velocity.x = horizontalDirection * moveSpeed;
//     velocity.y = verticalDirection * moveSpeed;
//     position += velocity * dt;

//     if (horizontalDirection < 0 && scale.x > 0) {
//       flipHorizontally();
//     } else if (horizontalDirection > 0 && scale.x < 0) {
//       flipHorizontally();
//     }
//     super.update(dt);
//   }

//   @override
//   void onCollisionStart(
//       Set<Vector2> intersectionPoints, PositionComponent other) {
//     // TODO: implement onCollisionStart
//     super.onCollisionStart(intersectionPoints, other);
//   }
// }

// class NewspaperSprite extends SpriteComponent
//     with HasGameReference<MyGame>, CollisionCallbacks {
//   final _defaultColor = Colors.cyan;
//   late ShapeHitbox hitbox;
//   NewspaperSprite()
//       : super.fromImage(Flame.images.fromCache('newspaper.png'),
//             position: Vector2.all(100));
//   @override
//   FutureOr<void> onLoad() {
//     // TODO: implement onLoad
//     final defaultPaint = Paint()
//       ..color = _defaultColor
//       ..style = PaintingStyle.stroke;
//     hitbox = RectangleHitbox()
//       ..paint = defaultPaint
//       ..renderShape = true;
//     add(hitbox);
//     return super.onLoad();
//   }

//   @override
//   void onCollisionStart(
//       Set<Vector2> intersectionPoints, PositionComponent other) {
//     // TODO: implement onCollisionStart
//     super.onCollisionStart(intersectionPoints, other);

//     if (other is BirdPlayer) {
//       print("Newspaper was hit by Bird");
//       game.camera.stop();
//     }
//   }
// }

// class PlayerSprite extends SpriteComponent
//     with HasGameReference<MyGame>, CollisionCallbacks {
//   final _defaultColor = Colors.cyan;
//   late ShapeHitbox hitbox;
//   PlayerSprite()
//       : super.fromImage(Flame.images.fromCache('newspaper.png'),
//             position: Vector2.all(100));
//   @override
//   FutureOr<void> onLoad() {
//     // TODO: implement onLoad
//     final defaultPaint = Paint()
//       ..color = _defaultColor
//       ..style = PaintingStyle.stroke;
//     hitbox = RectangleHitbox()
//       ..paint = defaultPaint
//       ..renderShape = true;
//     add(hitbox);
//     return super.onLoad();
//   }

//   @override
//   void onCollisionStart(
//       Set<Vector2> intersectionPoints, PositionComponent other) {
//     // TODO: implement onCollisionStart
//     super.onCollisionStart(intersectionPoints, other);

//     if (other is BirdPlayer) {
//       print("Newspaper was hit by Bird");
//       game.camera.stop();
//     }
//   }
// }

    // Calculate the initial position to center the birdPlayer in the camera
    // birdPlayer.position = Vector2(
      // camera.viewport.size.x / 2 - birdPlayer.size.x / 2,
      // camera.viewport.size.y / 2 - birdPlayer.size.y / 2,
    // );
    // camera.follow(birdPlayer);
    // world.add(ScreenHitbox());a