import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:oceanoasis/property/defaultgameProperty.dart';
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
      width: MediaQuery.of(context).size.width,
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
                      Image.asset('assets/images/score-icon/paper.png', width: 50,height: 50,),
                      Text(
                          '${widget.game.playerData.wasteScores.value[WasteType.paper]}')
                    ],
                  ),
                  Row(
                    children: [
                      Image.asset('assets/images/score-icon/plastic.png',width: 50,height: 50,),
                      Text(
                          '${widget.game.playerData.wasteScores.value[WasteType.plastic]}')
                    ],
                  ),
                  Row(
                    children: [
                      Image.asset('assets/images/score-icon/metal.png',width: 50,height: 50,),
                      Text(
                          '${widget.game.playerData.wasteScores.value[WasteType.metal]}')
                    ],
                  ),
                  Row(
                    children: [
                      Image.asset('assets/images/score-icon/nuclear.png',width: 50,height: 50,),
                      Text(
                          '${widget.game.playerData.wasteScores.value[WasteType.radioactive]}')
                    ],
                  ),
                  Row(
                    children: [
                      Image.asset('assets/images/score-icon/glass.png',width: 50,height: 50,),
                      Text(
                          '${widget.game.playerData.wasteScores.value[WasteType.glass]}')
                    ],
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
