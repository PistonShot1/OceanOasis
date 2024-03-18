import 'package:flutter/material.dart';
import 'package:oceanoasis/my_game.dart';

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
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF1a1a1a),
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 4,
                offset: const Offset(0, 4),
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
              const SizedBox(height: 20),
              ListenableBuilder(
                listenable: game.playerData,
                builder: (BuildContext context, Widget? child) {
                  return Text(
                    'Score: ${game.playerData.levelcurrentScore}',
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 18,
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: InkWell(
                      onTap: () {
                        game.resumeEngine();
                        game.router.pop();
                        game.toMapSelection();
                      },
                      child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color(0xFF008cba),
                              boxShadow: const [
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
    );
  }
}
