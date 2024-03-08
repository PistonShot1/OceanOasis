import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart' hide Route, OverlayRoute;
import 'package:oceanoasis/routes/challengeBossSelection.dart';
import 'package:oceanoasis/routes/gameplay.dart';
import 'package:oceanoasis/maps/overworld/pacific.dart';

class MapMarker extends SpriteComponent
    with TapCallbacks, HasGameReference<MyGame> {
  final Vector2 locationOnMap;
  String locationName;
  Route bossFightSceneRoute;
  Route levelChallengeRoute;
  int levelNumber;
  MapMarker(
      {required this.locationOnMap,
      required this.locationName,
      required this.bossFightSceneRoute,
      required this.levelChallengeRoute,
      required this.levelNumber})
      : super.fromImage(Flame.images.fromCache('map-location-icon.png'),
            position: locationOnMap);
  @override
  FutureOr<void> onLoad() {
    addTextComponent();
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
              levelNumber: levelNumber,
              toChallengeLevel: () {
                game.router.pop();
                (game).router.pushRoute(levelChallengeRoute);
              },
              toBossWorldSelection: () {
                game.router.pop();
                (game).router.pushRoute(bossFightSceneRoute);
              },
              locationName: locationName,
              game: game as MyGame,
            )),
        name: ChallengeBossSelection.id);
    super.onTapUp(event);
  }

  void addTextComponent() {
    add(TextComponent(text: 'Level $levelNumber')
      ..anchor = Anchor.topCenter
      ..position = Vector2(size.x / 2, size.y));
  }
}
