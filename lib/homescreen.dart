import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';

class MyGame extends FlameGame {
  late SpriteComponent backgroundImage;
  late TiledComponent mapComponent;
  @override
  Future<void> onLoad() async {
    await Flame.images.load('main-menu-background.jpg');
    backgroundImage = SpriteComponent.fromImage(
        Flame.images.fromCache('main-menu-background.jpg'));

    camera.viewfinder
      ..zoom = 0.8
      ..anchor = Anchor.topLeft;
    // world.add(backgroundImage);
    mapComponent = await TiledComponent.load('earth-map-tileset.tmx', Vector2.all(8));
    world.add(mapComponent);
  }
}
