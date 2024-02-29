import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/flame.dart';
import 'package:flame/particles.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';
import 'package:oceanoasis/components/players/joystickplayer.dart';

class TideEvent extends PositionComponent {
  final bool tideEvent;
  int duration;
  JoystickPlayer player;

  bool eventTidemovePlayer = true;
  Sprite cloud = Sprite(Flame.images.fromCache('events/black-cloud.png'));
  Random random = Random();
  Vector2 randomVector2() =>
      (Vector2.random(random) - Vector2.random(random)) * 200;
  int?
      eventNum; // 0 corresponds to tide from left and 1 corresponds to tide from right
  Map<int, String> tideDirection = {0: 'Left', 1: 'Right'};

  TideEvent(
      {required this.tideEvent,
      required this.duration,
      required Vector2 worldSize,
      required TiledComponent tiledMap,
      required this.player})
      : super(size: worldSize, position: Vector2.zero());
  @override
  FutureOr<void> onLoad() {
    // TODO: implement onLoad
    eventNum = random.nextInt(tideDirection.length);
    return super.onLoad();
  }

  @override
  void onMount() {
    // TODO: implement onMount
    debugMode = true;
    addClouds();

    highTideEvent();
    super.onMount();
  }

  void addClouds() {
    final cloud = _getCloud();
    add(cloud..position = Vector2(-cloud.size.x, size.y * 0.05));
    Future.delayed(Duration(seconds: 10), () {
      final cloud = _getCloud();
      add(cloud..position = Vector2(-cloud.size.x, size.y * 0.04));
    });
    Future.delayed(Duration(seconds: 20), () {
      final cloud = _getCloud();
      add(cloud..position = Vector2(-cloud.size.x, size.y * 0.02));
    });
  }

  SpriteComponent _getCloud() {
    final clouds = SpriteComponent(sprite: cloud);
    clouds.add(MoveEffect.by(Vector2(size.x + clouds.size.x, 0),
        EffectController(duration: 30, infinite: true)));
    return clouds;
  }

  @override
  void update(double dt) {
    // TODO: implement update
    highTideEventMovePlayer();
    super.update(dt);
  }

  void highTideEventMovePlayer() {
    if (eventTidemovePlayer) {
      switch (eventNum) {
        case 0:
          eventTidemovePlayer = false;
          player.add(
              MoveEffect.by(Vector2(300 * 1, 0), EffectController(duration: 5))
                ..onComplete = () {
                  eventTidemovePlayer = true;
                });
        case 1:
          eventTidemovePlayer = false;
          player.add(
              MoveEffect.by(Vector2(300 * -1, 0), EffectController(duration: 5))
                ..onComplete = () {
                  eventTidemovePlayer = true;
                });
      }
    }
  }

  void highTideEvent() {
    print('Current tide is from : ${tideDirection[eventNum]}');

    switch (eventNum) {
      case 0:
        player.highTideSlower[0] = 0.5;
      case 1:
        player.highTideSlower[1] = 0.5;
    }
  }
}
