import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:oceanoasis/property/levelProperty.dart';
import 'package:oceanoasis/my_game.dart';

class ChallengeSelection extends StatefulWidget {
  static String id = 'ChallengeBossSelection';
  VoidCallback toBossWorldSelection;
  VoidCallback toChallengeLevel;
  int levelNumber;
  String locationName;
  MyGame game;
  Map<String, dynamic> data = {};
  ChallengeSelection(
      {required this.toBossWorldSelection,
      required this.toChallengeLevel,
      required this.levelNumber,
      required this.locationName,
      required this.game,
      super.key});

  @override
  State<ChallengeSelection> createState() => _ChallengeSelectionState();
}

class _ChallengeSelectionState extends State<ChallengeSelection> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.canvas,
      color: Colors.transparent,
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.4,
          height: MediaQuery.of(context).size.height * 0.5,
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 5,
              offset: Offset(0, 10),
            )
          ]),
          child: Stack(
            children: [
              Positioned.fill(
                  child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  'assets/images/ui/shop-background.png',
                  fit: BoxFit.fill,
                ),
              )),
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                    onPressed: () {
                      widget.game.router.pop();
                    },
                    icon: Icon(
                      Icons.cancel_outlined,
                      size: 35,
                      color: Colors.white,
                    )),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Level ${widget.levelNumber}: ${widget.locationName}',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(50, 10, 50, 0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: SizedBox(
                          height:
                              MediaQuery.of(context).size.height * 0.5 * 0.4,
                          width: MediaQuery.of(context).size.width * 0.4 * 0.5,
                          child: LevelProperty.locationInfo[widget.levelNumber]
                              ['image'],
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          LevelProperty.locationInfo[widget.levelNumber]
                              ['history'],
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              widget.toChallengeLevel();
                            },
                            child: const Text(
                              'Underwater\nCleaning',
                              style: TextStyle(),
                              textAlign: TextAlign.center,
                            )),
                        ElevatedButton(
                          onPressed: () {
                            widget.toBossWorldSelection();
                          },
                          child: const Text(
                            'BossFight\nChallenge',
                            style: TextStyle(),
                            textAlign: TextAlign.center,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
