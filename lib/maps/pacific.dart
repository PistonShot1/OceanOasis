import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/extensions.dart';
import 'package:flame/palette.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';
import 'package:oceanoasis/components/whirlpool.dart';
import 'package:oceanoasis/components/joystickplayer.dart';
import 'package:oceanoasis/components/whirlpool.dart';
import 'package:oceanoasis/homescreen.dart';
import 'dart:io' show Platform;

class PacificOcean extends Component
    with HasCollisionDetection, HasGameReference<MyGame> {
  late final TiledComponent tiledMap;
  static const id = 'PacificOcean';
  late final CameraComponent cameraComponent;
  late final World myWorld;
  late final JoystickPlayer player;

  PacificOcean({super.key});
  @override
  FutureOr<void> onLoad() async {
    // TODO: implement onLoad
    game.camera.moveTo(Vector2.all(0));
    game.camera.stop();

    myWorld = World();
    tiledMap = await TiledComponent.load('test-map4.tmx', Vector2.all(8));
    await myWorld.add(tiledMap);

    cameraComponent = CameraComponent(world: myWorld)
      ..viewport.anchor = Anchor.center;

    loadCollision();

    loadPlayerJoystick();

    cameraSettings();

    await add(myWorld);
    await add(cameraComponent);

    print('The key RouterComponent : ${game.findByKeyName('RouterComponent')}');

    // add(MyScreenHitbox());
    return super.onLoad();
  }

  void cameraSettings() {
    cameraComponent
      ..setBounds(
          Rectangle.fromRect(const Rect.fromLTRB(
              1920 * 0.4, 1080 * 0.3, 1920 * 0.65, 1080 * 0.6)),
          considerViewport: true)
      ..follow(player);
    cameraComponent.viewfinder.zoom = 1.5;
  }

  void loadPlayerJoystick() {
    final knobPaint = BasicPalette.blue.withAlpha(200).paint();
    final backgroundPaint = BasicPalette.blue.withAlpha(100).paint();
    final joystick = JoystickComponent(
      key: ComponentKey.named('JoystickHUD'),
      knob: CircleComponent(radius: 30, paint: knobPaint),
      background: CircleComponent(radius: 100, paint: backgroundPaint),
      margin: const EdgeInsets.only(left: 40, bottom: 40),
    );
    final spawnPoint = tiledMap.tileMap.getLayer<ObjectGroup>('Spawn Point');
    player = game.player;

    myWorld.add(player);
    myWorld.add(PositionComponent()
      ..size = Vector2(1920, 1080)
      ..debugMode = true
      ..position = Vector2.all(0));
    (Platform.isAndroid || Platform.isIOS)
        ? game.camera.viewport.add(joystick)
        : '';
  }

  void loadCollision() {
    final collisionGroup =
        tiledMap.tileMap.getLayer<ObjectGroup>('Collision Objects');
    for (final object in collisionGroup!.objects) {
      // if (object.name.compareTo('Whirlpool') == 0) {
      //   myWorld.add(Whirlpool(
      //       Vector2(object.x, object.y), Vector2(object.width, object.height)));
      // }
    }

    //SOME LEGIT CODE I COOK : MIGHT NEED IT LATER
    // for (final object in objectGroup!.objects) {
    //   if (object.isPolygon) {
    //     List<Vector2> polygonPoints = [];
    //     for (var element in object.polygon) {
    //       polygonPoints.add(Vector2(
    //           element.x / 2 + object.x / 2, element.y / 2 + object.y / 2));
    //     }
    //     game.gameComponents.add(
    //       PolygonComponent(
    //         polygonPoints,
    //       ),
    //     );
    //   } else if (object.isRectangle) {
    //     game.gameComponents.add(RectangleComponent(
    //         size: Vector2(object.width, object.height),
    //         position: Vector2(object.x, object.y),
    //         children: [RectangleHitbox()]));
    //   } else if (object.isEllipse) {
    //     game.gameComponents.add(CircleComponent(
    //         radius: 80,
    //         position: Vector2(object.x, object.y),
    //         paint: BasicPalette.green.paint()));
    //   }
    // }
  }
}
