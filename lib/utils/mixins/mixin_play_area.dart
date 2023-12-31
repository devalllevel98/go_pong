import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_pong/main.dart';
import 'package:go_pong/utils/constants/ball_direction.dart';
import 'package:go_pong/views/home/home_view.dart';
import 'package:go_pong/views/play_area/sprites/brick.dart';

mixin MixinPlayArea {
  late Timer ballTimer;
  bool gameStart = false;
  double ballX = 0.0;
  double ballY = 0.0;
  double ballAngle = 0.005;

  BallDirection _ballXDirection = BallDirection.left;
  BallDirection _ballYDirection = BallDirection.down;
  BallDirection _enemyXDirection = BallDirection.left;

  double playerX = 0.0;
  double enemyX = 0.0;
  int playerScore = 0;
  int enemyScore = 0;
  int goalScore = 5;
  final boundary = 0.98;
  final playerGlobalKey = GlobalKey();
  final ballGlobalKey = GlobalKey();
  final botGlobalKey = GlobalKey();

  bool _checkCollide(GlobalKey brickKey, double brickXPos, double brickYPos) {
    RenderBox _ballBox =
        ballGlobalKey.currentContext!.findRenderObject() as RenderBox;
    RenderBox _brickBox =
        brickKey.currentContext!.findRenderObject() as RenderBox;

    final _ballSize = _ballBox.size;
    final _brickSize = _brickBox.size;

    final _ballPos = _ballBox.localToGlobal(Offset(ballX, ballY));
    final _brickPos = _brickBox.localToGlobal(Offset(brickXPos, brickYPos));

    final collide = (_ballPos.dx < _brickPos.dx + _brickSize.width &&
        _ballPos.dx + _ballSize.width > _brickPos.dx &&
        _ballPos.dy < _brickPos.dy + _brickSize.height &&
        _ballPos.dy + _ballSize.height > _brickPos.dy);
    if (collide) {
      if (ballAngle < 0.05) {
        ballAngle += 0.001;
      }
    }
    return collide;
  }

  void updateDirection() {
    // VERTICAL UPDATE
    if (ballY <= Brick.yTop &&
        _checkCollide(botGlobalKey, enemyX, Brick.yTop)) {
      _ballYDirection = BallDirection.down;
    }
    if (ballY >= Brick.yBottom &&
        _checkCollide(playerGlobalKey, playerX, Brick.yBottom)) {
      _ballYDirection = BallDirection.up;
    }

    // HORIZONTAL UPDATE
    if (ballX <= -1) {
      _ballXDirection = BallDirection.right;
    }
    if (ballX >= 1) {
      _ballXDirection = BallDirection.left;
    }
  }

  void moveBall() {
    // VERTICAL DIRECTION
    if (_ballYDirection == BallDirection.down) {
      ballY += 0.01;
    }
    if (_ballYDirection == BallDirection.up) {
      ballY -= 0.01;
    }

    // HORIZONTAL DIRECTION
    if (_ballXDirection == BallDirection.left) {
      ballX -= ballAngle;
    }
    if (_ballXDirection == BallDirection.right) {
      ballX += ballAngle;
    }
  }

  bool playerGoal() {
    if (ballY >= 1) {
      enemyScore += 1;
      return true;
    }
    if (ballY <= -1) {
      playerScore += 1;
      return true;
    }
    return false;
  }

  void resetGameVariables() {
    final _horizontalMovements = [BallDirection.left, BallDirection.right];
    if (ballY >= 1) {
      _ballYDirection = BallDirection.up;
    }
    if (ballY <= -1) {
      _ballYDirection = BallDirection.down;
    }
    _ballXDirection = (_horizontalMovements.toList()..shuffle()).first;
    ballX = 0.0;
    ballY = 0.0;
    ballAngle = 0.005;
    ballTimer.cancel();
  }

  void enemyMovement() {
    if (_ballYDirection == BallDirection.up) {
      if (_ballXDirection == BallDirection.left) {
        // Continue right
        if (_enemyXDirection != _ballXDirection &&
            ballX >= enemyX &&
            enemyX < boundary) {
          enemyX += ballAngle;
        } else if (enemyX > -boundary) {
          _enemyXDirection = _ballXDirection;
          enemyX -= ballAngle;
        }
      }
      if (_ballXDirection == BallDirection.right) {
        // Continue left
        if (_enemyXDirection != _ballXDirection &&
            ballX <= enemyX &&
            enemyX < boundary) {
          enemyX -= ballAngle;
        } else if (enemyX < boundary) {
          _enemyXDirection = _ballXDirection;
          enemyX += ballAngle;
        }
      }
    }
  }

  void moveLeft() {
    if (playerX > -boundary) {
      playerX -= 0.1;
    }
  }

  void moveRight() {
    if (playerX < boundary) {
      playerX += 0.1;
    }
  }

  void playAgain({
    required BuildContext context,
    required Function onPlayAgain,
    required Function onQuit,
  }) {
    String _title = enemyScore == 10 ? 'You Win!' : 'You Lose!';
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (builder) {
          return AlertDialog(
            backgroundColor: Colors.deepPurple,
            title: Center(
                child: Text(
              _title,
              style: const TextStyle(color: Colors.white),
            )),
            actions: [
              // InkWell(
              //   onTap: () => onPlayAgain(),
              //   child: ClipRRect(
              //     child: Container(
              //       padding: const EdgeInsets.all(7.0),
              //       color: Colors.deepPurple[100],
              //       child: Text(
              //         'Play Again',
              //         style: TextStyle(color: Colors.deepPurple[700]),
              //       ),
              //     ),
              //   ),
              // ),
              InkWell(
                // onTap: () => onQuit(),
                child: ClipRRect(
                  child: ElevatedButton(
                    child: const Text(
                      'Back Home',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 21,
                          fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomeView()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(255, 53, 8, 66),
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    ),
                  ),
                ),
              ),
            ],
          );
        });
  }
}
