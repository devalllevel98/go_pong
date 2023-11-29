import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_pong/main.dart';
import 'package:go_pong/startScreen/guiline.dart';

class MenuScreen extends StatelessWidget {
  // const MenuScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
            child: Image.asset(
          "assets/bgmenu.png",
          fit: BoxFit.fill,
        )),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //start button app
              Padding(
                padding: EdgeInsets.all(10.0),
                child: ElevatedButton(
                  child: const Text(
                    'Manager List',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                        fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => MyApp()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 53, 8, 66),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  ),
                ),
              ),
              //guiline button app
              Padding(
                padding: EdgeInsets.all(15.0),
                child: ElevatedButton(
                  child: const Text(
                    'Use Guideline',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Guiline()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 136, 177, 35),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  ),
                ),
              ),
              //exit app button
              Padding(
                padding: EdgeInsets.all(15.0),
                child: ElevatedButton(
                  child: const Text(
                    'Exit App',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () => exit(0),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red[400],
                    padding: EdgeInsets.symmetric(horizontal: 64, vertical: 15),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
