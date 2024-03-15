import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/flame.dart';

class Bubbles extends SpriteComponent {
  Bubbles()
      : super.fromImage(
          Flame.images.fromCache('events/bubbles.png'),
        );
  @override
  void onMount() {
    // TODO: implement onMount
    Random random = Random();
    
    final moveEffect =
        MoveEffect.by(Vector2(0, -1 * (200 + random.nextInt(100).toDouble())), EffectController(duration: random.nextInt(6).toDouble()));
    add(moveEffect..onComplete = () => removeFromParent());
    super.onMount();
  }
}
