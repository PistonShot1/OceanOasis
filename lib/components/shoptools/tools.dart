import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:oceanoasis/property/game_properties.dart';
import 'package:oceanoasis/components/shoptools/slash_effect.dart';

class Tools extends SpriteComponent with CollisionCallbacks {
  String? id;
  RectangleHitbox hitbox = RectangleHitbox();
  SlashEffect? slashEffect;
  List<WasteType>? slashType;
  Tools(
      {
      required Sprite sprite,
      required Vector2 size,
      required Vector2 position,
      this.slashEffect,
      this.slashType,
      this.id})
      : super(
          sprite: sprite,
          position: position,
          size: size,
        );

   


  @override
  FutureOr<void> onLoad() {
    // TODO: implement onLoad
    add(hitbox..collisionType = CollisionType.inactive);
    return super.onLoad();
  }
}
