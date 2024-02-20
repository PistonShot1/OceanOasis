import 'dart:async';
import 'package:flame/game.dart';
import 'package:flutter/material.dart' hide Route;
import 'package:oceanoasis/routes/homescreen.dart';
import 'package:oceanoasis/maps/pacific.dart';
import 'package:oceanoasis/routes/achievementdashboard.dart';
import 'package:oceanoasis/routes/levelselection.dart';
import 'package:oceanoasis/routes/maplevelselection.dart';
import 'package:oceanoasis/routes/settings.dart';
import 'package:oceanoasis/routes/userprofile.dart';

class MainMenu extends StatefulWidget {
  static const id = 'MainMenu';

  const MainMenu({Key? key}) : super(key: key);

  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
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
      backgroundColor: Colors.black,
      body: InkWell(
        onTap: () {
          oldWidget(context);
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
                                _showOverlay(UserProfile.id);
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
                              onPressed: () =>
                                  _showOverlay(AchievementDashboard.id),
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
                              onPressed: () => _showOverlay(Settings.id),
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
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: IconButton(
                  icon: Icon(Icons.shopping_cart),
                  onPressed: () {},
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void oldWidget(BuildContext context) {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
      return GameWidget(
        game: MyGame(MediaQuery.of(context)),
        loadingBuilder: (p0) {
          return Stack(
            children: [
              Image.asset('assets/images/main-menu-background.jpg'),
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
        overlayBuilderMap: {
          "TopMenu": (context, MyGame game) {
            return Material(
              color: Colors.transparent,
              child: Align(
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
                            game.router.pushNamed(LevelSelection.id);
                          },
                          child: Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.blue,
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Colors.black, blurRadius: 2)
                                  ]),
                              child:
                                  Image.asset('assets/images/dive-icon.png')),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          game.toBossWorldSelection();
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
                            child: Image.asset(
                                'assets/images/earth-pixel-icon.png')),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
          "TopMenu2": (context, MyGame game) {
            return Material(
              color: Colors.transparent,
              child: Align(
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
                            game.toFacility();
                          },
                          child: Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.blue,
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Colors.black, blurRadius: 2)
                                  ]),
                              child:
                                  Image.asset('assets/images/ui/recycle.png')),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          game.router.pushReplacementNamed(LevelSelection.id);
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
                            child: Image.asset('assets/images/dive-icon.png')),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
          "Score": (context, MyGame game) {
            return Align(
              alignment: Alignment.topCenter,
              child: ValueListenableBuilder<double>(
                valueListenable: game.player.currentLoad,
                builder: (BuildContext context, double value, Widget? child) {
                  return Material(
                      color: Colors.transparent, child: Text('$value'));
                },
              ),
            );
          }
        },
        initialActiveOverlays: [],
        // to add game overlay
      );
    }));
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

  void newWidget(BuildContext context) {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
      return Container();
    }));
  }

  void _showOverlay(String routeName) {
    final musicValueNotifier = ValueNotifier(true);
    final sfxValueNotifier = ValueNotifier(true);

    switch (routeName) {
      case AchievementDashboard.id:
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return AchievementDashboard(
            musicValueListenable: musicValueNotifier,
            sfxValueListenable: sfxValueNotifier,
            onBackPressed: _popRoute,
          );
        }));
        break;
      case Settings.id:
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return Settings(
            musicValueListenable: musicValueNotifier,
            sfxValueListenable: sfxValueNotifier,
            onBackPressed: _popRoute,
          );
        }));
        break;
      case UserProfile.id:
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return UserProfile(
            musicValueListenable: musicValueNotifier,
            sfxValueListenable: sfxValueNotifier,
            onBackPressed: _popRoute,
          );
        }));
        break;
    }
  }

  void _popRoute() {
    Navigator.of(context).pop();
  }
}
