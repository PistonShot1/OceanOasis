import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart' hide Route, OverlayRoute;
import 'package:oceanoasis/routes/challengeBossSelection.dart';
import 'package:oceanoasis/routes/gameplay.dart';
import 'package:oceanoasis/maps/pacific.dart';

class MapMarker extends SpriteComponent
    with TapCallbacks, HasGameReference<MyGame> {
  late ShapeHitbox hitbox;
  final _defaultColor = Colors.cyan;

  final Vector2 locationOnMap;
  VoidCallback bossFightSceneRoute;
  VoidCallback levelChallengeRoute; //not in user rn

  String? mapId;
  MapMarker({
    required this.locationOnMap,
    this.mapId,
    required this.bossFightSceneRoute,
    required this.levelChallengeRoute,
  }) : super.fromImage(Flame.images.fromCache('map-location-icon.png'),
            position: locationOnMap);
  @override
  FutureOr<void> onLoad() {
    // TODO: implement onLoad
    final defaultPaint = Paint()
      ..color = _defaultColor
      ..style = PaintingStyle.stroke;
    hitbox = RectangleHitbox()
      ..paint = defaultPaint
      ..renderShape = true;
    add(hitbox);
    return super.onLoad();
  }

  @override
  void onMount() {
    // TODO: implement onMount

    super.onMount();
  }

  @override
  void onTapUp(TapUpEvent event) async {
    game.router.pushRoute(
        OverlayRoute((context, game) => ChallengeBossSelection(
              toChallengeLevel: levelChallengeRoute,
              toBossWorldSelection: bossFightSceneRoute,
              locationName: '',
            )),
        name: ChallengeBossSelection.id);
    super.onTapUp(event);
  }

  @override
  void onLongTapDown(TapDownEvent event) {
    // TODO: implement onLongTapDown (for viewing picture and area)
    super.onLongTapDown(event);
  }
}
