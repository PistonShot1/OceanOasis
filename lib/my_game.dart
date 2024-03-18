import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart' hide Route, OverlayRoute;
import 'package:oceanoasis/components/maps/underwater/joystickplayer.dart';
import 'package:oceanoasis/property/game_properties.dart';
import 'package:oceanoasis/property/player_inventory_bloc/player_inventory_bloc.dart';
import 'package:oceanoasis/property/player_property.dart';
import 'package:oceanoasis/widgets/shop.dart';
import 'package:oceanoasis/components/shoptools/toolbox.dart';
import 'package:oceanoasis/components/maps/overworld/pacific.dart';
import 'package:oceanoasis/components/maps/underwater/underwater_scene.dart';
import 'package:oceanoasis/widgets/game_over.dart';
import 'package:oceanoasis/components/maps/levelSelection/maplevelselection.dart';
import 'package:audioplayers/audioplayers.dart';
import 'components/maps/BossFight/bossfight.dart';

/// MyGame is an instance of the [FlameGame] that will be used for routing purposes
/// and mainly to initialize the game component tree.

class MyGame extends FlameGame
    with
        HasCollisionDetection,
        HasKeyboardHandlerComponents,
        LongPressDetector {
  late SpriteComponent backgroundImage;
  List<Component> mainComponents = [];
  List<Component> gameComponents = [];
  final MediaQueryData screeninfo;

  late final RouterComponent router;
  late final Map<String, Route> routes;

  PlayerProperty playerData;
  late JoystickComponent joystick;

  List<ItemToolBox>? toolboxItems;

  JoystickPlayer? playerRef;

  int? currentLevel;

  WasteType? currentMachine;

  AudioPlayer? mainBgm;

  PlayerInventoryBloc inventoryblocprovider;

  MyGame(this.screeninfo,
      {required this.playerData, required this.inventoryblocprovider});
  @override
  Future<void> onLoad() async {
    Flame.device.fullScreen();
    await loadAssets();
    //SET camera bound
    // await loadAudio();
    await add(FlameMultiBlocProvider(providers: [
      FlameBlocProvider<PlayerInventoryBloc, PlayerInventoryState>.value(
          value: inventoryblocprovider)
    ]));
    routes = {
      MapLevelSelection.id: Route(
        () => MapLevelSelection(key: ComponentKey.named('MapLevelSelection')),
      ),
      PacificOceanBossFight.id: Route(() => PacificOceanBossFight()),
      GameOver.id: OverlayRoute(
        (context, game) => GameOver(
          nextLevel: (level) {
            startLevel(level);
          },
          back: () {},
          game: game as MyGame,
        ),
      ),
      ShopUI.id: OverlayRoute(
        (context, game) => ShopUI(game: game as MyGame),
      )
    };
    router =
        RouterComponent(initialRoute: MapLevelSelection.id, routes: routes);
    Color greyColor =
        Colors.grey.withOpacity(0.5); // Grey color with transparency
    Color transparentColor = Colors.transparent;
    Paint knobPaint = Paint()
      ..color = transparentColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10; // Thickness of the border

    Paint backgroundPaint = Paint()
      ..color = greyColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;

    joystick = JoystickComponent(
        key: ComponentKey.named('JoystickHUD'),
        knob: CircleComponent(radius: 50, paint: backgroundPaint),
        background: CircleComponent(radius: 150, paint: backgroundPaint),
        margin: const EdgeInsets.only(left: 40, bottom: 40),
        size: 50);

    //GLOBAL Component

    // List<SpriteAnimationFrame> frames = [];
    // player.animation = SpriteAnimation(frames);

    add(router);

    //DEBUG
    // debugMode = true;
    // add(FpsTextComponent());

    // world.addAll(mainComponents);
  }

  Future<void> loadAssets() async {
    await Flame.images.loadAllImages();
  }

  void startLevel(int levelIndex) {
    //TODO : pass user data
    router.pushReplacement(
        Route(() => UnderwaterScene(levelNumber: levelIndex, playeritems: 3)));
  }

  void toFacility() {
    router.pushReplacement(Route(() => PacificOcean()));
  }

  void toBossWorldSelection() {
    router.pushReplacement(Route(() => PacificOceanBossFight()));
  }

  void toMapSelection() {
    router.pushReplacement(Route(() => MapLevelSelection()));
  }

  Future<void> loadAudio() async {
    await FlameAudio.audioCache.load('underwater/forestwalk-bgm.mp3');
    FlameAudio.bgm.play('underwater/forestwalk-bgm.mp3');
  }
}
