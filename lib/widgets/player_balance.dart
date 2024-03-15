import 'package:flame/game.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:oceanoasis/my_game.dart';

class BalanceWidget extends StatefulWidget {
  final MyGame game;
  const BalanceWidget({required this.game, super.key});

  @override
  State<BalanceWidget> createState() => _BalanceWidgetState();
}

class _BalanceWidgetState extends State<BalanceWidget> {
  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.topRight,
        child: Container(
          width: 180,
          height: 60,
          child: Material(
            color: Colors.transparent,
            child: ListenableBuilder(
                listenable: widget.game.playerData,
                builder: (BuildContext context, Widget? child) {
                  return Stack(
                    children: [
                      Positioned.fill(
                          child: SpriteWidget(
                              sprite: Sprite(
                                  widget.game.images
                                      .fromCache('ui/ui-buttons.png'),
                                  srcPosition: Vector2(15 * 16, 0),
                                  srcSize: Vector2(13 * 16, 5 * 16)))),
                      Center(
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    right: 35.0, bottom: 5),
                                child: SizedBox(
                                  width: 32,
                                  height: 32,
                                  child: SpriteWidget(
                                      sprite: Sprite(
                                          widget.game.images
                                              .fromCache('ui/ui-buttons.png'),
                                          srcPosition:
                                              Vector2(10 * 16, 14 * 16),
                                          srcSize: Vector2(3 * 16, 3 * 16))),
                                ),
                              ),
                            ),
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 30.0),
                                  child: Text(
                                    widget.game.playerData.gameBalance
                                        .toString(),
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white),
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ],
                  );
                }),
          ),
        ));
  }
}
