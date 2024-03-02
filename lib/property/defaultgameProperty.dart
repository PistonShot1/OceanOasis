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
      'maxSpawn': 2,
      'tideEvent': false,
      'breathingEvent': false
    },
    '2': {
      'levelNumber': 2,
      'maxSpawn': 15,
      'tideEvent': false,
      'breathingEvent': true
    },
    '3': {
      'levelNumber': 3,
      'maxSpawn': 15,
      'tideEvent': true,
      'breathingEvent': true
    },
    '4': {
      'levelNumber': 4,
      'maxSpawn': 15,
      'tideEvent': true,
      'breathingEvent': true
    },
    '5': {
      'levelNumber': 5,
      'maxSpawn': 15,
      'tideEvent': true,
      'breathingEvent': true
    },
  };
}

class ToolSlashProperty {
  static List<Map<String, Tools>> toolIcon = [
    {
      'tool': Tools(
          id: 'PaperCollectorTool',
          key: ComponentKey.named('PaperCollectorTool'),
          sprite: Sprite(Flame.images.fromCache('tools/tool1.png')),
          size: Vector2.all(32),
          position: Vector2(-16, 24),
          slashType: 'Paper',
          slashEffect: SlashEffect(
            Flame.images.fromCache('tools/tool1-effect1.png'),
            'Paper',
            frameAmount: 1,
            stepTime: 0.5,
            frameSize: Vector2.all(256),
          ))
        ..anchor = Anchor.center,
      'icontool': Tools(
        id: 'PaperCollectorIcon',
        key: ComponentKey.named('PaperCollectorIcon'),
        sprite: Sprite(Flame.images.fromCache('tools/tool1.png')),
        size: Vector2.all(16),
        position: Vector2.all(16),
      )
    },
    {
      'tool': Tools(
          id: 'PlasticCollectorTool',
          key: ComponentKey.named('PlasticCollectorTool'),
          sprite: Sprite(Flame.images.fromCache('tools/tool2.png')),
          position: Vector2(-16, 24),
          size: Vector2.all(32),
          slashType: 'Plastic',
          slashEffect: SlashEffect(
              Flame.images.fromCache('tools/tool2-effect1.png'), 'Plastic',
              frameAmount: 1, stepTime: 0.5, frameSize: Vector2.all(496)))
        ..anchor = Anchor.center,
      'icontool': Tools(
        id: 'PlasticCollectorIcon',
        key: ComponentKey.named('PlasticCollectorIcon'),
        sprite: Sprite(Flame.images.fromCache('tools/tool2.png')),
        position: Vector2.all(16),
        size: Vector2.all(16),
      )
    },
    {
      'tool': Tools(
          id: 'MetalCollectorTool',
          key: ComponentKey.named('MetalCollectorTool'),
          sprite: Sprite(Flame.images.fromCache('tools/tool3.png')),
          position: Vector2(-16, 24),
          size: Vector2.all(32),
          slashType: 'Metal',
          slashEffect: SlashEffect(
            Flame.images.fromCache('tools/tool3-effect1.png'),
            'Metal',
            frameAmount: 1,
            stepTime: 0.5,
            frameSize: Vector2.all(496),
          ))
        ..anchor = Anchor.center,
      'icontool': Tools(
        id: 'MetalCollectorIcon',
        key: ComponentKey.named('MetalCollectorIcon'),
        sprite: Sprite(Flame.images.fromCache('tools/tool3.png')),
        position: Vector2.all(16),
        size: Vector2.all(16),
      )
    }
  ];
}

class WasteProperty {
  //temporary
  static List<Waste> wasteProperty = [
    Waste(
        sprite: Sprite(Flame.images.fromCache('waste/newspaper.png')),
        id: 'Paper',
        points: 5,
        decayTime: 10),
    Waste(
        sprite: Sprite(Flame.images.fromCache('waste/plastic-bag.png')),
        id: 'Plastic',
        points: 10,
        decayTime: 10),
    Waste(
        sprite: Sprite(Flame.images.fromCache('waste/can.png')),
        id: 'Metal',
        points: 15,
        decayTime: 10),
  ];
}

class WeaponProperty {
  static List<Map<String, Tools>> weapons = [
    {
      'weapon': Tools(
          id: 'pistol',
          sprite: Sprite(Flame.images.fromCache('weapons/gun.png')),
          size: Vector2.all(32),
          position: Vector2(-16, 24),
          slashType: '',
          slashEffect: SlashEffect(
            Flame.images.fromCache('weapons/muzzleEffect.png'),
            '',
            frameAmount: 4,
            stepTime: 0.1,
            frameSize: Vector2(23, 23),
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
          id: 'freezeDevice',
          sprite: Sprite(Flame.images.fromCache('weapons/staff2.png')),
          position: Vector2(-16, 24),
          size: Vector2.all(32),
          slashType: '',
          slashEffect: SlashEffect(
              Flame.images.fromCache('weapons/explosion-blue.png'), '',
              frameAmount: 10, stepTime: 0.1, frameSize: Vector2.all(128))
            ..size = Vector2.all(64))
        ..anchor = Anchor.center,
      'iconweapon': Tools(
        id: '',
        sprite: Sprite(Flame.images.fromCache('weapons/staff2.png')),
        position: Vector2.all(16),
        size: Vector2.all(16),
      )
    },
    {
      'weapon': Tools(
          id: '',
          sprite: Sprite(Flame.images.fromCache('weapons/staff3.png')),
          position: Vector2(-16, 24),
          size: Vector2.all(32),
          slashType: '',
          slashEffect: SlashEffect(
            Flame.images.fromCache('weapons/nuclear-effect.png'),
            '',
            frameAmount: 10,
            stepTime: 0.1,
            frameSize: Vector2.all(256),
          )..size = Vector2.all(64))
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
