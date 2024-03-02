import 'package:flutter/material.dart';
import 'package:oceanoasis/property/defaultgameProperty.dart';
import 'package:oceanoasis/property/levelProperty.dart';
import 'package:oceanoasis/routes/gameplay.dart';

// ignore: must_be_immutable
class TotalScoreWidget extends StatefulWidget {
  MyGame game;
  TotalScoreWidget({required this.game, super.key});

  @override
  State<TotalScoreWidget> createState() => _TotalScoreWidgetState();
}

class _TotalScoreWidgetState extends State<TotalScoreWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: MediaQuery.of(context).size.height,
      child: Align(
        alignment: Alignment.topLeft,
        child: Material(
          color: Colors.transparent,
          child: ListenableBuilder(
            listenable: widget.game.playerData,
            builder: (BuildContext context, Widget? child) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/score-icon/paper.png',
                        width: 50,
                        height: 50,
                      ),
                      Text(
                          '${widget.game.playerData.levelwasteScores.value[WasteType.paper]!.toInt()}')
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
                          '${widget.game.playerData.levelwasteScores.value[WasteType.plastic]!.toInt()}')
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
                          '${widget.game.playerData.levelwasteScores.value[WasteType.metal]!.toInt()}')
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
                          '${widget.game.playerData.levelwasteScores.value[WasteType.radioactive]!.toInt()}')
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
                          '${widget.game.playerData.levelwasteScores.value[WasteType.glass]!.toInt()} ')
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
