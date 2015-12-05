import 'dart:html';
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

bool tmp = false;
bool tmp2 = false;
bool tmp3 = false;
bool tmp4 = false;
bool tmp5 = false;
bool tmp6 = false;

void render(double now) {
  ctx.clearRect(0, 0, width, height);

  final bool updateSnake = (now - lastNow >= 200);

  if (updateSnake) {
    lastNow = now;

    snake.update();
  }

  if (now >= 5000 && ! tmp) {
    snake.addBlock();
    tmp = true;
  }

  if (now >= 10000 && ! tmp2) {
    snake.addBlock();
    tmp2 = true;
  }

  if (now >= 15000 && ! tmp3) {
    snake.addBlock();
    tmp3 = true;
  }

  if (now >= 20000 && ! tmp4) {
    snake.addBlock();
    tmp4 = true;
  }

  if (now >= 25000 && ! tmp5) {
    snake.addBlock();
    tmp5 = true;
  }

  if (now >= 30000 && ! tmp6) {
    snake.addBlock();
    tmp6 = true;
  }

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

class SnakeBlock {
  static const double padding = 10.0;
  static const double width = 50.0;
  static const double height = 50.0;

  Vector2 position;

  SnakeBlock(this.position);

  void draw() => ctx.fillRect(position.x, position.y, width, height);

  @override
  String toString() => 'SnakeBlock {position: $position}';
}

class Snake {
  static const double toMoveX = SnakeBlock.width + SnakeBlock.padding;
  static const double toMoveY = SnakeBlock.height + SnakeBlock.padding;

  final List<SnakePathCell> cells = new List();
  final List<SnakeBlock> blocks = new List();

  Snake(SnakeBlock rootBlock) {
    blocks.add(rootBlock);
  }

  void update() {
    Vector2 newPathCellPosition;

    if (cells.isEmpty) {
      newPathCellPosition = new Vector2.copy(blocks.first.position);
    }
    else {
      newPathCellPosition = new Vector2.copy(cells.first.position);
    }

    switch (movement.direction) {
      case Direction.up:
        newPathCellPosition.add(new Vector2(0.0, -toMoveY));
        break;
      case Direction.right:
        newPathCellPosition.add(new Vector2(toMoveX, 0.0));
        break;
      case Direction.down:
        newPathCellPosition.add(new Vector2(0.0, toMoveY));
        break;
      case Direction.left:
        newPathCellPosition.add(new Vector2(-toMoveX, 0.0));
        break;
    }

    cells.insert(0, new SnakePathCell(newPathCellPosition));

    if (blocks.length < cells.length) {
      cells.removeRange(blocks.length + 1, cells.length);
    }

    for (int i = 0; i < blocks.length; i++) {
      blocks[i].position.setFrom(cells[i].position);
    }

    movement.handled = true;
  }

  void draw() => blocks.forEach((e) => e.draw());

  void addBlock() => blocks.add(new SnakeBlock(cells[blocks.length].position));
}
