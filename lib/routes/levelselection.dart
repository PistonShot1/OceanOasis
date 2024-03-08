import 'package:flame/game.dart';
import 'package:flutter/material.dart' hide Route;
import 'package:oceanoasis/property/levelProperty.dart';
import 'package:oceanoasis/routes/gameplay.dart';
import 'package:oceanoasis/property/defaultgameProperty.dart';
import 'package:oceanoasis/maps/underwater/pacificunderwater.dart';

// ignore: must_be_immutable
class LevelSelection extends StatefulWidget {
  static String id = 'LevelSelection';
  LevelSelection(
      {super.key,
      this.onLevelSelected,
      required this.toFacility,
      required this.toBossWorldSelection});

  final ValueChanged<int>? onLevelSelected;
  VoidCallback toFacility;
  VoidCallback toBossWorldSelection;
  @override
  State<LevelSelection> createState() => _LevelSelectionState();
}

class _LevelSelectionState extends State<LevelSelection> {
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Stack(children: [
        Positioned.fill(
            child: Image.asset(
          'assets/images/main-menu-background.jpg',
          fit: BoxFit.cover,
        )),
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: InkWell(
                    onTap: () {
                      widget.toFacility();
                    },
                    child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.blue,
                            boxShadow: const [
                              BoxShadow(color: Colors.black, blurRadius: 2)
                            ]),
                        child: Image.asset('assets/images/ui/recycle.png')),
                  ),
                ),
                InkWell(
                  onTap: () {
                    widget.toBossWorldSelection();
                  },
                  child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.blue,
                          boxShadow: const [
                            BoxShadow(color: Colors.black, blurRadius: 2)
                          ]),
                      child: Image.asset('assets/images/earth-pixel-icon.png')),
                )
              ],
            ),
          ),
        ),
        Positioned(
          child: Container(
            padding: EdgeInsets.all(50),
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Flexible(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      'Level Selection',
                      style: TextStyle(
                        fontSize: 40,
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: 4,
                  child: SingleChildScrollView(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: buildColumn(),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }

  List<Row> buildColumn() {
    Map<int, dynamic> levelProperty = LevelProperty.levelProperty;
    List<Widget> buttonList = [];
    List<Row> columnList = [];
    columnList.add(Row(
      children: buttonList,
    ));
    levelProperty.forEach((key, value) {
      buttonList.add(Padding(
        padding: const EdgeInsets.all(20.0),
        child: ElevatedButton(
            style: ButtonStyle(
                padding: MaterialStateProperty.all(const EdgeInsets.all(20))),
            onPressed: () {
              widget.onLevelSelected!.call(value['levelNumber']);
            },
            child: Column(
              children: [Text('Level $key')],
            )),
      ));
      if (buttonList.length > 3) {
        buttonList = [];
        columnList.add(Row(
          children: buttonList,
        ));
      }
    });

    return columnList;
  }
}
