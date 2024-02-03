import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart' hide Route;
import 'package:oceanoasis/components/joystickplayer.dart';
import 'package:oceanoasis/maps/pacific.dart';

class PacificOceanUnderwater extends Component {
  static const id = 'PacificOceanUnderwater';
  PacificOceanUnderwater({required ComponentKey key}) : super(key: key);
  @override
  Future<void> onLoad() async {
    // TODO: implement onLoad
    final tiledMap =
        await TiledComponent.load('pacific-ocean.tmx', Vector2.all(128));
    add(tiledMap);

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

    return super.onLoad();
  }
}
