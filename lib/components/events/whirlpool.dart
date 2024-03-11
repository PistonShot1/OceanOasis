import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:oceanoasis/maps/underwater/joystickplayer.dart';

class Whirlpool extends SpriteAnimationComponent with CollisionCallbacks {
  Whirlpool? linkPortal;
  Whirlpool()
      : super.fromFrameData(
            Flame.images.fromCache('events/whirlpool.png'),
            SpriteAnimationData.sequenced(
                amount: 10, textureSize: Vector2(128, 62), stepTime: 0.1),
            size: Vector2(128, 64));
  @override
  FutureOr<void> onLoad() {
    // TODO: implement onLoad
    add(CircleHitbox());
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    // TODO: implement onCollisionStart
    if (other is JoystickPlayer) {
      if (linkPortal != null) {
        other.position =
            linkPortal!.position + Vector2(other.size.x, 0) + linkPortal!.size;
      }
    }
    super.onCollisionStart(intersectionPoints, other);
  }
}
