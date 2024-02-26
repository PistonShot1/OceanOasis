import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:oceanoasis/maps/pacificunderwater.dart';
import 'package:oceanoasis/tools/tools.dart';
import 'package:oceanoasis/tools/slashEffect.dart';
import 'package:oceanoasis/wasteComponents/waste.dart';

class LevelProperty {
  static Map<String, dynamic> levelProperty = {
    '1': {
      'levelNumber': 1,
      'maxSpawn': 100,
      'tideEvent': false,
      'breathingEvent': true,
      'iceEvent': false,
    },
    '2': {
      'levelNumber': 2,
      'maxSpawn': 15,
      'tideEvent': false,
      'breathingEvent': true,
      'iceEvent': false,
    },
    '3': {
      'levelNumber': 3,
      'maxSpawn': 15,
      'tideEvent': true,
      'breathingEvent': true,
      'iceEvent': true,
    },
    '4': {
      'levelNumber': 4,
      'maxSpawn': 15,
      'tideEvent': true,
      'breathingEvent': true,
      'iceEvent': true,
    },
    '5': {
      'levelNumber': 5,
      'maxSpawn': 15,
      'tideEvent': true,
      'breathingEvent': true,
      'iceEvent': true,
    },
  };
}

class ToolSlashProperty {
  static const String _toolType = 'WasteCollector';
  static List<Map<String, Tools>> toolIcon = [
    {
      'tool': Tools(
          sprite: Sprite(Flame.images.fromCache('tools/rubbish-picker.png')),
          size: Vector2(32, 64),
          position: Vector2(-16, 24),
          slashEffect: SlashEffect(
              Flame.images.fromCache('tools/slash-effect1.png'),
              ['Paper', 'Plastic', 'Glass'],
              frameAmount: 10,
              stepTime: 0.05,
              frameSize: Vector2.all(128),
              toolType: _toolType))
        ..anchor = Anchor.center,
      'icontool': Tools(
        sprite: Sprite(Flame.images.fromCache('tools/rubbish-picker.png')),
        size: Vector2(32 * 0.5, 64 * 0.5),
        position: Vector2(32 * 0.5 + 6, 0),
      )..angle = pi * 0.25
    },
    {
      'tool': Tools(
          sprite: Sprite(Flame.images.fromCache('tools/magnet.png')),
          position: Vector2(-16, 24),
          size: Vector2(64 * 0.5, 64 * 0.5),
          slashEffect: SlashEffect(
              Flame.images.fromCache('tools/slash-effect2.png'), ['Metal'],
              frameAmount: 9,
              stepTime: 0.05,
              frameSize: Vector2.all(128),
              toolType: _toolType))
        ..anchor = Anchor.center,
      'icontool': Tools(
        sprite: Sprite(Flame.images.fromCache('tools/magnet.png')),
        position: Vector2(64 * 0.25, 6),
        size: Vector2(64 * 0.25, 64 * 0.25),
      )..angle = pi * 0.25
    },
    {
      'tool': Tools(
          sprite: Sprite(Flame.images.fromCache('tools/dropper.png')),
          position: Vector2(-16, 24),
          size: Vector2(32, 64),
          slashEffect: SlashEffect(
              Flame.images.fromCache('tools/slash-effect3.png'),
              ['Radioactive'],
              frameAmount: 8,
              stepTime: 0.05,
              frameSize: Vector2.all(128),
              toolType: _toolType))
        ..anchor = Anchor.center,
      'icontool': Tools(
        sprite: Sprite(Flame.images.fromCache('tools/dropper.png')),
        position: Vector2(32 * 0.5 + 6, 0),
        size: Vector2(32 * 0.5, 64 * 0.5),
      )..angle = pi * 0.25
    }
  ];
}

class WasteProperty {
  //temporary
  static List<Waste> wasteProperty = [
    Waste(
        sprite: Sprite(Flame.images.fromCache('waste/newspaper.png')),
        wasteType: 'Paper',
        points: 5,
        decayTime: 10,
        wastechildren: {}),
    Waste(
        sprite: Sprite(Flame.images.fromCache('waste/plastic-bag.png')),
        wasteType: 'Plastic',
        points: 10,
        decayTime: 10,
        wastechildren: {}),
    Waste(
        sprite: Sprite(Flame.images.fromCache('waste/plastic-bag.png')),
        wasteType: 'Glass',
        points: 10,
        decayTime: 10,
        wastechildren: {}),
    Waste(
        sprite: Sprite(Flame.images.fromCache('waste/can.png')),
        wasteType: 'Metal',
        points: 15,
        decayTime: 10,
        wastechildren: {}),
  ];
}

class WeaponProperty {
  static const String _toolType = 'Weapon';
  static List<Map<String, Tools>> weapons = [
    {
      'weapon': Tools(
          sprite: Sprite(Flame.images.fromCache('weapons/staff1.png')),
          size: Vector2.all(32),
          position: Vector2(-16, 24),
          slashEffect: SlashEffect(
              Flame.images.fromCache('weapons/Lightning-effect.png'), [],
              frameAmount: 7,
              stepTime: 0.1,
              frameSize: Vector2(32, 193),
              toolType: _toolType)
            ..scale = Vector2.all(0.5))
        ..anchor = Anchor.center,
      'iconweapon': Tools(
        id: '',
        sprite: Sprite(Flame.images.fromCache('weapons/staff1.png')),
        size: Vector2.all(16),
        position: Vector2.all(16),
      )
    },
    {
      'weapon': Tools(
          sprite: Sprite(Flame.images.fromCache('weapons/staff2.png')),
          position: Vector2(-16, 24),
          size: Vector2.all(32),
          slashEffect: SlashEffect(
              Flame.images.fromCache('weapons/explosion-blue.png'), [],
              frameAmount: 10,
              stepTime: 0.1,
              frameSize: Vector2.all(128),
              toolType: _toolType)
            ..size = Vector2.all(64))
        ..anchor = Anchor.center,
      'iconweapon': Tools(
        sprite: Sprite(Flame.images.fromCache('weapons/staff2.png')),
        position: Vector2.all(16),
        size: Vector2.all(16),
      )
    },
    {
      'weapon': Tools(
          sprite: Sprite(Flame.images.fromCache('weapons/staff3.png')),
          position: Vector2(-16, 24),
          size: Vector2.all(32),
          slashEffect: SlashEffect(
              Flame.images.fromCache('weapons/nuclear-effect.png'), [],
              frameAmount: 10,
              stepTime: 0.1,
              frameSize: Vector2.all(256),
              toolType: _toolType)
            ..size = Vector2.all(64))
        ..anchor = Anchor.center,
      'iconweapon': Tools(
        id: '',
        sprite: Sprite(Flame.images.fromCache('weapons/staff3.png')),
        position: Vector2.all(16),
        size: Vector2.all(16),
      )
    }
  ];
}
