import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_pong/utils/mixins/mixin_navigator.dart';
import 'package:go_pong/utils/mixins/mixin_play_area.dart';
import 'package:go_pong/views/home/home_view.dart';
import 'package:go_pong/views/play_area/scoreboard/player_score.dart';
import 'package:go_pong/views/play_area/scoreboard/score_line.dart';
import 'package:go_pong/views/play_area/sprites/ball.dart';
import 'package:go_pong/views/play_area/sprites/brick.dart';
import 'package:go_pong/shared_widgets/stack_text.dart';

class PlayAreaView extends StatefulWidget {
  static const route = '/play_area';
  const PlayAreaView({Key? key}) : super(key: key);

  @override
  State<PlayAreaView> createState() => _PlayAreaViewState();
}

class _PlayAreaViewState extends State<PlayAreaView>
    with MixinPlayArea, MixinNavigator {
  void _gameEvent() {
    Timer.periodic(const Duration(milliseconds: 8), (timer) {
      ballTimer = timer;
      setState(() {
        updateDirection();
        moveBall();
        enemyMovement();

        if (playerGoal()) {
          resetGameVariables();
          if ([enemyScore, playerScore].contains(goalScore)) {
            playAgain(
              context: context,
              onPlayAgain: () {
                Navigator.of(context).pop();
                enemyScore = 0;
                playerScore = 0;
                _gameEvent();
              },
              onQuit: () => routePushReplaced(context, HomeView.route),
            );
          } else {
            _gameEvent();
          }
        }
      });
    });
  }

  void _startGame() {
    if (!gameStart) {
      setState(() {
        gameStart = true;
        _gameEvent();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _startGame,
      onHorizontalDragUpdate: (DragUpdateDetails details) {
        if (gameStart) {
          double _position = details.delta.dx;
          if (_position > 0 && _position > 2.0) {
            setState(() {
              moveRight();
            });
          }
          // Swiping in left direction.
          if (_position < 0 && _position < -2.0) {
            setState(() {
              moveLeft();
            });
          }
        }
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Positioned.fill(
                child: Image.asset(
              'assets/bg.png',
              fit: BoxFit.fill,
            )),
            SafeArea(
              child: Center(
                child: Stack(
                  children: [
                    if (!gameStart)
                      const StackText(
                        textSize: 20.0,
                        xPosition: 0.0,
                        yPosition: 0.95,
                        text: 'TAP  TO  PLAY',
                      ),
                    // SCORE BOARD
                    PlayerScore(
                        xPosition: 0, yPosition: -0.2, score: enemyScore),
                    const ScoreLine(),
                    PlayerScore(
                        xPosition: 0, yPosition: 0.2, score: playerScore),
                    // SPRITES
                    Brick(
                      x: enemyX,
                      isNegative: true,
                      brickGlobalKey: botGlobalKey,
                    ),
                    Ball(
                      x: ballX,
                      y: ballY,
                      ballGlobalKey: ballGlobalKey,
                    ),
                    Brick(
                      x: playerX,
                      isNegative: false,
                      brickGlobalKey: playerGlobalKey,
                    ),
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
