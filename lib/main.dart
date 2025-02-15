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
          title: const Text('Game Rules'),
          content: Stack(
            children: [
              const Text(
                'Welcome to Asteroid Shooter!\n\n'
                '1. Shoot the falling asteroids to earn points.\n'
                '2. Red asteroids are worth 3 points.\n'
                '3. Other asteroids are worth 1 point.\n'
                '4. Avoid letting the asteroids hit the ground.\n\n'
                'Good luck and have fun!',
                style: TextStyle(fontSize: 16),
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
                  width: 150, // Fixed width for the buttons
                  child: ElevatedButton(
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
                ),
                const SizedBox(height: 10), // Space between buttons
                SizedBox(
                  width: 150, // Fixed width for the buttons
                  child: ElevatedButton(
                    onPressed: () {
                      _showRules(context); // Show the rules dialog
                    },
                    child: const Text('Rules'),
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