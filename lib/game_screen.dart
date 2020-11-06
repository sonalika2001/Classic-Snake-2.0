import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  static List<int> snakePosition = [45, 65, 85, 105, 125];
int game=0;
  int noOfSquares = 560;
  static var randomNumber = Random();
  int food = randomNumber.nextInt(460);

  void generateFood() {
    food = randomNumber.nextInt(460);
  }

  void startGame() {
    game=1;
    snakePosition = [
      45,
      65,
      85,
      105,
      125
    ]; //to bring back to this positon each time one starts
    const duration = const Duration(milliseconds: 300);
    Timer.periodic(duration, (Timer timer) {
      updateSnake();
      if (gameOver()) {
        timer.cancel();
        _showGameOverScreen();
      }
    });
  }

  var direction = 'down';
  void updateSnake() {
    setState(() {
      switch (direction) {
        case 'down':
          if (snakePosition.last > 539)
            snakePosition.add(snakePosition.last + 20 - 560);
          else
            snakePosition.add(snakePosition.last + 20);

          break;
        case 'up':
          if (snakePosition.last < 20)
            snakePosition.add(snakePosition.last - 20 + 560);
          else
            snakePosition.add(snakePosition.last - 20);

          break;

        case 'left':
          if (snakePosition.last % 20 == 0) {
            snakePosition.add(snakePosition.last + 19);
          } else
            snakePosition.add(snakePosition.last - 1);
          break;

        case 'right':
          if ((snakePosition.last+1) % 20 == 0) {
            snakePosition.add(snakePosition.last - 19);
          } else
            snakePosition.add(snakePosition.last + 1);
          break;

        default:
      }

      if (snakePosition.last == food) {
        generateFood();
      } else
        snakePosition.removeAt(0); //to make the snake look like its moving
    });
  }

  bool gameOver() {
    
    for (int i = 0; i < snakePosition.length; i++) {
      int count = 0;
      for (int j = 0; j < snakePosition.length; j++) {
        if (snakePosition[i] == snakePosition[j]) {
          count += 1;
        }
      }
      if (count == 2) {game=0;return true;}
    }
    return false;
  }

  void _showGameOverScreen() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'GAME OVER',
          ),
          content: Text(
            'Your score is ' + snakePosition.length.toString(),
          ),
          actions: [
            FlatButton(
              onPressed: () {
                startGame();
                Navigator.of(context).pop();
              },
              child: Text(
                'Play Again',
              ),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        minimum: EdgeInsets.only(left: 4, right: 4, top: 70, bottom: 4),
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(
                  vertical: 10,),
            ),
            Expanded(
              flex: 6,
              child: GestureDetector(
                onHorizontalDragUpdate: (details) {
                  if (direction != 'right' && details.delta.dx < 0) {
                    direction = 'left';
                  } else if (direction != 'left' && details.delta.dx > 0) {
                    direction = 'right';
                  }
                },
                onVerticalDragUpdate: (details) {
                  if (direction != 'up' && details.delta.dy > 0) {
                    direction = 'down';
                  }
                  if (direction != 'down' && details.delta.dy < 0) {
                    direction = 'up';
                  }
                },
                child: Container(
                  child: GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: noOfSquares,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 20),
                      itemBuilder: (context, int index) {
                        if (snakePosition.contains(index)) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Container(
                                color: Colors.white,
                              ),
                            ),
                          );
                        }
                        if (index == food) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Container(
                                color: Colors.deepOrange,
                              ),
                            ),
                          );
                        } else {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Container(
                                color: Colors.grey[900],
                              ),
                            ),
                          );
                        }
                      }),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        if(game==0){
                        startGame();}
                      },
                      child: Text(
                        'Start',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Text(
                      'How to play',
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
