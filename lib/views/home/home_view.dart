import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_pong/startScreen/guiline.dart';
import 'package:go_pong/utils/mixins/mixin_navigator.dart';
import 'package:go_pong/views/play_area/play_area_view.dart';
import 'package:go_pong/shared_widgets/stack_text.dart';

class HomeView extends StatefulWidget {
  static const route = '/';
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with MixinNavigator {
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
              child: Image.asset(
            'assets/bgmenu.png',
            fit: BoxFit.fill,
          )),
          Center(
            child: Stack(
              children: [
                StackText(
                  textSize: 25.0,
                  xPosition: 0.0,
                  yPosition: -0.2,
                  text: '● Start Game ●',
                  subTextSize: 20.0,
                  onTap: () => routePushReplaced(context, PlayAreaView.route),
                ),
                StackText(
                  textSize: 25.0,
                  xPosition: 0.0,
                  yPosition: 0.0,
                  text: '● Helps ●',
                  onTap: () => {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Guiline()),
                    )
                  },
                ),
                StackText(
                  textSize: 25.0,
                  xPosition: 0.0,
                  yPosition: 0.2,
                  text: '● Exit App ●',
                  onTap: () => {exit(0)},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
