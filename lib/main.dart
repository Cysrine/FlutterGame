import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'my_game.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MainMenu(),
    );
  }
}

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Change: Background image added
          Positioned.fill(
            child: Image.asset('assets/pixelgalaxy.jpg',fit: BoxFit.cover,),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Asteroid Shooter',
                  style: TextStyle(fontSize: 32, color: Colors.white),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GameScreen(),
                      ),
                    );
                  },
                  child: const Text('Start Game'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class GameScreen extends StatelessWidget {
  GameScreen({super.key});

  final MyGame game = MyGame(); // Creating the game instance

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameWidget(game: game),
    );
  }
}
