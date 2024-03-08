import 'dart:async';
import 'package:flame/game.dart';
import 'package:flutter/material.dart' hide Route;
import 'package:oceanoasis/property/playerProperty.dart';
import 'package:oceanoasis/routes/playerBalance.dart';
import 'package:oceanoasis/routes/playerScores.dart';
import 'package:oceanoasis/routes/gameplay.dart';
import 'package:oceanoasis/maps/overworld/pacific.dart';
import 'package:oceanoasis/routes/achievementdashboard.dart';
import 'package:oceanoasis/routes/levelselection.dart';
import 'package:oceanoasis/routes/maplevelselection.dart';
import 'package:oceanoasis/routes/settings.dart';
import 'package:oceanoasis/routes/totalScoreWidget.dart';
import 'package:oceanoasis/routes/userprofile.dart';
import 'package:provider/provider.dart';

class MainMenu extends StatefulWidget {
  static const id = 'MainMenu';

  const MainMenu({Key? key}) : super(key: key);

  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  double iconButtonSize = 35;
  double text1 = 50;
  double text2 = 30;
  PlayerProperty playerData = PlayerProperty(tools: [], weapons: []);

  @override
  Widget build(BuildContext context) {
    _rescaleFont([iconButtonSize, text1, text2]);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/main-menu/background.png',
              fit: BoxFit.cover,
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              // color: Colors.black,
              padding: const EdgeInsets.all(20),
              height: MediaQuery.of(context).size.height * 0.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      initGameWidget(context);
                    },
                    child: Image.asset(
                      'assets/images/ui/play-button.png',
                      width: 300,
                      height: 100,
                    ),
                  ),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          _showOverlay(AchievementDashboard.id);
                        },
                        child: Image.asset(
                          'assets/images/ui/shop-button.png',
                          width: 150,
                          height: 50,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          _showOverlay(Settings.id);
                        },
                        child: Image.asset(
                          'assets/images/ui/settings-button.png',
                          height: 50,
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      InkWell(
                        onTap: () {},
                        child: Image.asset(
                          'assets/images/ui/user-button.png',
                          height: 50,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void initGameWidget(BuildContext context) {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
      return GameWidget(
        game: MyGame(MediaQuery.of(context), playerData: playerData),
        loadingBuilder: (p0) {
          return Stack(
            children: [
              Positioned.fill(
                  child: Image.asset(
                'assets/images/main-menu/background.png',
                fit: BoxFit.fill,
              )),
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
          "ToMapSelection": (context, MyGame game) {
            return Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                width: 50,
                height: 50,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      game.router.pushRoute(Route(() => MapLevelSelection()));
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
                        child:
                            Image.asset('assets/images/earth-pixel-icon.png')),
                  ),
                ),
              ),
            );
          },
          "ToFacility": (context, MyGame game) {
            return Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                width: 50,
                height: 50,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      game.toFacility();
                    },
                    child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.transparent,
                            boxShadow: const [
                              BoxShadow(color: Colors.black, blurRadius: 2)
                            ]),
                        child: Stack(
                          children: [
                            Positioned.fill(
                                child: Image.asset(
                              'assets/images/ui/button-ui.png',
                              fit: BoxFit.fill,
                            )),
                            Center(
                                child: Image.asset(
                                    'assets/images/ui/recycle.png',
                                    fit: BoxFit.cover))
                          ],
                        )),
                  ),
                ),
              ),
            );
          },
          "Score": (context, MyGame game) {
            return Align(
              alignment: Alignment.topCenter,
              child: ListenableBuilder(
                listenable: game.playerData,
                builder: (BuildContext context, Widget? child) {
                  return Material(
                      color: Colors.transparent,
                      child: Text('${game.playerData.currentScore}'));
                },
              ),
            );
          },
          "WasteScores": (context, MyGame game) {
            return ScoreWidget(game: game);
          },
          "TotalScores": (context, MyGame game) {
            return TotalScoreWidget(game: game);
          },
          "GameBalance": (context, MyGame game) {
            return BalanceWidget(game: game);
          },
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
