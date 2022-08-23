import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/sprite.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_little_worlds/actors/plant.dart';
import 'package:tiled/tiled.dart';

import 'actors/player.dart';
import 'world/obstacles.dart';

enum Direction {
  idle,
  up,
  down,
  left,
  right,
  none
} //none means no collisionat current tiem

class MyWorld extends FlameGame with KeyboardEvents, HasCollisionDetection {
  Vector2 velocity = Vector2(0, 0);
  late TiledComponent homeMap;
  late double mapWidth;
  late double mapHeight;

  //splayer sprites
  late PlayerComponent player;
  late SpriteAnimation upAnimation;
  late SpriteAnimation downAnimation;
  late SpriteAnimation leftAnimation;
  late SpriteAnimation rightAnimation;
  late SpriteAnimation idleAnimation;

  //plant sprites
  late PlantComponent plant;

  //spped double
  double animationSpeed = 0.25;
  double playerSpeed = 10;
  //int game variables
  int coinsCollected = 0;

  Direction direction = Direction.idle;
  Direction collisionDirection = Direction.none;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    homeMap = await TiledComponent.load("map.tmx", Vector2.all(32));
    add(homeMap);

    mapWidth = homeMap.tileMap.map.width * 32.0;
    mapHeight = homeMap.tileMap.map.height * 32.0;

    final obstacles = homeMap.tileMap.getLayer<ObjectGroup>("obstacles");

    for (var obstacle in obstacles!.objects) {
      add(ObstacleComponent(
          size: Vector2(obstacle.width, obstacle.height),
          position: Vector2(obstacle.x, obstacle.y)));
    }

    final spriteSheet = SpriteSheet(
        image: await images.load("hero.png"), srcSize: Vector2.all(32));

    downAnimation =
        spriteSheet.createAnimation(row: 0, stepTime: animationSpeed);
    rightAnimation =
        spriteSheet.createAnimation(row: 1, stepTime: animationSpeed);
    upAnimation = spriteSheet.createAnimation(row: 2, stepTime: animationSpeed);
    leftAnimation =
        spriteSheet.createAnimation(row: 3, stepTime: animationSpeed);
    idleAnimation =
        spriteSheet.createAnimation(row: 0, stepTime: animationSpeed, to: 1);

    player = PlayerComponent()
      ..animation = idleAnimation
      ..size = Vector2.all(50)
      ..position = Vector2(100, 30)
      ..debugMode = true;
    add(player);

    camera.followComponent(player,
        worldBounds: Rect.fromLTRB(0, 0, mapWidth, mapHeight));
  }

  @override
  void update(double dt) {
    super.update(dt);
    //something here?
  }

  @override
  KeyEventResult onKeyEvent(
    RawKeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    final isKeyDown = event is RawKeyDownEvent;
    final isKeyUp = event is RawKeyUpEvent;
    final isArrowUp = keysPressed.contains(LogicalKeyboardKey.arrowUp);
    final isArrowDown = keysPressed.contains(LogicalKeyboardKey.arrowDown);
    final isArrowLeft = keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    final isArrowRight = keysPressed.contains(LogicalKeyboardKey.arrowRight);

    //p for plant
    final isKeyP = keysPressed.contains(LogicalKeyboardKey.keyP);

    if (isKeyDown) {
      if (isKeyP) {
        plant = PlantComponent()
          ..x = player.x
          ..y = player.y
          ..size = Vector2.all(32);
        if (plant.collidingWith(plant)) {
          print("plant is colliding");
          return KeyEventResult.ignored;
        }
        add(plant);
      }
      if (isArrowUp) {
        if (player.y > 0) {
          direction = Direction.up;
          if (collisionDirection != Direction.up) {
            player.position.y -= playerSpeed;
            player.animation = upAnimation;
          }
        }
      } else if (isArrowDown) {
        if (player.y < mapHeight - player.height) {
          direction = Direction.down;
          if (collisionDirection != Direction.down) {
            player.position.y += playerSpeed;
            player.animation = downAnimation;
          }
        }
      } else if (isArrowLeft) {
        if (player.x > 0) {
          direction = Direction.left;
          if (collisionDirection != Direction.left) {
            player.position.x -= playerSpeed;
            player.animation = leftAnimation;
          }
        }
      } else if (isArrowRight) {
        if (player.x < mapWidth - player.width) {
          direction = Direction.right;
          if (collisionDirection != Direction.right) {
            player.position.x += playerSpeed;
            player.animation = rightAnimation;
          }
        }
      }
    } else if (isKeyUp) {
      direction = Direction.idle;
      player.animation = idleAnimation;
    }

    return KeyEventResult.ignored;
  }
}
