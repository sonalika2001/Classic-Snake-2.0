import 'package:flutter/material.dart';
import 'package:snake_game/game_screen.dart';

void main() {
  runApp(Snake2());
}

class Snake2 extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GameScreen(),
    );
  }
}
