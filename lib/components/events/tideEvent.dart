import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/flame.dart';
import 'package:flame/particles.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';
import 'package:oceanoasis/components/events/whirlpool.dart';
import 'package:oceanoasis/components/players/joystickplayer.dart';

class TideEvent extends PositionComponent {
  final bool tideEvent;
  int duration;
  JoystickPlayer player;

  bool eventTidemovePlayer = true;
  Sprite cloud = Sprite(Flame.images.fromCache('events/black-cloud.png'));
  Random random = Random();
  int?
      eventNum; // 0 corresponds to tide from left and 1 corresponds to tide from right
  Map<int, String> tideDirection = {0: 'Left', 1: 'Right'};

  bool onWarningComplete = false;
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
  void onMount() async {
    // TODO: implement onMount
    debugMode = true;
    onWarningComplete = await warning();

    addClouds();
    highTideEvent();
    addPortals();
    Future.delayed(Duration(seconds: duration), () {
      removeFromParent();
    });

    super.onMount();
  }

  Future<bool> warning() async {
    TextPaint regular = TextPaint(
      style: const TextStyle(
        fontFamily: 'Retro Gaming',
        fontSize: 48.0,
        color: Colors.white,
      ),
    );
    final text = TextComponent(
        text: 'Current tide is from : ${tideDirection[eventNum]}',
        textRenderer: regular,
        position: Vector2(size.x / 2, 100),
        priority: 2);
    add(text
      ..position = Vector2(text.position.x - text.size.x, text.position.y));
    await Future.delayed(Duration(seconds: 3), () {
      remove(text);
    });
    return true;
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
    if (onWarningComplete) {
      highTideEventMovePlayer();
    }
    super.update(dt);
  }

  void highTideEventMovePlayer() {
    if (eventTidemovePlayer) {
      switch (eventNum) {
        case 0:
          eventTidemovePlayer = false;
          player.add(
              MoveEffect.by(Vector2(1200 * 1, 0), EffectController(duration: 5))
                ..onComplete = () {
                  eventTidemovePlayer = true;
                });
        case 1:
          eventTidemovePlayer = false;
          player.add(MoveEffect.by(
              Vector2(1200 * -1, 0), EffectController(duration: 5))
            ..onComplete = () {
              eventTidemovePlayer = true;
            });
      }
    }
  }

  void highTideEvent() {
    switch (eventNum) {
      case 0:
        player.highTideSlower[0] = 0.5;
      case 1:
        player.highTideSlower[1] = 0.5;
    }
  }

  @override
  void onRemove() {
    // TODO: implement onRemove
    print('exited');
    super.onRemove();
  }

  void addPortals() {
    _linkPortals(Whirlpool(), Whirlpool(), Vector2(100, size.y / 3),
        Vector2(size.x - 150, size.y / 3));
    _linkPortals(Whirlpool(), Whirlpool(), Vector2(100, size.y / 2),
        Vector2(size.x - 150, size.y / 2));
    _linkPortals(Whirlpool(), Whirlpool(), Vector2(100, size.y * 2 / 3),
        Vector2(size.x - 150, size.y * 2 / 3 ));
  }

  void _linkPortals(Whirlpool portal1, Whirlpool portal2, Vector2 position1,
      Vector2 position2) {
    portal1.linkPortal = portal2;
    portal2.linkPortal = portal1;
    add(portal1..position = position1);
    add(portal2..position = position2);
  }
}
