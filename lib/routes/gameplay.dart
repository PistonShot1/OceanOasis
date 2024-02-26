import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/debug.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart' hide Route, OverlayRoute;
import 'package:oceanoasis/components/players/joystickplayer.dart';
import 'package:oceanoasis/routes/challengeBossSelection.dart';
import 'package:oceanoasis/tools/toolbox.dart';
import 'package:oceanoasis/components/Boss/bossfight.dart';
import 'package:oceanoasis/maps/pacific.dart';
import 'package:oceanoasis/maps/pacificunderwater.dart';
import 'package:oceanoasis/routes/gameOver.dart';
import 'package:oceanoasis/routes/levelselection.dart';
import 'package:oceanoasis/routes/maplevelselection.dart';
import 'package:audioplayers/audioplayers.dart';

class MyGame extends FlameGame
    with HasCollisionDetection, HasKeyboardHandlerComponents {
  late SpriteComponent backgroundImage;
  List<Component> mainComponents = [];
  List<Component> gameComponents = [];
  final MediaQueryData screeninfo;

  late final RouterComponent router;
  late final Map<String, Route> routes;

  late JoystickPlayer player;
  late JoystickComponent joystick;

  List<ItemToolBox>? toolboxItems;

  AudioPlayer? mainBgm;
  MyGame(this.screeninfo);
  @override
  Future<void> onLoad() async {
    await loadAssets();
    //SET camera bound
    // await loadAudio();
    routes = {
      MapLevelSelection.id: Route(
        () => MapLevelSelection(key: ComponentKey.named('MapLevelSelection')),
      ),
      LevelSelection.id: OverlayRoute((context, game) {
        return LevelSelection(
          onLevelSelected: (value) {
            startLevel(value);
          },
          toFacility: () {
            toFacility();
          },
          toBossWorldSelection: () {
            toBossWorldSelection();
          },
        );
      }, transparent: false),
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
    };
    router = RouterComponent(initialRoute: LevelSelection.id, routes: routes);

    final knobPaint = BasicPalette.blue.withAlpha(200).paint();
    final backgroundPaint = BasicPalette.blue.withAlpha(100).paint();

    joystick = JoystickComponent(
      key: ComponentKey.named('JoystickHUD'),
      knob: CircleComponent(radius: 30, paint: knobPaint),
      background: CircleComponent(radius: 100, paint: backgroundPaint),
      margin: const EdgeInsets.only(left: 40, bottom: 40),
    );

    //GLOBAL Component
    player = JoystickPlayer(
        joystick: joystick,
        position: Vector2(0, 0),
        playerScene: 0,
        swimimage: Flame.images.fromCache('main-character-1/Swim.png'),
        swimanimationData: SpriteAnimationData.sequenced(
            amount: 6, // Number of frames in your animation
            stepTime: 0.15, // Duration of each frame
            textureSize: Vector2(48, 48)),
        hitAnimation: SpriteAnimation.fromFrameData(
          Flame.images.fromCache('main-character-1/Attack.png'),
          SpriteAnimationData.sequenced(
              amount: 6, // Number of frames in your animation
              stepTime: 0.15, // Duration of each frame
              textureSize: Vector2(48, 48)),
        ),
        breathingAnimation: SpriteAnimation.fromFrameData(
            Flame.images.fromCache('main-character-1/Idle.png'),
            SpriteAnimationData.sequenced(
                amount: 6, // Number of frames in your animation
                stepTime: 0.15, // Duration of each frame
                textureSize: Vector2(35, 39))));
    player.size = Vector2.all(64);
    player.scale = Vector2.all(2.5);
    // List<SpriteAnimationFrame> frames = [];
    // player.animation = SpriteAnimation(frames);

    world.add(router);

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
    router.pushReplacement(Route(
        () => PacificOceanUnderwater(levelNumber: levelIndex, playeritems: 3)));
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

  // Future<void> loadAudio() async {
  //   await FlameAudio.audioCache.load('underwater/forestwalk-bgm.mp3');
  //   mainBgm = await FlameAudio.loop('underwater/forestwalk-bgm.mp3');
  // }
}
