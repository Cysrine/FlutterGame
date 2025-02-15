import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
    const HomePage({Key? key}) : super(key: key);

    @override 
    _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

    double ballX = 0;
    double ballY = 0;

    double playerX = 0;
    double playerWidth = 0.3;

    bool hasGameStart = false;

    void startGame() {
        hasGameStarted = true;
        Timer.periodic(Duration(milliseconds: 10), (timer) {
            setState(() {
                ballY -= 0.01;
            });
        });
    }

    @override
    Widget build(BuildContext context) {
        return KeyboardListener(
            focusNode: FocusNode(), 
            autofocus: true,
            onKey: (event) {
                if(event.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
                    moveLeft();
                } else if (event.isKeyPressed(LogicaKeyboardKey.arrowRight)) {
                    moveRight();
                }
            })
        return GestureDetector(
            onTap: startGame,
            child: Scaffold(
                backgroundColor: const Color.fromARGB(255, 188, 164, 233),
                body: Center(
                    child: Stack(
                        children: [
                            
                            CoverScreen(
                                hasGameStarted: hasGameStarted,
                                ),
                            MyBall(
                                ballX, ballY,
                                ballY, ballX,
                            ),
                            MyPlayer(
                                playerX: playerX,
                                playerWidth: playerWidth,
                            ),
                        ],
                    ),
                ),
            )
        );
    }
}
