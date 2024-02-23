import 'package:flutter/material.dart';
import 'package:oceanoasis/routes/gameplay.dart';

class GameOver extends StatelessWidget {
  static const String id = 'Game Over';
  final void Function(int level) nextLevel;
  final VoidCallback back;
  final MyGame game;
  const GameOver(
      {super.key,
      required this.nextLevel,
      required this.back,
      required this.game});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          width: 300,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Color(0xFF1a1a1a),
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 4,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Game Over',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                ),
              ),
              SizedBox(height: 20),
              ValueListenableBuilder<double>(
                valueListenable: game.player.currentLoad,
                builder: (BuildContext context, double value, Widget? child) {
                  return Text(
                    'Score: $value',
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 18,
                    ),
                  );
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF008cba),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Text(
                    'Restart',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: InkWell(
                      onTap: () {
                        game.resumeEngine();
                        game.toMapSelection();
                      },
                      child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color(0xFF008cba),
                              boxShadow: [
                                BoxShadow(color: Colors.black, blurRadius: 2)
                              ]),
                          child: Image.asset(
                              'assets/images/earth-pixel-icon.png')),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
      // Stack(
      //   children: [
      //     Positioned.fill(
      //       child: Padding(
      //         padding: EdgeInsets.fromLTRB(
      //           MediaQuery.of(context).size.width * 0.3 * 0.5,
      //           MediaQuery.of(context).size.height * 0.3 * 0.5,
      //           MediaQuery.of(context).size.width * 0.3 * 0.5,
      //           MediaQuery.of(context).size.height * 0.3 * 0.5,
      //         ),
      //         child: Image.asset(
      //           'assets/images/ui/pane.png',
      //           fit: BoxFit.fitHeight,
      //         ),
      //       ),
      //     ),
      //     Center(
      //       child: Container(
      //         height: MediaQuery.of(context).size.height * 0.5,
      //         width: MediaQuery.of(context).size.width * 0.3,
      //         decoration: const BoxDecoration(
      //           color: Colors.transparent,
      //           borderRadius: BorderRadius.all(Radius.circular(10)),
      //         ),
      //         child: Column(
      //           children: [
      //             const Expanded(
      //                 flex: 2,
      //                 child: Text(
      //                   'Game Over',
      //                   style: TextStyle(fontSize: 30),
      //                 )),
      //             const Expanded(
      //                 flex: 1,
      //                 child: Text(
      //                   'Level XXXX',
      //                   style: TextStyle(fontSize: 20),
      //                 )),
      //             const Expanded(
      //                 flex: 1,
      //                 child: Text(
      //                   'Points XXXX',
      //                   style: TextStyle(fontSize: 20),
      //                 )),
      //             Flexible(
      //               flex: 1,
      //               child: ElevatedButton(
      //                   onPressed: () {
      //                     nextLevel.call(5); //hard coded value for now
      //                   },
      //                   child: const Text('Next Level')),
      //             ),
      //             Flexible(
      //               flex: 1,
      //               child: Padding(
      //                 padding: const EdgeInsets.all(10.0),
      //                 child: Row(
      //                   mainAxisAlignment: MainAxisAlignment.center,
      //                   children: [

      //                     InkWell(
      //                       onTap: () {},
      //                       child: Container(
      //                           height: 50,
      //                           width: 50,
      //                           decoration: BoxDecoration(
      //                               borderRadius: BorderRadius.circular(10),
      //                               color: Colors.blue,
      //                               boxShadow: [
      //                                 BoxShadow(
      //                                     color: Colors.black, blurRadius: 2)
      //                               ]),
      //                           child: Image.asset(
      //                               'assets/images/earth-pixel-icon.png')),
      //                     )
      //                   ],
      //                 ),
      //               ),
      //             )
      //           ],
      //         ),
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}
