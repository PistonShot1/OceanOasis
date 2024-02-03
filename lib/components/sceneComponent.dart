import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame_tiled/flame_tiled.dart';

class SceneComponent extends Component with CollisionCallbacks {
  final TiledComponent<FlameGame<World>> tiledMap;

  SceneComponent({required this.tiledMap});

  @override
  FutureOr<void> onLoad() {
    // TODO: implement onLoa

    return super.onLoad();
  }

  _addCollisionToMap() {
    final objectgroup =
        tiledMap.tileMap.getLayer<ObjectGroup>('Object Layer 1');
    for (final object in objectgroup!.objects) {
      // object.polygon.v
    }
  }
}
