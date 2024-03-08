import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:oceanoasis/property/defaultgameProperty.dart';
import 'package:oceanoasis/property/levelProperty.dart';
import 'package:oceanoasis/routes/gameplay.dart';

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
      height: 100,
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
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/score-icon/paper.png',
                        width: 50,
                        height: 50,
                      ),
                      Text(
                          '${widget.game.playerData.levelwasteScores[WasteType.paper]!.toInt()}')
                    ],
                  ),
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/score-icon/plastic.png',
                        width: 50,
                        height: 50,
                      ),
                      Text(
                          '${widget.game.playerData.levelwasteScores[WasteType.plastic]!.toInt()}')
                    ],
                  ),
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/score-icon/metal.png',
                        width: 50,
                        height: 50,
                      ),
                      Text(
                          '${widget.game.playerData.levelwasteScores[WasteType.metal]!.toInt()}')
                    ],
                  ),
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/score-icon/nuclear.png',
                        width: 50,
                        height: 50,
                      ),
                      Text(
                          '${widget.game.playerData.levelwasteScores[WasteType.radioactive]!.toInt()}')
                    ],
                  ),
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/score-icon/glass.png',
                        width: 50,
                        height: 50,
                      ),
                      Text(
                          '${widget.game.playerData.levelwasteScores[WasteType.glass]!.toInt()} ')
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text(
                        '${widget.game.playerData.levelcurrentScore.toInt()} / ${LevelProperty.levelProperty[widget.game.currentLevel]['maxSpawn']}'),
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
