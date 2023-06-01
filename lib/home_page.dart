// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:snake_game_flutter/blank_pixel.dart';
import 'package:snake_game_flutter/food_pixel.dart';
import 'package:snake_game_flutter/snake_pixel.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

//Snake_direction
enum snakeDirection { UP, DOWN, LEFT, RIGHT }

class _HomePageState extends State<HomePage> {
  //game dimension
  var rowSize = 10;
  var totalNumberOfSquares = 100;

  //snake dimension
  List<int> snakePos = [0, 1, 2];

  // snake food position
  int foodPos = 55;

  //initially snake moves from right
  var currentDirection = snakeDirection.RIGHT;

  //start game
  void startGame() {
    Timer.periodic(Duration(milliseconds: 250), (timer) {
      setState(() {
        snakeMove();

        if (gameOver()) {
          timer.cancel();
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Game Over'),
                );
              });
        }
      });
    });
  }

  //generate new food where snakes not lies
  void eatingFood() {
    while (snakePos.contains(foodPos)) {
      foodPos = Random().nextInt(totalNumberOfSquares);
    }
  }

  //snake body

  //game over
  bool gameOver() {
    List<int> bodysnake = snakePos.sublist(0, snakePos.length - 1
    );

    if (bodysnake.contains(snakePos.last)) {
      return true;
    } else {
      return false;
    }
  }

  void snakeMove() {
    switch (currentDirection) {
      case snakeDirection.RIGHT:
        {
          //checking snake moves on same row righty
          if (snakePos.last % rowSize == 9) {
            snakePos.add(snakePos.last + 1 - rowSize);
          } else {
            //checking snakes moving right correctly
            snakePos.add(snakePos.last + 1);
          }
        }

        break;
      case snakeDirection.LEFT:
        {
          //checking snake moves on same row leftty
          if (snakePos.last % rowSize == 0) {
            snakePos.add(snakePos.last - 1 + rowSize);
          } else {
            //checking snakes moving left correctly
            snakePos.add(snakePos.last - 1);
          }
          //snakePos.removeAt(0);
        }

        break;

      case snakeDirection.UP:
        {
          //checking snake moves on same column upward
          if (snakePos.last < rowSize) {
            snakePos.add(snakePos.last - rowSize + totalNumberOfSquares);
          } else {
            //checking snakes moving upward correctly
            snakePos.add(snakePos.last - rowSize);
          }
        }

        break;
      case snakeDirection.DOWN:
        {
          //checking snake moves on same column downward
          if (snakePos.last + rowSize >= totalNumberOfSquares) {
            snakePos.add(snakePos.last + rowSize - totalNumberOfSquares);
          } else {
            //checking snakes moving downward correctly
            snakePos.add(snakePos.last + rowSize);
          }
        }

        break;

      default:
    }
    //snake eating food and increment its length
    if (snakePos.last == foodPos) {
      eatingFood();
    } else {
      //remove tail
      snakePos.removeAt(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: Container(),
          ),
          Expanded(
            flex: 3,
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                if (details.delta.dy > 0 &&
                    currentDirection != snakeDirection.UP) {
                  currentDirection = snakeDirection.DOWN;
                } else if (details.delta.dy < 0 &&
                    currentDirection != snakeDirection.DOWN) {
                  currentDirection = snakeDirection.UP;
                }
              },
              onHorizontalDragUpdate: (details) {
                if (details.delta.dx > 0 &&
                    currentDirection != snakeDirection.LEFT) {
                  currentDirection = snakeDirection.RIGHT;
                } else if (details.delta.dx < 0 &&
                    currentDirection != snakeDirection.RIGHT) {
                  currentDirection = snakeDirection.LEFT;
                }
              },
              child: GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: totalNumberOfSquares,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: rowSize),
                itemBuilder: (BuildContext, index) {
                  if (snakePos.contains(index)) {
                    return SnakePixel();
                  } else if (foodPos == index) {
                    return FoodPixel();
                  } else {
                    return BlankPixel();
                  }
                },
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: Center(
                child: MaterialButton(
                  onPressed: startGame,
                  child: Text('PLAY'),
                  color: Colors.pink,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
