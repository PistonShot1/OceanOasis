import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/flame.dart';
import 'package:flame/image_composition.dart';
import 'package:oceanoasis/components/maps/underwater/joystickplayer.dart';
import 'package:oceanoasis/my_game.dart';

class GlacierFormation extends SpriteAnimationComponent
    with CollisionCallbacks, HasGameReference<MyGame> {
  GlacierFormation()
      : super.fromFrameData(
          Flame.images.fromCache('events/ice-glacier.png'),
          SpriteAnimationData.sequenced(
              amount: 1, stepTime: 1, textureSize: Vector2(1920, 32)),
        );
  @override
  FutureOr<void> onLoad() {
    // TODO: implement onLoad
    add(RectangleHitbox());
    return super.onLoad();
  }

  @override
  void onMount() {
    // TODO: implement onMount

    opacity = 0.1;
    final effect = OpacityEffect.to(1, EffectController(duration: 2));
    add(effect);
    final scaleEffect =
        ScaleEffect.by(Vector2.all(2), EffectController(duration: 0.1));
    add(scaleEffect);
    super.onMount();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    // TODO: implement onCollisionStart
    if (other is JoystickPlayer) {
      other.setMovementBoundary(
          maxX: other.movementBoundary[1],
          minX: other.movementBoundary[0],
          maxY: other.movementBoundary[3],
          minY: position.y + (size.y * scale.y));
    }
    super.onCollisionStart(intersectionPoints, other);
  }
}
