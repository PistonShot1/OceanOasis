import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/flame.dart';
import 'package:oceanoasis/maps/underwater/joystickplayer.dart';

class LongSwordFishEnemy extends SpriteAnimationComponent
    with CollisionCallbacks {
  final JoystickPlayer player;
  final double speed = 200;
  LongSwordFishEnemy({required this.player})
      : super.fromFrameData(
            Flame.images.fromCache('events/longswordfish.png'),
            SpriteAnimationData.sequenced(
                amount: 6, stepTime: 0.15, textureSize: Vector2.all(48)),
            size: Vector2.all(128));
  @override
  void onMount() {
    // TODO: implement onMount
    add(CircleHitbox()
      ..collisionType = CollisionType.passive
      ..debugMode = true);
    final moveEffect = MoveEffect.by(
        Vector2(1920, 0), EffectController(duration: 5), onComplete: () {
      removeFromParent();
    });
    add(moveEffect);
    super.onMount();
  }

  @override
  FutureOr<void> onLoad() {
    // TODO: implement onLoad
    return super.onLoad();
  }

  @override
  void update(double dt) {
    // TODO: implement update
    super.update(dt);
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is JoystickPlayer) {
      other.hit(0.5);
      removeFromParent();
    }
    super.onCollisionStart(intersectionPoints, other);
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    // TODO: implement onCollisionEnd
    super.onCollisionEnd(other);
  }
}
