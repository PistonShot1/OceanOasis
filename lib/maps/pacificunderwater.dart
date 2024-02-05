import 'dart:async';
import 'dart:io';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/palette.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart' hide Route;
import 'package:oceanoasis/components/joystickplayer.dart';
import 'package:oceanoasis/components/rectangleCollider.dart';
import 'package:oceanoasis/homescreen.dart';
import 'package:oceanoasis/maps/pacific.dart';

class PacificOceanUnderwater extends Component with HasGameReference<MyGame> {
  static const id = 'PacificOceanUnderwater';
  late final TiledComponent tiledMap;
  PacificOceanUnderwater({required ComponentKey key}) : super(key: key);
  @override
  Future<void> onLoad() async {
    // TODO: implement onLoad
    tiledMap = await TiledComponent.load('pacific-ocean.tmx', Vector2.all(128));
    add(tiledMap);
    print('Key: ${game.findByKeyName('MapMarker Pacific')}');
    print('The key RouterComponent : ${game.findByKeyName('RouterComponent')}');
    //JoyStick addition and player for mobile
    loadPlayerJoystick();
    cameraSettings();
    return super.onLoad();
  }

  void cameraSettings() {
    game.camera.setBounds(RoundedRectangle.fromLTRBR(10, 10, 10, 10, 10),
        considerViewport: true);
    // game.camera.viewfinder.zoom = 1.2;

    game.camera.viewport.add(RectangleCollidable(Vector2(1700, 0), true));
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
    final player = JoystickPlayer(joystick,
        Vector2(spawnPoint!.objects.first.x, spawnPoint!.objects.first.y));
    add(player);
    (Platform.isAndroid || Platform.isIOS)
        ? game.camera.viewport.add(joystick)
        : '';
  }
}
