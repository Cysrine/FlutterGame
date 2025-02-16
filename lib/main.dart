import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'my_game.dart';
import 'package:flame_audio/flame_audio.dart';

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

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  @override
  void initState() {
    super.initState();
    // Play the startup sound
    FlameAudio.play('loginsound.mp3'); // Ensure 'startup.mp3' is in assets/audio/
  }



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
                '4. Avoid getting hit by the asteroids.\n\n'
                'Good luck out there!',
                style: TextStyle(fontSize: 16, fontFamily: 'PixelFont'),
              ),
              Positioned(
                top: 55,
                right: -15,
                child: Image.asset(
                  'assets/ruleship.png',
                  width: 150,
                  height: 150,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK', style: TextStyle(fontFamily: 'PixelFont')),
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
          Positioned.fill(
            child: Image.asset('assets/pixelgalaxy.jpg', fit: BoxFit.cover),
          ),
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Asteroid Shooter',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    color: Colors.white,
                    fontFamily: 'PixelFont',
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 30,
                  width: 210,
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
                const SizedBox(height: 10),
                SizedBox(
                  width: 150,
                  child: ElevatedButton(
                    onPressed: () {
                      _showRules(context);
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

  final MyGame game = MyGame();

  @override
  _GameScreenState createState() => _GameScreenState();
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
        color: Colors.black.withOpacity(0.7),
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
                  widget.game.overlays.remove('GameOver');
                  widget.game.resumeEngine();
                  widget.game.reset();
                });
              },
              child: const Text('Try Again', style: TextStyle(fontFamily: 'PixelFont')),
            ),
            const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const MainMenu()),
                (route) => false, // Clear navigation stack
              );
            },
            child: const Text('Main Menu', style: TextStyle(fontFamily: 'PixelFont')),
          ),
          ],
        ),
      ),
    );
  }
}
