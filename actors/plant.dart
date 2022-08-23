import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';

import './player.dart';
import '../my_world.dart';

class PlantComponent extends SpriteAnimationComponent
    with CollisionCallbacks, HasGameRef<MyWorld> {
  PlantComponent() {
    debugMode = true;
    datePlanted = DateTime.now();
  }
  //variables
  late DateTime datePlanted;
  @override
  void onMount() {
    super.onMount();
    add(RectangleHitbox());
  }

  @override
  Future<void>? onLoad() async {
    super.onLoad();
    // sprite = await Sprite.load("plant/pumpkin_4.png");
    final spriteSheet = SpriteSheet(
        image: await gameRef.images.load("plants.png"),
        srcSize: Vector2.all(32));

    animation =
        spriteSheet.createAnimation(row: 0, stepTime: 1, to: 19, loop: false);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is PlayerComponent) {
      if (datePlanted.millisecondsSinceEpoch -
              DateTime.now().millisecondsSinceEpoch >
          600) {
        gameRef.coinsCollected += 1;
        print("plants harvested ${gameRef.coinsCollected}");
        gameRef.remove(this);
      }
    }
    if (other is PlantComponent) {
      print("cant plant here!!");

      return;
    }
  }
}
