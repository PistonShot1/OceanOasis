import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:oceanoasis/maps/overworld/overworldplayer.dart';

class BoundaryBlock extends PositionComponent with CollisionCallbacks {
  BoundaryBlock({required Vector2 position, required Vector2 size})
      : super(position: position, size: size);
  @override
  FutureOr<void> onLoad() {
    debugColor = Colors.black;

    final hitbox = RectangleHitbox.relative(Vector2(1, 1), parentSize: size);
    add(hitbox..debugColor = Colors.green);
    return super.onLoad();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    // TODO: implement onCollision
    if (other is OverworldPlayer) {
      if (other.scale.x > 0) {
        other.position.x =
            other.position.x.clamp(0, position.x - other.size.x / 2);
      } else if (other.scale.x < 0) {
        other.position.x = other.position.x
            .clamp(position.x + size.x + other.size.x / 2, 1920);
      }
    }
    super.onCollision(intersectionPoints, other);
  }
}
