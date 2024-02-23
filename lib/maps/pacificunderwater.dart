import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/palette.dart';
import 'package:flame/text.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:oceanoasis/components/events/glacierformation.dart';
import 'package:oceanoasis/components/playerbreathingbar.dart';
import 'package:oceanoasis/components/playerhealth.dart';
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
  int playeritems;
  String gameState = 'Loading';

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
  bool iceEvent = true;
  //Player health
  PlayerHealth playerHealth =
      PlayerHealth(health: 3); //default, will be initialized again later
  //Player breathing bar
  PlayerBreathingBar breathingBar = PlayerBreathingBar(
      breathingSeconds: 10); //default , will be initialized again later

  PacificOceanUnderwater(
      {required this.levelNumber, required this.playeritems});
  @override
  Future<void> onLoad() async {
    // TODO: implement onLoad
    game.camera.stop();
    game.resumeEngine();
    game.overlays.remove('ToFacility');
    
    underwaterWorld = World();
    tiledMap =
        await TiledComponent.load('pacific-ocean-final.tmx', Vector2.all(16));
    await underwaterWorld.add(tiledMap);

    //JoyStick addition and player for mobile

    cameraSettings();
    loadToolbar(playeritems);

    await add(underwaterWorld);

    //Initialization of variables for event (these are dependent on the level value that was passed when this component was added to the game)
    if (tideEvent) {
      eventNum = random.nextInt(2);
    }

    if (breathingEvent) {
      initBreathingArea();
    }

    return super.onLoad();
  }

  @override
  void onMount() {
    // TODO: implement onMount
    if (gameState.compareTo('Loading') == 0) {
      startGame();
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
      //---Event----
      //Tide
      if (isMounted && tideEvent && eventTidemovePlayer) {
        highTideEventMovePlayer(eventNum);
      }
      //Breathing
      if (breathingEvent) {
        breathingEventEffect();
      }
    }
    super.update(dt);
  }

  void wasteSpawn() {
    if (startSpawn &&
        wasteList < LevelProperty.levelProperty['$levelNumber']['maxSpawn']) {
      //it will end at -1
      startSpawn = false;
      Random random = Random();
      Waste wasteProperty = WasteProperty.wasteProperty[random.nextInt(3)];
      Waste oceanWaste = Waste.clone(wasteProperty, null)
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

  //check pacific.dart for camera movement
  void cameraSettings() {
    game.camera = CameraComponent.withFixedResolution(
        world: underwaterWorld, width: 1920, height: 1184);
    game.camera.viewport.anchor = Anchor.center;
    game.camera.viewfinder.zoom = 1;
    game.camera.moveBy(Vector2(1920 * 0.5, 1184 * 0.5));

    if (Platform.isAndroid || Platform.isIOS) {
      game.camera.viewport.add(game.joystick);
    }
  }

  void loadPlayerJoystick() {
    final spawnPoint = tiledMap.tileMap.getLayer<ObjectGroup>("Player Spawn");
    game.player.setPosition =
        Vector2(spawnPoint!.objects.first.x, spawnPoint.objects.first.y);
    game.player.setSpeed = 500;

    underwaterWorld.add(game.player);

    playerHealth = PlayerHealth(health: game.player.playerHealth);
    underwaterWorld.add(playerHealth);

    breathingBar =
        PlayerBreathingBar(breathingSeconds: game.player.breathingSeconds);
    underwaterWorld.add(breathingBar..position = Vector2(0, 50));

    (Platform.isAndroid || Platform.isIOS)
        ? game.camera.viewport.add(game.joystick)
        : '';
  }

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

  void initPlayerBoundary() {
    final movementLayer =
        tiledMap.tileMap.getLayer<ObjectGroup>('Movement Layer');
    final objects = movementLayer!.objects;
    for (TiledObject object in objects) {
      game.player.setMovementBoundary(
          maxX: object.x + object.width,
          minX: object.x,
          maxY: object.y + object.height,
          minY: object.y);
    }
    print('Player boundary ${game.player.movementBoundary}');
  }

  void loadToolbar(int itemNum) async {
    final toolbarPoint = tiledMap.tileMap.getLayer<ObjectGroup>('UI layer');
    final objects = toolbarPoint!.objects;

    // toolbox
    for (TiledObject object in objects) {
      for (int i = 0; i < itemNum; i++) {
        final toolbox = ItemToolBox(() {},
            position: Vector2(object.x - 16 * 3, object.y + 16 * 2 * 3 * i),
            iconItem: ToolSlashProperty.toolIcon[i]['icontool']!,
            item: ToolSlashProperty.toolIcon[i]['tool'],
            detectTap: true,
            player: game.player)
          ..scale = Vector2.all(3);
        await underwaterWorld.add(toolbox);

        // 16*2(the size of the tile image)* 3 (the set scale) * i (y positioning)
      }
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

  void initChallenges() {
    tideEvent = LevelProperty.levelProperty['$levelNumber']['tideEvent'];
    breathingEvent =
        LevelProperty.levelProperty['$levelNumber']['breathingEvent'];
  }

  void loadPuzzle() {}

  void spawnEvent(bool spawnEvent) {}

  void gameOver() {
    if ((wasteList >= LevelProperty.levelProperty['$levelNumber']['maxSpawn'] &&
            underwaterWorld.children.query<Waste>().isEmpty) ||
        game.player.playerHealth == 0) {
      gameState = 'Game Over';
      game.pauseEngine();
      game.router.pushNamed(GameOver.id);
    }
  }

// ### TIDE EVENT ###
  void highTideEvent(double duration) {
    print('Current tide is from : ${tideDirection[eventNum]}');

    switch (eventNum) {
      case 0:
        game.player.highTideSlower[0] = 0.5;
      case 1:
        game.player.highTideSlower[1] = 0.5;
    }
  }

  //Moves the player continuously when tide is on
  void highTideEventMovePlayer(int eventNum) {
    if (eventTidemovePlayer) {
      switch (eventNum) {
        case 0:
          eventTidemovePlayer = false;
          game.player.add(
              MoveEffect.by(Vector2(300 * 1, 0), EffectController(duration: 5))
                ..onComplete = () {
                  eventTidemovePlayer = true;
                });
        case 1:
          eventTidemovePlayer = false;
          game.player.add(
              MoveEffect.by(Vector2(300 * -1, 0), EffectController(duration: 5))
                ..onComplete = () {
                  eventTidemovePlayer = true;
                });
      }
    }
  }

  // ## BREATHING EVENT ##
  void initBreathingArea() {
    final landwaterMark =
        tiledMap.tileMap.getLayer<ObjectGroup>('Breathing Layer');
    final objects = landwaterMark!.objects;

    for (TiledObject object in objects) {
      landwaterlevel = Vector2(object.x, object.y);
    }
  }

  void breathingEventEffect() {
    //axis is flipped for anchor.center of camera
    if (game.player.position.y > landwaterlevel.y &&
        breathingEffect &&
        game.player.breathingSeconds > 0) {
      breathingEffect = false;
      Future.delayed(const Duration(seconds: 2), () {
        game.player.breathingSeconds -= 1;
        print(
            'Player have ${game.player.breathingSeconds} breathing seconds left');
        breathingEffect = true;
      });
    } else if (game.player.position.y <= landwaterlevel.y &&
        breathingEffect &&
        game.player.breathingSeconds < game.player.maxbreathingDuration) {
      breathingEffect = false;
      Future.delayed(const Duration(seconds: 2), () {
        game.player.breathingSeconds += 1;
        breathingEffect = true;
      });
    } else if (game.player.breathingSeconds == 0) {
      if (!playerisDrowning) {
        playerisDrowning = true;
        damageOnPlayer(1);
        Future.delayed(const Duration(seconds: 2), () {
          playerisDrowning = false;
        });
      }
    }
  }

  void iceformationEvent() {
    final glacierLevel =
        tiledMap.tileMap.getLayer<ObjectGroup>('Glacier Layer');
    final objects = glacierLevel!.objects;
    underwaterWorld.add(GlacierFormation()
      ..position = Vector2(objects.first.x, objects.first.y));
  }

  @override
  void onRemove() {
    // TODO: implement onRemove

    game.player.playerHealth = 3;
    game.player.breathingSeconds = 10;
    game.player.currentTool.removeFromParent();
    game.player.highTideSlower[0] = 1;
    game.player.highTideSlower[1] = 1;
    game.player.movementBoundary = List.empty();
    print('exited');
    super.onRemove();
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

    initPlayerBoundary();
    loadPlayerJoystick();

    initspawnWaste();
    initChallenges();
    //Events
    //Tide
    if (tideEvent) {
      highTideEvent(5);
    }
    //Ice layer formation
    if (iceEvent) {
      iceformationEvent();
    }
  }

  void damageOnPlayer(double value) {
    //Condition to check game over and avoid null error
    if (game.player.playerHealth > 0) {
      underwaterWorld.remove(playerHealth);
      game.player.setPlayerHealth = game.player.playerHealth - value;
      playerHealth = PlayerHealth(health: game.player.playerHealth);
      final effect = ColorEffect(
        Colors.red,
        EffectController(duration: 0.1, alternate: true, repeatCount: 1),
      );
      game.player.idle!.add(effect);
      underwaterWorld.add(playerHealth);
      print('Player health: ${game.player.playerHealth}');
    }
  }
}
