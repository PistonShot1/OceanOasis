import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:oceanoasis/maps/overworld/overworldplayer.dart';


class LadderComponent extends PositionComponent with CollisionCallbacks {
  LadderComponent({required Vector2 size, required Vector2 position})
      : super(size: size, position: position);

  @override
  FutureOr<void> onLoad() {
    // TODO: implement onLoad
    add(RectangleHitbox()..collisionType = CollisionType.passive);
    return super.onLoad();
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    // TODO: implement onCollisionStart

    super.onCollisionStart(intersectionPoints, other);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    // TODO: implement onCollision
    if (other is OverworldPlayer) {
      // other.position.y = other.position.y
      //     .clamp(position.y - 20, position.y + size.y - other.size.y / 2);
      // other.position.x =
      //     other.position.x.clamp(position.x, position.x + size.x);
    }
    super.onCollision(intersectionPoints, other);
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    // TODO: implement onCollisionEnd
    if (other is OverworldPlayer) {
    }
    super.onCollisionEnd(other);
  }
}
