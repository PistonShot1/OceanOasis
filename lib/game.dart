// import 'dart:async';

// import 'package:flame/events.dart';
// import 'package:flame/flame.dart';
// import 'package:flame/game.dart';
// import 'package:flutter/foundation.dart';
// import 'package:oceanoasis/routes/achievementdashboard.dart';
// import 'package:oceanoasis/routes/mainmenu.dart';
// import 'package:oceanoasis/routes/maplevelselection.dart';
// import 'package:oceanoasis/routes/settings.dart';
// import 'package:oceanoasis/routes/userprofile.dart';

// class OceanOasisGame extends FlameGame with HasKeyboardHandlerComponents {
//   final musicValueNotifier = ValueNotifier(true);
//   final sfxValueNotifier = ValueNotifier(true);

//   late final _routes = <String, Route>{
//     MainMenu.id: OverlayRoute((context, game) => MainMenu(
//           onPlayPressed: () => _startMapSelection,
//         )),
//     MapLevelSelection.id: Route(() => MapLevelSelection(
//           onExitPressed: _exitToMainMenu,
//         )),
//     Settings.id: OverlayRoute(
//       (context, game) => Settings(
//         musicValueListenable: musicValueNotifier,
//         sfxValueListenable: sfxValueNotifier,
//         onBackPressed: _popRoute,
//       ),
//     )
//   };
//   late final RouterComponent _router =
//       RouterComponent(initialRoute: 'MainMenu', routes: _routes);

//   @override
//   Future<void> onLoad() async {
//     // TODO: implement onLoad
//     await Flame.images.load('temp1-player.jpeg');
//     await Flame.images.load('bird-flying-2.png');
//     await Flame.images.load('newspaper.png');
//     await Flame.images.load('earth-map-final.jpeg');
//     await Flame.images.load('character2-swim1.png');
//     await Flame.images.load('map-location-icon.png');
//     await add(_router);
//     return super.onLoad();
//   }

//   void _routeById(String id) {
//     _router.pushNamed(id);
//   }

//   void _popRoute() {
//     _router.pop();
//   }

//   void _resumeGame() {
//     _router.pop();
//     resumeEngine();
//   }

//   void _exitToMainMenu() {
//     _resumeGame();
//     _router.pushReplacementNamed(MainMenu.id);
//   }

//   void _startMapSelection() {
//     print('Hello');
//     _router.pop();
//     _router.pushReplacement(Route(() => MapLevelSelection()), name: MapLevelSelection.id);
//   }
// }
