import 'package:flame/game.dart';
import 'package:flutter/material.dart' hide Route;
import 'package:oceanoasis/homescreen.dart';
import 'package:oceanoasis/property/defaultgameProperty.dart';
import 'package:oceanoasis/maps/pacificunderwater.dart';

class LevelSelection extends StatelessWidget {
  static String id = 'LevelSelection';
  const LevelSelection({super.key, this.onLevelSelected});
 
  final ValueChanged<int>? onLevelSelected;
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
    Map<String, dynamic> levelProperty = LevelProperty.levelProperty;
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
              onLevelSelected!.call(value['levelNumber']);
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
