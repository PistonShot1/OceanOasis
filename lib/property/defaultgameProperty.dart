import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart' hide Route;
import 'package:oceanoasis/components/Boss/bossfight.dart';
import 'package:oceanoasis/maps/pacificunderwater.dart';
import 'package:oceanoasis/tools/tools.dart';
import 'package:oceanoasis/tools/slashEffect.dart';
import 'package:oceanoasis/wasteComponents/waste.dart';

class ToolSlashProperty {
  static const String _toolType = 'WasteCollector';
  static List<Map<String, Tools>> toolIcon = [
    {
      'tool': Tools(
          sprite: Sprite(Flame.images.fromCache('tools/rubbish-picker.png')),
          size: Vector2(32, 64),
          position: Vector2(-16, 24),
          slashEffect: SlashEffect(
              Flame.images.fromCache('tools/water-hit-effect.png'),
              [WasteType.paper, WasteType.plastic, WasteType.glass],
              frameAmount: 21,
              stepTime: 0.05,
              frameSize: Vector2(256, 137),
              toolType: _toolType),
          slashType: [WasteType.paper, WasteType.plastic, WasteType.glass])
        ..anchor = Anchor.center,
      'icontool': Tools(
        sprite: Sprite(Flame.images.fromCache('tools/rubbish-picker.png')),
        size: Vector2(32 * 0.5, 64 * 0.5),
        position: Vector2(32 * 0.5 + 6, 0),
      )
        ..angle = pi * 0.25
        ..paint.filterQuality = FilterQuality.none
    },
    {
      'tool': Tools(
          sprite: Sprite(Flame.images.fromCache('tools/magnet.png')),
          position: Vector2(-16, 24),
          size: Vector2(64 * 0.5, 64 * 0.5),
          slashEffect: SlashEffect(
              Flame.images.fromCache('tools/water-hit-effect.png'),
              [WasteType.metal],
              frameAmount: 21,
              stepTime: 0.05,
              frameSize: Vector2(256, 137),
              toolType: _toolType),
          slashType: [WasteType.metal])
        ..anchor = Anchor.center,
      'icontool': Tools(
        sprite: Sprite(Flame.images.fromCache('tools/magnet.png')),
        position: Vector2(64 * 0.25, 6),
        size: Vector2(64 * 0.25, 64 * 0.25),
      )
        ..angle = pi * 0.25
        ..paint.filterQuality = FilterQuality.none
    },
    {
      'tool': Tools(
        sprite: Sprite(Flame.images.fromCache('tools/dropper.png')),
        position: Vector2(-16, 24),
        size: Vector2(32, 64),
        slashEffect: SlashEffect(
          Flame.images.fromCache('tools/water-hit-effect.png'),
          [WasteType.radioactive],
          frameAmount: 21,
          stepTime: 0.05,
          frameSize: Vector2(256, 137),
          toolType: _toolType,
        ),
        slashType: [WasteType.radioactive],
      )..anchor = Anchor.center,
      'icontool': Tools(
        sprite: Sprite(Flame.images.fromCache('tools/dropper.png')),
        position: Vector2(32 * 0.5 + 6, 0),
        size: Vector2(32 * 0.5, 64 * 0.5),
      )..angle = pi * 0.25
    }
  ];
}

enum WasteType { paper, plastic, glass, metal, radioactive }

class WasteProperty {
  final WasteType type;

  WasteProperty({required this.type});

  Waste get mapWasteComponent {
    switch (type) {
      case WasteType.paper:
        return Waste(
            sprite: Sprite(Flame.images.fromCache('waste/newspaper.png')),
            wasteType: WasteType.paper,
            points: 5,
            decayTime: 10,
            wastechildren: {});
      case WasteType.plastic:
        return Waste(
            sprite: Sprite(Flame.images.fromCache('waste/plastic-bag.png')),
            wasteType: WasteType.plastic,
            points: 10,
            decayTime: 10,
            wastechildren: {});
      case WasteType.glass:
        return Waste(
            sprite: Sprite(Flame.images.fromCache('waste/glass-bottle.png')),
            wasteType: WasteType.glass,
            points: 15,
            decayTime: 10,
            wastechildren: {});
      case WasteType.metal:
        return Waste(
            sprite: Sprite(Flame.images.fromCache('waste/can.png')),
            wasteType: WasteType.metal,
            points: 15,
            decayTime: 10,
            wastechildren: {});
      case WasteType.radioactive:
        return Waste(
            sprite: Sprite(Flame.images.fromCache('waste/radioactive-can.png')),
            wasteType: WasteType.radioactive,
            points: 15,
            decayTime: 10,
            wastechildren: {});
    }
  }
}

class WeaponProperty {
  static const String _toolType = 'Weapon';
  static List<Map<String, Tools>> weapons = [
    {
      'weapon': Tools(
          id: 'pistol',
          sprite: Sprite(Flame.images.fromCache('weapons/gun.png')),
          size: Vector2.all(32),
          position: Vector2(-16, 24),
          slashEffect: SlashEffect(
            Flame.images.fromCache('weapons/muzzleEffect.png'),
            [],
            frameAmount: 4,
            stepTime: 0.1,
            frameSize: Vector2(23, 23),
            toolType: _toolType,
          )..scale = Vector2.all(1))
        ..anchor = Anchor.center,
      'iconweapon': Tools(
        id: '',
        sprite: Sprite(Flame.images.fromCache('weapons/gun.png')),
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
