import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';
import 'package:oceanoasis/components/maps/BossFight/bossfightplayer.dart';

class PlayerBar extends PositionComponent {
  BossFightPlayer playerRef;
  PlayerBar({
    required Vector2 position,
    required this.playerRef,
  }) : super(position: position);

  @override
  FutureOr<void> onLoad() {
    // For debug
    // debugColor = Colors.black;
    // debugMode = true;
    size = playerRef.size;
    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    double barWidth =
        (playerRef.currentHealth / playerRef.maxHealth) * playerRef.size.x;
    canvas.drawRect(
        Rect.fromLTWH(0, 0, barWidth, 10), Paint()..color = Colors.red);
    double energybarWidth =
        (playerRef.currentEnergyLevel / playerRef.MaxEnergyLevel) *
            playerRef.size.x;
    canvas.drawRect(Rect.fromLTWH(0, 10, energybarWidth, 10),
        Paint()..color = Colors.purple);

    super.render(canvas);
  }
}
