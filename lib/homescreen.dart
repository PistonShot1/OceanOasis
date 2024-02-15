import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/debug.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart' hide Route, OverlayRoute;
import 'package:oceanoasis/components/joystickplayer.dart';
import 'package:oceanoasis/components/toolbox.dart';
import 'package:oceanoasis/maps/bossfight.dart';
import 'package:oceanoasis/maps/pacificunderwater.dart';
import 'package:oceanoasis/routes/levelselection.dart';
import 'package:oceanoasis/routes/maplevelselection.dart';

class MyGame extends FlameGame
    with HasKeyboardHandlerComponents, HasCollisionDetection {
  late SpriteComponent backgroundImage;
  List<Component> mainComponents = [];
  List<Component> gameComponents = [];
  late MapLevelSelection mapLevelSelection;
  final MediaQueryData screeninfo;
  late final RouterComponent router;
  late JoystickPlayer player;
  late JoystickComponent joystick;
  late ItemToolBox uiToolbox;
  MyGame(this.screeninfo);
  @override
  Future<void> onLoad() async {
    await loadAssets();
    //SET camera bound
    camera = CameraComponent.withFixedResolution(
      width: 1920,
      height: 1080,
    );
    camera.viewport.size = Vector2(1920, 1080);
    camera.viewfinder
      ..zoom = 1
      ..anchor = Anchor.center;
    // add(MyScreenHitbox());
    overlays.add('Score');
    router = RouterComponent(initialRoute: LevelSelection.id, routes: {
      MapLevelSelection.id: Route(
        () => MapLevelSelection(key: ComponentKey.named('MapLevelSelection')),
      ),
      LevelSelection.id: OverlayRoute(
          (context, game) => LevelSelection(
                onLevelSelected: (value) {
                  _startLevel(value);
                },
              ),
          transparent: false),
      PacificOceanBossFight.id: Route(() => PacificOceanBossFight())
    });

    final knobPaint = BasicPalette.blue.withAlpha(200).paint();
    final backgroundPaint = BasicPalette.blue.withAlpha(100).paint();

    joystick = JoystickComponent(
      key: ComponentKey.named('JoystickHUD'),
      knob: CircleComponent(radius: 30, paint: knobPaint),
      background: CircleComponent(radius: 100, paint: backgroundPaint),
      margin: const EdgeInsets.only(left: 40, bottom: 40),
    );

    //GLOBAL Component
    player = JoystickPlayer(
        joystick: joystick,
        position: Vector2(0, 0),
        playerScene: 0,
        image: Flame.images.fromCache('character2-swim1.png'),
        animationData: SpriteAnimationData.sequenced(
            amount: 6, // Number of frames in your animation
            stepTime: 0.15, // Duration of each frame
            textureSize: Vector2(48, 48)));
    // List<SpriteAnimationFrame> frames = [];
    // player.animation = SpriteAnimation(frames);
    
    world.add(router);

    //DEBUG
    // debugMode = true;
    // add(FpsTextComponent());

    // world.addAll(mainComponents);
  }

  Future<void> loadAssets() async {
    // await Flame.images.load('bird-flying-2.png');

    // await Flame.images.load('earth-map-final.jpeg');
    // await Flame.images.load('character2-swim1.png');
    // await Flame.images.load('map-location-icon.png');

    // //NEXT Scene assets
    // await Flame.images.load('scene-1.png');

    // //Waste images
    // await Flame.images.load('waste/newspaper.png');

    // //Creature images
    // await Flame.images.load('creatures/turtle/Walk.png');

    // //UI component
    // await Flame.images.load('ui/item-ui.png');

    // //Tools component
    // await Flame.images.load('tools/tool1.png');
    // await Flame.images.load('tools/tool2.png');
    // await Flame.images.load('tools/tool3.png');

//Player data
    await Flame.images.loadAllImages();
  }

  void _startLevel(int levelIndex) {
    //TODO : pass user data
    router.pushReplacement(Route(
        () => PacificOceanUnderwater(levelNumber: levelIndex, playeritems: 3)));
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
// SpriteAnimationData.sequenced(
//     amount: 6, // Number of frames in your animation
//     stepTime: 0.1, // Duration of each frame
//     textureSize: Vector2(32, 32)));

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
