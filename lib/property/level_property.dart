import 'package:flame/game.dart';
import 'package:flutter/material.dart' hide Route, OverlayRoute;
import 'package:oceanoasis/components/maps/BossFight/bossfight.dart';
import 'package:oceanoasis/components/maps/underwater/underwater_scene.dart';
import 'package:oceanoasis/property/game_properties.dart';

enum Levels {
  level1,
  level2,
  level3,
  level4,
  level5,
}

class LevelProperty {
  final int levelNum;
  LevelProperty({required this.levelNum});
  static Map<int, dynamic> levelProperty = {
    1: {
      'levelNumber': 1,
      'locationName': 'North Pacific Ocean',
      'maxSpawn': 30,
      'tideEvent': true,
      'breathingEvent': true,
      'iceEvent': false,
      'listOfWastes': [WasteType.paper, WasteType.plastic, WasteType.metal],
      'swordFishInterval': 100.0,
    },
    2: {
      'levelNumber': 2,
      'locationName': 'Mississippi River',
      'maxSpawn': 30,
      'tideEvent': false,
      'breathingEvent': true,
      'iceEvent': false,
      'listOfWastes': [WasteType.paper, WasteType.plastic, WasteType.metal],
      'swordFishInterval': 3.0,
    },
    3: {
      'levelNumber': 3,
      'locationName': 'Ganges River',
      'maxSpawn': 15,
      'tideEvent': true,
      'breathingEvent': true,
      'iceEvent': false,
      'listOfWastes': [
        WasteType.paper,
        WasteType.plastic,
        WasteType.metal,
        WasteType.glass
      ],
      'swordFishInterval': 2.0,
    },
    4: {
      'levelNumber': 4,
      'locationName': 'Yellow River',
      'maxSpawn': 15,
      'tideEvent': true,
      'breathingEvent': true,
      'iceEvent': true,
      'listOfWastes': [
        WasteType.paper,
        WasteType.plastic,
        WasteType.metal,
        WasteType.glass,
        WasteType.radioactive
      ],
      'swordFishInterval': 2.0,
    },
    5: {
      'levelNumber': 5,
      'locationName': 'Citarum River',
      'maxSpawn': 15,
      'tideEvent': true,
      'breathingEvent': true,
      'iceEvent': true,
      'listOfWastes': [
        WasteType.paper,
        WasteType.plastic,
        WasteType.metal,
        WasteType.glass,
        WasteType.glass
      ],
      'swordFishInterval': 2.0,
    },
  };

  static Map<int, dynamic> locationInfo = {
    1: {
      'history':
          'The Great Pacific Garbage Patch is a collection of marine debris in the North Pacific Ocean. Also known as the Pacific trash vortex, the garbage patch is actually two distinct collections of debris bounded by the massive North Pacific Subtropical Gyre.',
      'image': Image.asset('assets/images/sample-data/sample1.jpg',
          fit: BoxFit.cover)
    },
    2: {
      'history':
          'Mississippi is one of the longest rivers in the world. As such, it serves millions of US residents. The river is brown in color, owing to the constant release of waste into the river. The aquatic life in the river has reduced alarmingly due to various oil spillages in the past. More waste comes from industries and farmers who use harmful chemicals and release them into the river.',
      'image': Image.asset('assets/images/sample-data/mississippi-river.png',
          fit: BoxFit.cover)
    },
    3: {
      'history':
          'Ganges River is the third largest river in the world with a consumption base of over two billion people. While the river is sacred, it\'s a victim of massive water pollution due to the dumping of raw sewage and chemicals, and higher incidences of waterborne diseases have been reported in communities frequently exposed to this holy river, now covered with a layer of floating plastics and other wastes.',
      'image': Image.asset('assets/images/sample-data/ganges-river.jpg',
          fit: BoxFit.cover)
    },
    4: {
      'history':
          'For thousands of years, the Yellow River has been one of the most famous rivers in China due to its unique colour. However, this river has become a dumping ground for chemical factories, making the water too toxic even for agriculture. More specifically, the coal mining industry releases a lot of waste back to the river after using water from it to run its operations',
      'image': Image.asset('assets/images/sample-data/yellow-river.jpg',
          fit: BoxFit.cover)
    },
    5: {
      'history':
          'The Citarum River is considered one of the most polluted rivers in the world. The river is covered in waste, trash, and dead animals, and the water is colored by toxic substances. The river\'s pollution spreads 100 meters wide in-land and 60 meters deep, containing E. coli bacteria, heavy metals and organic waste',
      'image': Image.asset('assets/images/sample-data/citarum-river.jpg',
          fit: BoxFit.cover)
    }
  };

  List<Route> get mapRoute {
    switch (levelNum) {
      case 1:
        return [
          Route(() => UnderwaterScene(levelNumber: levelNum, playeritems: 2)),
          Route(() => PacificOceanBossFight())
        ];
      case 2:
        return [
          Route(() => UnderwaterScene(levelNumber: levelNum, playeritems: 3)),
          Route(() => PacificOceanBossFight())
        ];
      case 3:
        return [
          Route(() => UnderwaterScene(levelNumber: levelNum, playeritems: 3)),
          Route(() => PacificOceanBossFight())
        ];
      case 4:
        return [
          Route(() => UnderwaterScene(levelNumber: levelNum, playeritems: 3)),
          Route(() => PacificOceanBossFight())
        ];
      case 5:
        return [
          Route(() => UnderwaterScene(levelNumber: levelNum, playeritems: 3)),
          Route(() => PacificOceanBossFight())
        ];
      default:
        return [];
    }
  }
}
