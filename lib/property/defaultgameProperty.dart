import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:oceanoasis/maps/pacificunderwater.dart';
import 'package:oceanoasis/tools/papercollector.dart';
import 'package:oceanoasis/tools/slashEffect.dart';

class LevelProperty {
  static Map<String, dynamic> levelProperty = {
    '1': {'levelNumber': 1, 'maxSpawn': 5},
    '2': {'levelNumber': 2, 'maxSpawn': 10},
    '3': {'levelNumber': 3, 'maxSpawn': 15},
    '4': {'levelNumber': 4, 'maxSpawn': 20},
    '5': {'levelNumber': 5, 'maxSpawn': 25},
  };
}

class ToolSlashProperty {
  static List<Map<String, PaperCollector>> toolIcon = [
    {
      'tool': PaperCollector(
          id: 'PaperCollectorTool',
          key: ComponentKey.named('PaperCollectorTool'),
          sprite: Sprite(Flame.images.fromCache('tools/tool1.png')),
          size: Vector2.all(32),
          position: Vector2(-16, 24),
          slashType: 'Paper',
          slashEffect: SlashEffect(
              Flame.images.fromCache('tools/tool1-effect1.png'), 'Paper'))
        ..anchor = Anchor.center,
      'icontool': PaperCollector(
        id: 'PaperCollectorIcon',
        key: ComponentKey.named('PaperCollectorIcon'),
        sprite: Sprite(Flame.images.fromCache('tools/tool1.png')),
        size: Vector2.all(16),
        position: Vector2.all(16),
      )
    },
    {
      'tool': PaperCollector(
          id: 'PlasticCollectorTool',
          key: ComponentKey.named('PlasticCollectorTool'),
          sprite: Sprite(Flame.images.fromCache('tools/tool2.png')),
          position: Vector2(-16, 24),
          size: Vector2.all(32),
          slashType: 'Plastic',
          slashEffect: SlashEffect(
              Flame.images.fromCache('tools/tool2-effect1.png'), 'Plastic'))
        ..anchor = Anchor.center,
      'icontool': PaperCollector(
        id: 'PlasticCollectorIcon',
        key: ComponentKey.named('PlasticCollectorIcon'),
        sprite: Sprite(Flame.images.fromCache('tools/tool2.png')),
        position: Vector2.all(16),
        size: Vector2.all(16),
      )
    },
    {
      'tool': PaperCollector(
          id: 'MetalCollectorTool',
          key: ComponentKey.named('MetalCollectorTool'),
          sprite: Sprite(Flame.images.fromCache('tools/tool3.png')),
          position: Vector2(-16, 24),
          size: Vector2.all(32),
          slashType: 'Metal',
          slashEffect: SlashEffect(
              Flame.images.fromCache('tools/tool3-effect1.png'), 'Metal'))
        ..anchor = Anchor.center,
      'icontool': PaperCollector(
        id: 'MetalCollectorIcon',
        key: ComponentKey.named('MetalCollectorIcon'),
        sprite: Sprite(Flame.images.fromCache('tools/tool3.png')),
        position: Vector2.all(16),
        size: Vector2.all(16),
      )
    }
  ];
}

// class WasteProperty{
//   //temporary
//   static List<Wast
// }
