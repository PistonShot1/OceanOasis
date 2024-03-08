import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart' hide Route, Image;
import 'package:oceanoasis/components/Boss/bossfight.dart';
import 'package:oceanoasis/components/mapmarker.dart';
import 'package:oceanoasis/maps/underwater/pacificunderwater.dart';
import 'package:oceanoasis/property/levelProperty.dart';
import 'package:oceanoasis/routes/gameplay.dart';
import 'package:oceanoasis/maps/overworld/pacific.dart';
import 'package:oceanoasis/routes/tiledMapLevelSelection.dart';

class MapLevelSelection extends Component with HasGameReference<MyGame> {
  static const id = 'MapLevelSelection';
  late final List<MapMarker> markers;
  TiledMapSelection? mainMap;
  World world = World();

  List<Component> maplevelcomponents = [];

  MapLevelSelection({super.key});
  @override
  FutureOr<void> onLoad() async {
    //Overlays
    overlaysSetting();

    final TiledComponent tiledmap =
        await TiledComponent.load('earth-map-final.tmx', Vector2.all(128));

    mainMap = TiledMapSelection(tiledmap.tileMap);

    world.add(mainMap!);

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
    if (game.overlays.isActive('TotalScores')) {
      game.overlays.remove('TotalScores');
    }
    game.overlays.add('ToFacility');
  }

  List<MapMarker> _getMarkers() {
    //adding here temporarily without tileset location
    // TODO : convert the map to tiled tmx and add these markers
    final mapMarkerLayer =
        mainMap!.tileMap.getLayer<ObjectGroup>('Map Marker Layer');
    List<MapMarker> markers = [];

    // The mapMarkerLayer which is a layer of points plotted on Tiled, it can be guaranteed that :
    // The number of points would correspond to the number of levels in the game,
    // as well as the order of it in Tiled is arranged in desired order
    // Where the number of levels for the game is defined at [LevelProperty.levelProperty], so...
    // i.e : mapMarkerLayer.objects.length = LevelProperty.levelProperty.length
    for (int i = 1; i <= mapMarkerLayer!.objects.length; i++) {
      LevelProperty level = LevelProperty(levelNum: i);
      List<Route> routes = level.mapRoute;

      final levelDetails = LevelProperty.levelProperty[i];
      final ref = mapMarkerLayer.objects[i - 1];

      markers.add(MapMarker(
          locationOnMap: ref.position,
          locationName: levelDetails['locationName'],
          bossFightSceneRoute: routes.last,
          levelChallengeRoute: routes.first,
          levelNumber: i));
    }
    return markers;
  }

  @override
  void onRemove() {
    // TODO: implement onRemove

    super.onRemove();
  }

  void cameraSettings() {
    game.camera = CameraComponent(world: world);
    game.camera.viewfinder.visibleGameSize = mainMap!.size * 0.5;

    game.camera.viewfinder.anchor = Anchor.topLeft;
    game.camera.backdrop = SpriteComponent.fromImage(
        Flame.images.fromCache('tileset/galaxy-background.jpg'));

    //Minor offset adjustment to block view certain part of frame of map
    final leftTopOffset = Vector2(50, 50);
    final rightBottomOffset = Vector2(128 * 3, 100);

    game.camera.setBounds(Rectangle.fromPoints(
        Vector2(leftTopOffset.x, leftTopOffset.y),
        Vector2(mainMap!.size.x * 0.5 - rightBottomOffset.x,
            mainMap!.size.y * 0.5 - rightBottomOffset.y)));
  }
}
