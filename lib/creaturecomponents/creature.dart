import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/flame.dart';

class Creature extends Component {
  final SpriteAnimationComponent animationComponent;
  double? health;
  double? damage;
  double speed = 0;

  Creature(this.animationComponent) {
    add(animationComponent);
    move();
  }

  set setHealth(double value) {
    health = value;
  }

  set setDamage(double value) {
    damage = value;
  }

  set setSpeed(double value) {
    speed = value;
  }

  void move() {
    add(MoveByEffect(
      Vector2(0, -10),
      EffectController(duration: 0.5, alternate: true, infinite: true),
    ));
  }
}
