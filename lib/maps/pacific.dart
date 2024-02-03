import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';
import 'package:oceanoasis/components/whirlpool.dart';
import 'package:oceanoasis/components/joystickplayer.dart';
import 'package:oceanoasis/components/whirlpool.dart';
import 'package:oceanoasis/homescreen.dart';

class PacificOcean extends Component
    with HasCollisionDetection, HasGameReference<MyGame> {
  late final TiledComponent tiledMap;
  static const id = 'PacificOcean';

  PacificOcean({super.key});
  @override
  FutureOr<void> onLoad() async {
    // TODO: implement onLoad

    //Load ocean tile map and add
    tiledMap = await TiledComponent.load('test-map4.tmx', Vector2.all(8));
    add(tiledMap);
    loadCollision();
    //JoyStick addition and player for mobile
    final knobPaint = BasicPalette.blue.withAlpha(200).paint();
    final backgroundPaint = BasicPalette.blue.withAlpha(100).paint();
    final joystick = JoystickComponent(
      knob: CircleComponent(radius: 30, paint: knobPaint),
      background: CircleComponent(radius: 100, paint: backgroundPaint),
      margin: const EdgeInsets.only(left: 40, bottom: 40),
    );
    final spawnPoint = tiledMap.tileMap.getLayer<ObjectGroup>('Spawn Point');
    final player = JoystickPlayer(joystick,
        Vector2(spawnPoint!.objects.first.x, spawnPoint!.objects.first.y));
    add(player);
    game.camera.viewport.add(joystick);

    // game.camera.follow(player);
    return super.onLoad();
  }

  void loadCollision() {
    final collisionGroup =
        tiledMap.tileMap.getLayer<ObjectGroup>('Collision Objects');
    for (final object in collisionGroup!.objects) {
      if (object.name.compareTo('Whirlpool') == 0) {
        add(Whirlpool(
            Vector2(object.x, object.y), Vector2(object.width, object.height)));
      }
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
