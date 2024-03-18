import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';

class CountdownTimerComponent extends TextComponent with HasGameRef {
  late Timer _timer;
  int remainingTime;
  TextPaint textstyle = TextPaint(
    style: TextStyle(
        fontSize: 48.0,
        color: BasicPalette.white.color,
        fontFamily: 'Retro Gaming'),
  );
  CountdownTimerComponent(int countdownDuration)
      : remainingTime = countdownDuration,
        super(
          text: countdownDuration.toString(),

          // You can style your text component here
        ) {
    // Create a timer that ticks every second
    _timer = Timer(1, onTick: _onTick, repeat: true);
  }
  @override
  FutureOr<void> onLoad() {
    // TODO: implement onLoad
    textRenderer = textstyle;
    return super.onLoad();
  }

  @override
  void onMount() {
    super.onMount();
    _timer.start();
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Update the timer by the delta time
    _timer.update(dt);
  }

  void _onTick() {
    // Decrement the remaining time by one second
    remainingTime -= 1;
    text = remainingTime
        .toString(); // Update the text to display the remaining time

    // If the remaining time is zero, stop the timer
    if (remainingTime <= 0) {
      _timer.stop();
      _onTimerEnd();
    }
    if (remainingTime <= 10) {
      textstyle = TextPaint(
        style: TextStyle(
            fontSize: 48.0,
            color: BasicPalette.red.color,
            fontFamily: 'Retro Gaming'),
      );
    }
  }

  void _onTimerEnd() {
    // Handle what happens when the timer ends
    // For example, end the game or trigger an event
  }

  @override
  void onRemove() {
    // TODO: implement onRemove
    _timer.stop();
    super.onRemove();
  }
}
