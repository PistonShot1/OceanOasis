import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart' hide Route, OverlayRoute;
import 'package:oceanoasis/components/Boss/bossfight.dart';
import 'package:oceanoasis/components/mapmarker.dart';
import 'package:oceanoasis/maps/pacificunderwater.dart';

class MapLocationData {
  static const List<String> locationName = ['North Pacific Ocean'];
  static Map<String, dynamic> mapMarkerData = {
    'MapMarkers': [
      MapMarker(
        levelNumber: 1,
        locationOnMap: Vector2(100, 300),
        bossFightSceneRoute: Route(() => PacificOceanBossFight()),
        levelChallengeRoute:
            Route(() => PacificOceanUnderwater(levelNumber: 4, playeritems: 3)),
        locationName: locationName[0],
      )
    ],
  };

  static Map<String, dynamic> locationInfo = {
    locationName[0]: {
      'history':
          'The Great Pacific Garbage Patch is a collection of marine debris in the North Pacific Ocean. Also known as the Pacific trash vortex, the garbage patch is actually two distinct collections of debris bounded by the massive North Pacific Subtropical Gyre.',
      'image': Image.asset('assets/images/sample-data/sample1.jpg', fit: BoxFit.cover)
    }
  };
}
