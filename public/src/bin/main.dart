import 'dart:html';
import 'dart:math' as Math;
import 'package:vector_math/vector_math.dart';

final CanvasElement canvas = querySelector('#canvas');
final CanvasRenderingContext2D ctx = canvas.context2D;
final int width = canvas.width = window.innerWidth;
final int height = canvas.height = window.innerHeight;

class Movement {
  Direction direction = Direction.up;
  bool handled = false;

  void setUp() {
    window.onKeyDown.listen((e) {
      if (handled) {
        switch (e.keyCode) {
          case KeyCode.W:
            if (direction != Direction.down) {
              direction = Direction.up;
            }
            break;
          case KeyCode.D:
            if (direction != Direction.left) {
              direction = Direction.right;
            }
            break;
          case KeyCode.S:
            if (direction != Direction.up) {
              direction = Direction.down;
            }
            break;
          case KeyCode.A:
            if (direction != Direction.right) {
              direction = Direction.left;
            }
            break;
        }
      }

      handled = false;
    });
  }
}

final Movement movement = new Movement()..setUp();
final Snake snake = new Snake(new SnakeBlock(new Vector2(300.0, 300.0)));

void main() {
  window.animationFrame.then(render);
}

double lastNow = 0.0;

void render(double now) {
  ctx.clearRect(0, 0, width, height);

  final bool updateSnake = (now - lastNow >= 200);

  if (updateSnake) {
    lastNow = now;

    snake.update();
  }

  currentFoodBlock.draw();
  snake.draw();

  window.animationFrame.then(render);
}

enum Direction {
  up, right, down, left
}

class SnakePathCell {
  final Vector2 position;

  SnakePathCell(this.position);

  @override
  String toString() => 'SnakePathCell {position: $position}';
}

abstract class Block {
  static const double padding = 10.0;
  static const double sideLength = 50.0;
  static const double gridMultiple = sideLength + padding;

  Vector2 position;

  Block(this.position);

  void draw();

  @override
  String toString() => 'SnakeBlock {position: $position}';
}

class SnakeBlock extends Block {
  SnakeBlock(Vector2 position) : super(position);

  @override
  void draw() {
    ctx.setFillColorRgb(30, 30, 30);
    ctx.fillRect(position.x, position.y, Block.sideLength, Block.sideLength);
  }
}

Math.Random rand = new Math.Random();

class FoodBlock extends Block {
  FoodBlock(Vector2 position) : super(position);

  factory FoodBlock.findSuitablePosition(List<SnakePathCell> blocks) {
    Vector2 possiblePosition;

    do {
      possiblePosition = new Vector2(
          roundToNearest(rand.nextDouble() * Block.gridMultiple * 15, Block.gridMultiple.toInt()).toDouble(),
          roundToNearest(rand.nextDouble() * Block.gridMultiple * 15, Block.gridMultiple.toInt()).toDouble());
    }
    while (blocks.any((block) => block.position == possiblePosition));

    return new FoodBlock(possiblePosition);
  }

  @override
  void draw() {
    ctx.setFillColorRgb(23, 150, 240);
    ctx.fillRect(position.x, position.y, Block.sideLength, Block.sideLength);
  }

  @override
  String toString() => 'SnakeBlock {position: $position}';
}

FoodBlock currentFoodBlock = new FoodBlock.findSuitablePosition(new List());

class Snake {
  final List<SnakePathCell> _cells = new List();
  final List<SnakeBlock> _blocks = new List();

  Snake(SnakeBlock rootBlock) {
    _blocks.add(rootBlock);
  }

  void update() {
    Vector2 newPathCellPosition;

    if (_cells.isEmpty) {
      newPathCellPosition = new Vector2.copy(_blocks.first.position);
    }
    else {
      newPathCellPosition = new Vector2.copy(_cells.first.position);
    }

    switch (movement.direction) {
      case Direction.up:
        newPathCellPosition.add(new Vector2(0.0, -Block.gridMultiple));
        break;
      case Direction.right:
        newPathCellPosition.add(new Vector2(Block.gridMultiple, 0.0));
        break;
      case Direction.down:
        newPathCellPosition.add(new Vector2(0.0, Block.gridMultiple));
        break;
      case Direction.left:
        newPathCellPosition.add(new Vector2(-Block.gridMultiple, 0.0));
        break;
    }

    if (newPathCellPosition == currentFoodBlock.position) {
      currentFoodBlock = new FoodBlock.findSuitablePosition(_cells);
      _addBlock();
    }

    _cells.insert(0, new SnakePathCell(newPathCellPosition));

    if (_blocks.length < _cells.length) {
      _cells.removeRange(_blocks.length + 1, _cells.length);
    }

    for (int i = 0; i < _blocks.length; i++) {
      _blocks[i].position.setFrom(_cells[i].position);
    }

    movement.handled = true;
  }

  void draw() => _blocks.forEach((e) => e.draw());

  void _addBlock() => _blocks.add(new SnakeBlock(_cells[_blocks.length].position));
}

int roundToNearest(num x, int nearest) => (x / nearest).round() * nearest;

class TypedMath<T extends num> {
  T clamp(num x, T bounds0, T bounds1) =>
      Math.max(
          Math.min(
              x,
              Math.max(bounds0, bounds1)
          ),
          Math.min(bounds0, bounds1)
      );
}
