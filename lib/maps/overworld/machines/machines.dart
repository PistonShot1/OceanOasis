import 'package:flame/components.dart';

enum MachineState { idle, run }

class Machines extends SpriteAnimationGroupComponent {
  Machines({required Vector2 position}) : super(position: position);

  void playAnimation(){}
}
