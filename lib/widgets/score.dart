import 'package:flutter/material.dart';
import 'package:oceanoasis/my_game.dart';

class ScoreWidget extends StatefulWidget {
  final MyGame game;
  const ScoreWidget({super.key, required this.game});

  @override
  State<ScoreWidget> createState() => _ScoreWidgetState();
}

class _ScoreWidgetState extends State<ScoreWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.game.camera.viewport.virtualSize.x,
      height: 200,
      child: Align(
        alignment: Alignment.topCenter,
        child: Material(
          color: Colors.transparent,
          child: ListenableBuilder(
            listenable: widget.game.playerData,
            builder: (BuildContext context, Widget? child) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 50, left: 20.0),
                    child: Text(
                      'Score : ${widget.game.playerData.levelcurrentScore.toInt()}',
                      style: const TextStyle(fontSize: 30),
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
