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
                  style: TextStyle(fontSize: 32,
                  color: Colors.white,
                  fontFamily: 'PixelFont'),
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
                  child: const Text('Start Game', style: TextStyle(fontFamily: 'PixelFont')),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class GameScreen extends StatefulWidget {
  GameScreen({super.key});

  final MyGame game = MyGame(); // Creating the game instance

  @override
  _GameScreenState createState() => _GameScreenState();

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: GameWidget(game: game),
  //   );
  // }
}

class _GameScreenState extends State<GameScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GameWidget(
            game: widget.game,
            overlayBuilderMap: {
              'GameOver': (context, _) => gameOverScreen(context),
            },
          ),
        ],
      ),
    );
  }

  Widget gameOverScreen(BuildContext context) {
    return Center(
      child: Container(
        color: Colors.black.withValues(alpha: 0.7),
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Game Over',
              style: TextStyle(fontSize: 36, color: Colors.white, fontFamily: 'PixelFont'),
            ),
            const SizedBox(height: 10),
            Text(
              'Final Score: ${widget.game.scoreText.score}',
              style: TextStyle(fontSize: 24, color: Colors.white, fontFamily: 'PixelFont'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  widget.game.overlays.remove('GameOver'); // Hide overlay
                  widget.game.resumeEngine(); // Resume game
                  widget.game.reset(); // Restart game
                });
              },
              child: const Text('Try Again', style: TextStyle(fontFamily: 'PixelFont')),
            ),
          ],
        ),
      ),
    );
  }
}
