import 'dart:async';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:oceanoasis/homescreen.dart';

class MainWidget extends StatefulWidget {
  const MainWidget({Key? key}) : super(key: key);

  @override
  _MainWidgetState createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  late Timer _timer;
  double _opacity = 0.0;
  double iconButtonSize = 35;
  double text1 = 50;
  double text2 = 30;
  @override
  void initState() {
    super.initState();
    // Start the fade in/out animation
    _startAnimation();
  }

  void _startAnimation() {
    _timer = Timer.periodic(const Duration(milliseconds: 600), (timer) {
      setState(() {
        _opacity = _opacity == 0.0 ? 1.0 : 0.0;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _rescaleFont([iconButtonSize, text1, text2]);
    return Scaffold(
      backgroundColor: const Color(0XFF88B2D2),
      body: InkWell(
        onTap: () {
          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (context) {
            return GameWidget(
              game: MyGame(),
              loadingBuilder: (p0) {
                return Stack(
                  children: [
                    Positioned.fill(
                        child: Image.asset(
                            'assets/images/main-menu-background.jpg')),
                    const Align(
                      alignment: Alignment.center,
                      child: Material(
                        color: Colors.transparent,
                        child: Text('Loading . . .'),
                      ),
                    )
                  ],
                );
              },
            );
          }));
        },
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset('assets/images/main-menu-background.jpg'),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.6,
                width: MediaQuery.of(context).size.width * 0.6,
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                        child: Text(
                      'Ocean Oasis',
                      style: TextStyle(fontSize: text1),
                    )),
                    Expanded(
                      child: AnimatedOpacity(
                        opacity: _opacity,
                        duration: const Duration(seconds: 1),
                        child: Text(
                          'Tap Anywhere to Play !',
                          style: TextStyle(fontSize: text2, color: Colors.blue),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: IconButton(
                              iconSize: iconButtonSize,
                              onPressed: () {
                                print('Icon button was pressed');
                              },
                              icon: const Icon(Icons.person),
                              style: ButtonStyle(
                                padding: MaterialStateProperty.all(
                                  EdgeInsets.all(10),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: IconButton(
                              iconSize: iconButtonSize,
                              onPressed: () {
                                print('Icon button was pressed');
                              },
                              icon: const Icon(Icons.emoji_events),
                              color: Colors.amber,
                              style: ButtonStyle(
                                padding: MaterialStateProperty.all(
                                  EdgeInsets.all(10),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: IconButton(
                              iconSize: iconButtonSize,
                              onPressed: () {
                                print('Icon button was pressed');
                              },
                              icon: const Icon(Icons.settings),
                              color: Colors.grey,
                              style: ButtonStyle(
                                padding: MaterialStateProperty.all(
                                  EdgeInsets.all(10),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _rescaleFont(List<double> fontSizes) {
    if (MediaQuery.of(context).size.width < 900 ||
        MediaQuery.of(context).size.height < 500) {
      setState(() {
        text1 = 35;
        text2 = 20;
        iconButtonSize = 35;
      });
    } else {
      setState(() {
        iconButtonSize = 35;
        text1 = 50;
        text2 = 30;
      });
    }
  }
}
