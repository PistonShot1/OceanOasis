import 'dart:async';
import 'dart:io';
import 'dart:math' hide Rectangle;
import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/experimental.dart';
import 'package:flame/flame.dart';
import 'package:flame/palette.dart';
import 'package:flame/particles.dart';
import 'package:flame/text.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:flutter/services.dart';
import 'package:oceanoasis/components/events/bubbles.dart';
import 'package:oceanoasis/components/events/circularMaskComponent.dart';
import 'package:oceanoasis/components/events/glacierformation.dart';
import 'package:oceanoasis/components/events/longswordfish.dart';
import 'package:oceanoasis/components/events/tideEvent.dart';
import 'package:oceanoasis/components/players/joystickplayer.dart';
import 'package:oceanoasis/components/players/playerbreathingbar.dart';
import 'package:oceanoasis/components/players/playerhealth.dart';
import 'package:oceanoasis/property/levelProperty.dart';
import 'package:oceanoasis/tools/toolbox.dart';
import 'package:oceanoasis/routes/gameplay.dart';
import 'package:oceanoasis/property/defaultgameProperty.dart';
import 'package:oceanoasis/routes/gameOver.dart';
import 'package:oceanoasis/wasteComponents/waste.dart';

class PacificOceanUnderwater extends Component
    with HasGameReference<MyGame>, HasCollisionDetection {
  static const id = 'PacificOceanUnderwater';
  late final TiledComponent tiledMap;
  late final World underwaterWorld;
  CameraComponent cameraComponent = CameraComponent();
  late final ItemToolBox uiComponent;
  late final Map<String, double> spawnArea;
  final int levelNumber;
  bool startSpawn = false;
  int wasteList = 0;

  late JoystickPlayer player;
  int playeritems;

  //tide event variables
  Map<int, String> tideDirection = {0: 'Left', 1: 'Right', 2: 'Up', 3: 'Down'};
  Random random = Random();
  int eventNum = 0; //corresponds to tideDirection
  bool tideEvent = false; //Variable for event initialization
  bool eventTidemovePlayer = true;

  //underwater breathing event
  Vector2 landwaterlevel = Vector2.zero();
  bool breathingEvent = false; //Variable for event initialization
  bool breathingEffect = true;
  bool playerisDrowning = false;

  // ice event
  bool iceEvent = false;

  //Player breathing bar
  PlayerBreathingBar breathingBar = PlayerBreathingBar(
      breathingSeconds: 10); //default , will be initialized again later

  String gameState = 'Loading';

  PacificOceanUnderwater(
      {required this.levelNumber, required this.playeritems});
  @override
  Future<void> onLoad() async {
    // TODO: implement onLoad
    game.camera.stop();
    game.resumeEngine();
    game.currentLevel = levelNumber;

    game.overlays.remove('ToFacility');
    game.overlays.add('WasteScores');

    underwaterWorld = World();
    tiledMap =
        await TiledComponent.load('pacific-ocean-final.tmx', Vector2.all(16));
    await underwaterWorld.add(tiledMap);

    cameraSettings();

    await add(underwaterWorld);

    return super.onLoad();
  }

  @override
  void onMount() {
    // TODO: implement onMount
    if (gameState.compareTo('Loading') == 0) {
      startGame();
      game.playerData.resetScore();
    }

    super.onMount();
  }

  @override
  void update(double dt) {
    // TODO: implement update

    if (gameState.compareTo('Start') == 0) {
      //Spawn the waste
      wasteSpawn();

      //check for gameOver
      gameOver();

      if (tideEvent) {
        // highTideEvent(5);
        // eventNum = random.nextInt(2);
        tideEvent = false;
        const eventDuration = 10;
        int interval = eventDuration + 5 + random.nextInt(10); //(5 is for gap)

        final event = TideEvent(
            tideEvent: tideEvent,
            duration: eventDuration,
            worldSize: tiledMap.size,
            player: player,
            tiledMap: tiledMap);
        underwaterWorld.add(event);

        Future.delayed(Duration(seconds: interval), () {
          tideEvent = true;
        });
      }
      //---Event----
      //Breathing
      if (breathingEvent) {
        breathingEventEffect();
        switchPlayerAnimation();
      }
    }
    super.update(dt);
  }

  void startGame() async {
    final regular = TextPaint(
      style: TextStyle(
          fontSize: 48.0,
          color: BasicPalette.white.color,
          fontFamily: 'Retro Gaming'),
    );
    TextComponent numberText = TextComponent(text: '3', textRenderer: regular);
    for (int i = 3; i >= 1; i--) {
      await Future.delayed(const Duration(seconds: 1), () async {
        await underwaterWorld.add(numberText
          ..text = '$i'
          ..position = Vector2(1920 / 2, 1080 / 2));
      });
    }
    await Future.delayed(const Duration(seconds: 1), () {
      numberText.removeFromParent();
      gameState = 'Start';
    });

    loadPlayerJoystick();
    initPlayerBoundary();
    loadToolbar(playeritems);
    initspawnWaste();
    initChallenges();

    //Events
    //Tide

    //Ice layer formation
    if (iceEvent) {
      iceformationEvent();
    }

    if (breathingEvent) {
      initBreathingArea();
    }

    spawnBubbles();
    spawnEnemies(LevelProperty.levelProperty[levelNumber]['swordFishInterval']);
  }

  //check pacific.dart for camera movement
  void cameraSettings() {
    game.camera = CameraComponent.withFixedResolution(
        world: underwaterWorld, width: 1920, height: 1184);
    game.camera.viewport.anchor = Anchor.center;
    game.camera.viewfinder.zoom = 1;
    game.camera.moveBy(Vector2(1920 * 0.5, 1184 * 0.5));

    // game.add(CameraComponent.withFixedResolution(
    //     width: 200, height: 300, world: underwaterWorld));

    if (Platform.isAndroid || Platform.isIOS) {
      game.camera.viewport.add(game.joystick);
    }
    
    // final circularViewport = CircularViewport(500);
    // game.camera.viewport = circularViewport;
    // game.camera.viewport.add(CircularMaskComponent(radius: 100));
  }

  void loadPlayerJoystick() {
    final spawnPoint = tiledMap.tileMap.getLayer<ObjectGroup>("Player Spawn");
    player = JoystickPlayer(
        joystick: game.joystick,
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
    player.setPosition =
        Vector2(spawnPoint!.objects.first.x, spawnPoint.objects.first.y);
    player.setSpeed = 500;
    underwaterWorld.add(player);

    game.camera.viewport.add(player.playerHealth);

    breathingBar =
        PlayerBreathingBar(breathingSeconds: player.breathingSeconds);
    underwaterWorld.add(breathingBar..position = Vector2(0, 50));

    // player.debugMode = true;

    (Platform.isAndroid || Platform.isIOS)
        ? game.camera.viewport.add(game.joystick)
        : '';
  }

  void initPlayerBoundary() {
    final movementLayer =
        tiledMap.tileMap.getLayer<ObjectGroup>('Movement Layer');
    final objects = movementLayer!.objects;
    for (TiledObject object in objects) {
      player.setMovementBoundary(
          maxX: object.x + object.width,
          minX: object.x,
          maxY: object.y + object.height,
          minY: object.y);
    }
    print('Player boundary ${player.movementBoundary}');
  }

  void loadToolbar(int itemNum) async {
    if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      for (int i = 0; i < itemNum; i++) {
        final toolbox = ItemToolBox(() {},
            position: Vector2(
                tiledMap.size.x / 2 - 100 + 32 * 3 * i, tiledMap.size.y * 0.9),
            iconItem: ToolSlashProperty.toolIcon[i]['icontool']!,
            item: ToolSlashProperty.toolIcon[i]['tool'],
            keybind: _mapKeyBind(i),
            detectTap: true,
            player: player)
          ..scale = Vector2.all(3);
        await game.camera.viewport.add(toolbox);

        // 16*2(the size of the tile image)* 3 (the set scale) * i (y positioning)
      }
    } else {
      for (int i = 0; i < itemNum; i++) {
        final toolbox = ItemToolBox(() {},
            position: Vector2(
                tiledMap.size.x / 2 - 100 + 32 * 3 * i, tiledMap.size.y * 0.9),
            iconItem: ToolSlashProperty.toolIcon[i]['icontool']!,
            item: ToolSlashProperty.toolIcon[i]['tool'],
            detectTap: true,
            player: player)
          ..scale = Vector2.all(3);
        await game.camera.viewport.add(toolbox);

        // 16*2(the size of the tile image)* 3 (the set scale) * i (y positioning)
      }
    }
  }

  LogicalKeyboardKey? _mapKeyBind(int i) {
    switch (i) {
      case 0:
        return LogicalKeyboardKey.digit1;
      case 1:
        return LogicalKeyboardKey.digit2;
      case 2:
        return LogicalKeyboardKey.digit3;
      default:
        return null;
    }
  }

  //Initialize challenges
  void initChallenges() {
    tideEvent = LevelProperty.levelProperty[levelNumber]['tideEvent'];
    breathingEvent = LevelProperty.levelProperty[levelNumber]['breathingEvent'];
    iceEvent = LevelProperty.levelProperty[levelNumber]['iceEvent'];
  }

  //##SPAWN OF WASTE##
  void _initSpawnArea(double minX, double minY, double maxX, double maxY) {
    spawnArea = {'minX': minX, 'minY': minY, 'maxX': maxX, 'maxY': maxY};
  }

  void initspawnWaste() {
    final spawnPoints = tiledMap.tileMap.getLayer<ObjectGroup>('Spawn Layer');
    final objects = spawnPoints!.objects;
    for (TiledObject object in objects) {
      _initSpawnArea(object.x, object.y, object.x + object.width,
          object.y + object.height);
    }

    startSpawn = true;
  }

  void wasteSpawn() {
    final List<WasteType> listOfWastes =
        LevelProperty.levelProperty[levelNumber]['listOfWastes'];
    Random random = Random();
    if (startSpawn &&
        wasteList < LevelProperty.levelProperty[levelNumber]['maxSpawn']) {
      //it will end at -1
      startSpawn = false;
      ;
      Waste wasteProperty =
          WasteProperty(type: listOfWastes[random.nextInt(listOfWastes.length)])
              .mapWasteComponent;

      Waste oceanWaste = Waste.clone(wasteProperty, null)
        ..size = Vector2(128, 128)
        ..paint.filterQuality = FilterQuality.none
        ..position = spawnLogic();

      Future.delayed(const Duration(seconds: 3), () async {
        if (gameState.compareTo('Start') == 0) {
          await underwaterWorld.add(oceanWaste);
          startSpawn = true;
          wasteList++;
        }
      });
    }
  }

  Vector2 spawnLogic() {
    Random random = Random();
    double x = spawnArea['minX']! +
        random.nextInt(
            spawnArea['maxX']!.round() - spawnArea['minX']!.round() + 1);
    double y = spawnArea['minY']! +
        random.nextInt(
            spawnArea['maxY']!.round() - spawnArea['minY']!.round() + 1);
    return Vector2(x, y);
  }

  // ## BREATHING EVENT ##
  void initBreathingArea() {
    final landwaterMark =
        tiledMap.tileMap.getLayer<ObjectGroup>('Breathing Layer');
    final objects = landwaterMark!.objects;

    for (TiledObject object in objects) {
      landwaterlevel = Vector2(object.x, object.y);
      print('Landwater level : $landwaterlevel');
    }
  }

  void breathingEventEffect() {
    //axis is flipped for anchor.center of camera
    if (player.position.y > landwaterlevel.y &&
        breathingEffect &&
        player.breathingSeconds > 0 &&
        player.position.y > landwaterlevel.y) {
      breathingEffect = false;
      Future.delayed(const Duration(seconds: 2), () {
        player.breathingSeconds -= 1;
        _updateBreathingBar();
        breathingEffect = true;
      });
    } else if (player.position.y <= landwaterlevel.y &&
        breathingEffect &&
        player.breathingSeconds < player.maxbreathingDuration) {
      breathingEffect = false;
      Future.delayed(const Duration(milliseconds: 200), () {
        player.breathingSeconds += 1;
        _updateBreathingBar();
        breathingEffect = true;
      });
    } else if (player.breathingSeconds == 0 &&
        player.position.y >= landwaterlevel.y) {
      if (!playerisDrowning) {
        playerisDrowning = true;
        damageOnPlayer(1);
        Future.delayed(const Duration(seconds: 3), () {
          playerisDrowning = false;
        });
      }
    }
  }

  void _updateBreathingBar() {
    breathingBar.removeFromParent();
    breathingBar =
        PlayerBreathingBar(breathingSeconds: player.breathingSeconds);
    underwaterWorld.add(breathingBar..position = Vector2(0, 50));
  }

  void iceformationEvent() {
    final glacierLevel =
        tiledMap.tileMap.getLayer<ObjectGroup>('Glacier Layer');
    final objects = glacierLevel!.objects;
    underwaterWorld.add(GlacierFormation()
      ..position = Vector2(objects.first.x, objects.first.y));
  }

  void switchPlayerAnimation() {
    if (player.position.y <= landwaterlevel.y &&
        player.animation != player.breathingAnimation) {
      player.animation = player.breathingAnimation;
    } else if (player.position.y > landwaterlevel.y &&
        player.animation == player.breathingAnimation) {
      player.animation = SpriteAnimation.fromFrameData(
          player.swimimage, player.swimanimationData);
    }
  }

  void damageOnPlayer(double value) {
    //Condition to check game over and avoid null error
    if (player.playerHealth.health > 0) {
      game.camera.viewport.remove(player.playerHealth);
      player.hit(1);
      print('Player health: ${player.playerHealth}');
    }
  }

  void gameOver() {
    if ((wasteList >= LevelProperty.levelProperty[levelNumber]['maxSpawn'] &&
            underwaterWorld.children.query<Waste>().isEmpty) ||
        player.playerHealth.health == 0) {
      gameState = 'Game Over';
      game.pauseEngine();
      game.router.pushNamed(GameOver.id);
    }
  }

  void spawnBubbles() {
    underwaterWorld.add(SpawnComponent(
        factory: (i) => Bubbles(),
        period: 0.1,
        area: Rectangle.fromCenter(
            center: Vector2(tiledMap.size.x * 0.5, tiledMap.size.y),
            size: Vector2(tiledMap.size.x * 0.8, 200))));
  }

  void spawnEnemies(double interval) {
    underwaterWorld.add(SpawnComponent(
        factory: (i) => LongSwordFishEnemy(player: player)
          ..position = Vector2(0, player.position.y),
        period: 2,
        selfPositioning: true));
  }

  @override
  void onRemove() {
    // TODO: implement onRemove
    game.overlays.remove('WasteScores');
    game.currentLevel = null;
    print('exited');
    super.onRemove();
  }
}
