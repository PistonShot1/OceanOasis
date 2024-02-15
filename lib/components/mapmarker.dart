import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart' hide Route;
import 'package:oceanoasis/homescreen.dart';
import 'package:oceanoasis/maps/pacific.dart';

class MapMarker extends SpriteComponent
    with TapCallbacks, HasGameReference<MyGame> {
  late ShapeHitbox hitbox;
  final _defaultColor = Colors.cyan;
  final Vector2 locationOnMap;
  final bool isMapAvailable;

  Component Function()? sceneLoadCallback; //not in user rn
  String? mapName;

  String? mapId;
  MapMarker(
      {required this.locationOnMap,
      required this.isMapAvailable,
      required ComponentKey key,
      this.mapId,
      this.sceneLoadCallback,
      this.mapName})
      : super.fromImage(Flame.images.fromCache('map-location-icon.png'),
            position: locationOnMap, key: key);
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
    if (mapName != null) {
      game.router.pushReplacement(
          Route(() => PacificOcean(key: ComponentKey.named(PacificOcean.id))),
          name: PacificOcean.id);
    }
    print('something was tapped');
    super.onTapUp(event);
  }

  @override
  void onLongTapDown(TapDownEvent event) {
    // TODO: implement onLongTapDown (for viewing picture and area)
    super.onLongTapDown(event);
  }
}
