import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart' hide Route;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:oceanoasis/property/playerProperty.dart';
import 'package:oceanoasis/property/userprofile.dart';
import 'package:oceanoasis/routes/level_selection_ui.dart';
import 'package:oceanoasis/routes/playerBalance.dart';
import 'package:oceanoasis/routes/playerScores.dart';
import 'package:oceanoasis/routes/gameplay.dart';
import 'package:oceanoasis/routes/maplevelselection.dart';
import 'package:oceanoasis/routes/totalScoreWidget.dart';
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

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  Map<String, dynamic> _data = {};

  //handle sign in for user
  Future<User?> _handleSignIn() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        final UserCredential authResult =
            await _auth.signInWithCredential(credential);
        final User? user = authResult.user;
        return user;
      }
    } catch (error) {
      print(error);
      return null;
    }
  }

  //Signout current and prompt user to sign in again
  Future<User?> _handleSignOut() async {
    try {
      await _auth.signOut();
      await googleSignIn.signOut();
      print("Sign out successful");
      await _handleSignIn();
    } catch (error) {
      print(error);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    _handleSignIn();
    super.initState();
  }

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
                    onTap: () async {
                      if (!Platform.isWindows &&
                          FirebaseAuth.instance.currentUser != null) {
                        await _loadUserData(context);
                        (context.mounted) ? initGameWidget(context) : '';
                      } else if (Platform.isWindows) {
                        initGameWidget(context);
                      } else {
                        showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                                  title: const Text('Alert !'),
                                  content: const Text(
                                      'Please makesure you are signed in!'),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('OK'))
                                  ],
                                ));
                      }
                    },
                    child: Image.asset(
                      'assets/images/ui/play-button.png',
                      width: 300,
                      height: 100,
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  InkWell(
                    onTap: () {
                      _handleSignOut();
                    },
                    child: Image.asset(
                      'assets/images/ui/user-button.png',
                      height: 50,
                    ),
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
                      game.router.pushRoute(Route(() => MapLevelSelection()),
                          replace: true);
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
            return LevelSelectionUI(game: game);
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

  Future<void> _loadUserData(BuildContext context) async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      String uid = currentUser.uid;
      QuerySnapshot querySnapshot = await firestore
          .collection('Users')
          .where('uid', isEqualTo: uid)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        _data = querySnapshot.docs.first.data() as Map<String, dynamic>;
        print(_data);
        if (context.mounted) {
          Provider.of<UserProfile>(context, listen: false).setData(_data);
        }
      } else {
        //Write and store defaults
        firestore
            .collection('Users')
            .doc(uid)
            .set(UserProfile.getuserInstance(uid, currentUser.email!));
        querySnapshot = await firestore
            .collection('Users')
            .where('uid', isEqualTo: uid)
            .get();
        _data = querySnapshot.docs.first.data() as Map<String, dynamic>;
        print(_data);
        if (context.mounted) {
          Provider.of<UserProfile>(context, listen: false).setData(_data);
        }
      }
    }
  }
}
