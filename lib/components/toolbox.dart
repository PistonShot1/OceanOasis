import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/services/keyboard_key.g.dart';
import 'package:oceanoasis/routes/homescreen.dart';
import 'package:oceanoasis/tools/papercollector.dart';

class ItemToolBox extends SpriteComponent
    with TapCallbacks, KeyboardHandler, HasGameReference<MyGame> {
  VoidCallback? callback;
  LogicalKeyboardKey? keybind;
  PaperCollector iconItem;
  PaperCollector? item;
  bool detectTap = false;
  bool? focus = false;
  ItemToolBox(this.callback,
      {required this.iconItem,
      this.keybind,
      required Vector2 position,
      this.item,
      required this.detectTap})
      : super.fromImage(
          Flame.images.fromCache('ui/item-ui.png'),
          srcPosition: Vector2(16 * 2, 16 * 2),
          srcSize: Vector2.all(16 * 2),
          position: position,
        );
  @override
  FutureOr<void> onLoad() async {
    // TODO: implement onLoad
    iconItem.position = Vector2(size.x / (scale.x), size.y / (scale.y));
    add(iconItem..priority=1);
    return super.onLoad();
  }

  @override
  void onTapUp(TapUpEvent event) {
    // TODO: implement onTapUp
    itemSelection(detectTap: detectTap);
    super.onTapUp(event);
  }

  @override
  void update(double dt) {
    // TODO: implement update

    super.update(dt);
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    // TODO: implement onKeyEvent
    if (keybind != null) {
      itemSelection(keysPressed: keysPressed, detectTap: detectTap);
    }
    return super.onKeyEvent(event, keysPressed);
  }

  void itemSelection(
      {Set<LogicalKeyboardKey>? keysPressed, required bool detectTap}) {
    if (keysPressed?.contains(keybind) ?? false || detectTap) {
      if (item != null) {
        game.player.setCurrentTool(item!);
        add(game.player.currentToolIndicator..size=size); //set the indicator to it
      }
    }
  }
}
