import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:my_little_worlds/my_world.dart';
import 'package:my_little_worlds/world/obstacles.dart';

class PlayerComponent extends SpriteAnimationComponent
    with CollisionCallbacks, HasGameRef<MyWorld> {
  PlayerComponent() {
    //{required size, required position, required animation}
    debugMode = true;
    animation = animation;
  }

  int count = 0;
  bool _hasCollided = false;

  @override
  void onMount() {
    super.onMount();
    add(RectangleHitbox());
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is ObstacleComponent) {
      if (!_hasCollided) {
        gameRef.collisionDirection = gameRef.direction;
        _hasCollided = true;
      }
    }
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
    //set back collision to none beccause none means no collision
    gameRef.collisionDirection = Direction.none;
    _hasCollided = false;
  }
}
