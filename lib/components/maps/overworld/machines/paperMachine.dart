import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:oceanoasis/components/maps/overworld/machines/despositComponent.dart';
import 'package:oceanoasis/components/maps/overworld/machines/machines.dart';
import 'package:oceanoasis/components/maps/overworld/overworldplayer.dart';
import 'package:oceanoasis/property/defaultgameProperty.dart';
import 'package:oceanoasis/my_game.dart';

class PaperMachine extends Machines
    with HasGameReference<MyGame>, CollisionCallbacks {
  PaperMachine(Vector2 position) : super(position: position);

  final WasteType machineType = WasteType.paper;
  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runAnimation;
  final animationStepTime = 0.15;
  late final DepositComponent depositComponent;
  @override
  FutureOr<void> onLoad() {
    // TODO: implement onLoad
    _loadAllAnimations();
    add(RectangleHitbox());
    depositComponent =
        DepositComponent(machine: this, machineType: machineType);
    return super.onLoad();
  }

  void _loadAllAnimations() {
    idleAnimation = SpriteAnimation.fromFrameData(
        game.images.fromCache('machines/paper-machine-320x87.png'),
        SpriteAnimationData.sequenced(
            amount: 1, stepTime: 0.5, textureSize: Vector2(320, 87)));
    runAnimation = SpriteAnimation.fromFrameData(
        game.images.fromCache('machines/paper-machine-320x87-38.png'),
        SpriteAnimationData.sequenced(
            amount: 38,
            stepTime: animationStepTime,
            textureSize: Vector2(320, 87)));
    animations = {
      MachineState.idle: idleAnimation,
      MachineState.run: runAnimation
    };
    current = MachineState.idle;
  }

  @override
  void playAnimation() {
    // TODO: implement playAnimation
    current = MachineState.run;
    Future.delayed(
        Duration(
            milliseconds:
                (runAnimation.frames.length * animationStepTime * 1000)
                    .toInt()), () {
      current = MachineState.idle;
    });
    super.playAnimation();
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    // TODO: implement onCollisionStart
    if (other is OverworldPlayer) {
      // game.overlays.add('DepositButton');
      game.camera.viewport.add(depositComponent
        ..position = game.camera.viewport.size - Vector2.all(150));
      game.currentMachine = WasteType.paper;
    }

    super.onCollisionStart(intersectionPoints, other);
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    // TODO: implement onCollisionEnd
    if (other is OverworldPlayer) {
      // game.overlays.remove('DepositButton');
      game.camera.viewport.remove(depositComponent);
      game.currentMachine = null;
    }
    super.onCollisionEnd(other);
  }

  @override
  void onRemove() {
    // TODO: implement onRemove
    if (depositComponent.isMounted) {
      game.camera.viewport.remove(depositComponent);
    }
    super.onRemove();
  }
}
