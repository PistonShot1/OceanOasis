import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart' hide Route;
import 'package:oceanoasis/homescreen.dart';
import 'package:oceanoasis/maps/pacific.dart';

class MapMarker extends SpriteComponent
    with TapCallbacks, HasGameReference<MyGame> {
  late ShapeHitbox hitbox;
  final _defaultColor = Colors.cyan;
  final Vector2 locationOnMap;
  final bool isMapAvailable;

  Component Function()? sceneLoadCallback; //not in user rn
  String? mapName;

  String? mapId;
  MapMarker(
      {required this.locationOnMap,
      required this.isMapAvailable,
      required ComponentKey key,
      this.mapId,
      this.sceneLoadCallback,
      this.mapName})
      : super.fromImage(
             Flame.images.fromCache('map-location-icon.png'),
            position: locationOnMap, key: key);
  @override
  FutureOr<void> onLoad() {
    // TODO: implement onLoad
    final defaultPaint = Paint()
      ..color = _defaultColor
      ..style = PaintingStyle.stroke;
    hitbox = RectangleHitbox()
      ..paint = defaultPaint
      ..renderShape = true;
    add(hitbox);
    return super.onLoad();
  }

  @override
  void onMount() {
    // TODO: implement onMount

    super.onMount();
  }

  @override
  void onTapUp(TapUpEvent event) async {
    // TODO: implement onTapUp
    // game.world.removeAll(game.mainComponents);
    // final tiledMap = await TiledComponent.load('test-map2.tmx', Vector2.all(8));
    // game.gameComponents.add(tiledMap);

    // final objectGroup2 =
    //     tiledMap.tileMap.getLayer<ObjectGroup>('Object Layer 2');
    // final objectGroup3 =
    //     tiledMap.tileMap.getLayer<ObjectGroup>('Object Layer 3');

    // final knobPaint = BasicPalette.blue.withAlpha(200).paint();
    // final backgroundPaint = BasicPalette.blue.withAlpha(100).paint();
    // game.joystick = JoystickComponent(
    //   knob: CircleComponent(radius: 30, paint: knobPaint),
    //   background: CircleComponent(radius: 100, paint: backgroundPaint),
    //   margin: const EdgeInsets.only(left: 40, bottom: 40),
    // );
    // game.player = JoystickPlayer(game.joystick);
    // game.gameComponents.add(game.player);
    // // game.gameComponents.add(game.joystick);
    // // game.camera.viewport.add(game.joystick);
    // game.overlays.add('TopMenu');
    // game.world.addAll(game.gameComponents);
    // game.world.add(sceneLoadCallback!());
    // game.remove(game.mainMapComponent);

    if (mapName != null) {
      game.router.pushReplacement(
          Route(() => PacificOcean(key: ComponentKey.named(PacificOcean.id))),
          name: PacificOcean.id);
    }
    print('something was tapped');
    super.onTapUp(event);
  }

  @override
  void onLongTapDown(TapDownEvent event) {
    // TODO: implement onLongTapDown (for viewing picture and area)
    super.onLongTapDown(event);
  }
}
