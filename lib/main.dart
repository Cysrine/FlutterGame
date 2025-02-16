import 'dart:developer';
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

  // Function to show the rules in a dialog with an image in the corner
  void _showRules(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Game Rules', style: TextStyle(fontSize: 18, fontFamily: 'PixelFont', decoration: TextDecoration.underline)),
          content: Stack(
            children: [
              const Text(
                'Welcome to Asteroid Shooter!\n\n'
                '1. Shoot the falling asteroids to earn points.\n'
                '2. Red asteroids are worth 3 points.\n'
                '3. Other asteroids are worth 1 point.\n'
                '4. Avoid letting the asteroids hit the ground.\n\n'
                'Good luck and have fun!',
                style: TextStyle(fontSize: 16, fontFamily: 'PixelFont'),
              ),
              Positioned(
                top: 0, // Adjust the position of the image
                right: 0, // Adjust the position of the image
                child: Image.asset(
                  'assets/tinyrocket.jpg', // Path to your image
                  width: 50, // Adjust the size of the image
                  height: 50, // Adjust the size of the image
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          // Background image
          Positioned.fill(
            child: Image.asset('assets/pixelgalaxy.jpg', fit: BoxFit.cover),
          ),
          
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Asteroid Shooter',
                  style: TextStyle(
                    fontSize: 32,
                    color: Colors.white,
                    fontFamily: 'PixelFont',
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 30,
                  width: 210, // Fixed width for the buttons
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GameScreen(),
                        ),
                      );
                    },
                    child: const Text('Start Game', style: TextStyle(fontSize: 16, fontFamily: 'PixelFont')),
                  ),
                ),
                const SizedBox(height: 10), // Space between buttons
                SizedBox(
                  width: 150, // Fixed width for the buttons
                  child: ElevatedButton(
                    onPressed: () {
                      _showRules(context); // Show the rules dialog
                    },
                    child: const Text('Rules', style: TextStyle(fontSize: 16, fontFamily: 'PixelFont')),
                  ),
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