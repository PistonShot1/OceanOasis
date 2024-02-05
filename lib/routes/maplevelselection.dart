import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:oceanoasis/components/mapmarker.dart';
import 'package:oceanoasis/homescreen.dart';
import 'package:oceanoasis/maps/pacific.dart';

class MapLevelSelection extends Component with HasGameReference<MyGame> {
  static const id = 'MapLevelSelection';

  final SpriteComponent worldMap;
  final VoidCallback? onExitPressed;
  List<Component> maplevelcomponents = [];

  MapLevelSelection({this.onExitPressed, super.key})
      : worldMap = SpriteComponent.fromImage(
          Flame.images.fromCache('earth-map-final.jpeg'),
        );
  @override
  FutureOr<void> onLoad() async {
    // TODO: implement onLoad
    worldMap.size = Vector2(1920, 1080);
    final List<MapMarker> markers = _getMarkers();

    maplevelcomponents.add(worldMap);
    maplevelcomponents.addAll(markers);

    await add(worldMap);
    await addAll(markers);
    
    game.mapLevelSelection = this;
    print('The key : ${game.findByKeyName('MapLevelSelection')}');
    print('The key RouterComponent : ${game.findByKeyName('RouterComponent')}');
    return super.onLoad();
  }

  List<MapMarker> _getMarkers() {
    //adding here temporarily without tileset location
    // TODO : convert the map to tiled tmx and add these markers
    return [
      MapMarker(
          key: ComponentKey.named('MapMarker Pacific'),
          locationOnMap: Vector2(100, 200),
          isMapAvailable: true,
          sceneLoadCallback: () => _generateScene('pacific'),
          mapName: PacificOcean.id),
      // MapMarker(locationOnMap: Vector2(600, 500), isMapAvailable: true)
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
}
