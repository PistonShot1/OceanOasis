import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart' hide Route;
import 'package:oceanoasis/components/Boss/bossfight.dart';
import 'package:oceanoasis/components/mapmarker.dart';
import 'package:oceanoasis/maps/pacificunderwater.dart';
import 'package:oceanoasis/routes/gameplay.dart';
import 'package:oceanoasis/maps/pacific.dart';

class MapLevelSelection extends Component with HasGameReference<MyGame> {
  static const id = 'MapLevelSelection';
  late final List<MapMarker> markers;
  TiledComponent? map;
  World world = World();

  List<Component> maplevelcomponents = [];

  MapLevelSelection({super.key});
  @override
  FutureOr<void> onLoad() async {
    //Overlays
    overlaysSetting();
    // game.world = world;
    map = await TiledComponent.load('earth-map-final.tmx', Vector2.all(16));
    world.add(map!);

    getMarkers();
    await add(world);

    cameraSettings();

    return super.onLoad();
  }

  void getMarkers() {
    markers = _getMarkers();
    world.addAll(markers);
  }

  void overlaysSetting() {
    if (game.overlays.isActive('ToMapSelection')) {
      game.overlays.remove('ToMapSelection');
    }
    game.overlays.add('ToFacility');
  }

  List<MapMarker> _getMarkers() {
    //adding here temporarily without tileset location
    // TODO : convert the map to tiled tmx and add these markers
    return [
      MapMarker(
        locationOnMap: Vector2(100, 300),
        bossFightSceneRoute: () {
          game.router.pushReplacement(Route(() => PacificOceanBossFight()));
        },
        levelChallengeRoute: () {
          game.router.pushReplacement(Route(
              () => PacificOceanUnderwater(levelNumber: 1, playeritems: 3)));
        },
      ),
    ];
  }

  // Generate the scene according to ID specified
  Component _generateScene(String mapId) {
    switch (mapId) {
      case 'pacific':
        return PacificOcean();
      default:
        return Component();
    }
  }

  @override
  void onRemove() {
    // TODO: implement onRemove
    
    super.onRemove();
  }

  void cameraSettings() {
    game.camera = CameraComponent.withFixedResolution(
        world: world, height: 1024, width: 1920);
    game.camera.moveBy(Vector2(map!.size.x * 0.5, map!.size.y * 0.5));
  }
}
