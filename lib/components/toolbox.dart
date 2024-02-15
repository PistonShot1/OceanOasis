import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/services/keyboard_key.g.dart';
import 'package:oceanoasis/homescreen.dart';
import 'package:oceanoasis/tools/papercollector.dart';

class ItemToolBox extends SpriteComponent
    with TapCallbacks, KeyboardHandler, HasGameReference<MyGame> {
  final VoidCallback callback;
  LogicalKeyboardKey keybind;
  PaperCollector iconItem;
  PaperCollector? item;

  ItemToolBox(this.callback,
      {required this.iconItem,
      required this.keybind,
      required Vector2 position,
      this.item})
      : super.fromImage(
          Flame.images.fromCache('ui/item-ui.png'),
          srcPosition: Vector2(16 * 2, 16 * 2),
          srcSize: Vector2.all(16 * 2),
          scale: Vector2.all(2),
          position: position,
        );
  @override
  FutureOr<void> onLoad() async {
    // TODO: implement onLoad
    iconItem.position = Vector2(size.x/(2*scale.x), size.y/(2*scale.y));
    add(iconItem);
    return super.onLoad();
  }

  @override
  void onTapUp(TapUpEvent event) {
    // TODO: implement onTapUp
    super.onTapUp(event);
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    // TODO: implement onKeyEvent
    itemSelection(keysPressed);
    return super.onKeyEvent(event, keysPressed);
  }

  void itemSelection(Set<LogicalKeyboardKey> keysPressed) {
    if (keysPressed.contains(keybind)) {
      if (item != null) {
        game.player.setCurrentTool(item!);
      }
    }
  }
}
