import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';

class PlayerHealth extends PositionComponent {
  double health;
  List<SpriteComponent> healthBar = [];
  final Sprite fullheart = Sprite(Flame.images.fromCache('heart-Sheet.png'),
      srcPosition: Vector2.zero(), srcSize: Vector2.all(32));
  final Sprite halfheart = Sprite(Flame.images.fromCache('heart-Sheet.png'),
      srcPosition: Vector2(32 * 2, 32), srcSize: Vector2.all(32));
  final Sprite emptyheart = Sprite(Flame.images.fromCache('heart-Sheet.png'),
      srcPosition: Vector2(32 * 3, 32), srcSize: Vector2.all(32));
  PlayerHealth({
    required this.health,
  });

  @override
  FutureOr<void> onLoad() {
    // TODO: implement onLoad
    int i = 0;
    for (i = 0; i < health.floor(); i++) {
      final spriteComponent = SpriteComponent(
        sprite: fullheart,
        size: Vector2.all(64),
        position: Vector2(i * 64, 0),
      );
      healthBar.add(spriteComponent);
    }
    addAll(healthBar);
    return super.onLoad();
  }

  void reset() {}

  get getHealthBar => healthBar;
}
