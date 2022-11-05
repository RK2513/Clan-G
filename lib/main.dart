import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:tictactoe/ui/color.dart';
import 'Utils/game_logic.dart';
import 'dart:async';
import 'dart:math';
import 'package:flutter/services.dart';

enum Direction { up, down, left, right }

void main() {
  runApp(
    MaterialApp(
      title: '2 in 1 game',
      initialRoute: '/',
      routes: {
        '/': (context) => const FirstScreen(), //HomeScreen
        '/second': (context) => const SnakeScreen(), //SnakeGame
        '/third': (context) => const MyApp(), //TictactoeGame
      },
    ),
  );
}

//HomeScreen
class FirstScreen extends StatelessWidget {
  const FirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 229, 183, 16), //color change

      appBar: AppBar(
        centerTitle: true,
        title: const Text('2 IN 1 GAME',
            style: TextStyle(color: Color.fromARGB(255, 255, 255, 255))),
        backgroundColor: Color.fromARGB(255, 26, 35, 126),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/snake.png', height: 80, width: 80),
            ElevatedButton(
              // Within the `FirstScreen` widget
              onPressed: () {
                // Navigate to the second screen using a named route.
                Navigator.pushNamed(context, '/second');
              },
              child: const Text('BLOCKADE'),
              style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 26, 35, 126),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                  textStyle:
                      TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
            ),
            Image.asset('assets/xo.png', height: 80, width: 80),
            ElevatedButton(
              // Within the `FirstScreen` widget
              onPressed: () {
                // Navigate to the second screen using a named route.
                Navigator.pushNamed(context, '/third');
              },
              child: const Text(' TIC TAC TOE '),
              style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 26, 35, 126),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                  textStyle:
                      TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
            ),
            ClipOval(
              child: Image.asset(
                "assets/ing.jpg",
                height: 80.0,
                width: 80.0,
                fit: BoxFit.cover,
              ),
            ),
            Text("CREATIVE",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          ],
        ),
      ),
    );
  }
}

//SnakeGame
class SnakeScreen extends StatelessWidget {
  const SnakeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        primaryColor: Colors.indigo[900],
      ),
      home: const HomePage(),
    );
  }
}

//tictactoe
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GameScreen(),
    );
  }
}

//SnakeGame
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

//TicTacToe
class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

//TicTacToe
class _GameScreenState extends State<GameScreen> {
  String lastValue = "X";
  bool gameOver = false;
  Game game = Game();
  int turn = 0;
  String result = "";
  List<int> scoreboard = [0, 0, 0, 0, 0, 0, 0, 0];
  final controller = ConfettiController();
  bool isPlaying = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    game.board = Game.initGameBoard();
    print(game.board);
  }

  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double boardWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Maincolor.primaryColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "It's ${lastValue} Turn".toUpperCase(),
            style: TextStyle(color: Colors.white, fontSize: 40),
          ),
          SizedBox(
            height: 20.0,
          ),
          ConfettiWidget(
            confettiController: controller,
            shouldLoop: true,
            blastDirectionality: BlastDirectionality.explosive,
          ),
          Container(
              width: boardWidth,
              height: boardWidth,
              child: GridView.count(
                crossAxisCount: Game.boardlenth ~/ 3,
                padding: EdgeInsets.all(16.0),
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
                children: List.generate(
                  Game.boardlenth,
                  (index) {
                    return InkWell(
                      onTap: gameOver
                          ? null
                          : () {
                              if (game.board![index] == "") {
                                setState(() {
                                  game.board![index] = lastValue;
                                  turn++;
                                  gameOver = game.winnerCheck(
                                      lastValue, index, scoreboard, 3);
                                  if (gameOver) {
                                    result = "$lastValue IS THE WINNER";
                                    isPlaying = true;
                                    controller.play();
                                  } else if (!gameOver && turn == 9) {
                                    result = "IT'S A DRAW!";
                                    gameOver = true;
                                  }
                                  if (lastValue == "X")
                                    lastValue = "O";
                                  else
                                    lastValue = "X";
                                });
                              }
                            },
                      child: Container(
                        width: Game.blocSize,
                        height: Game.blocSize,
                        decoration: BoxDecoration(
                            color: Maincolor.secondaryColor,
                            borderRadius: BorderRadius.circular(16.0)),
                        child: Center(
                          child: Text(
                            game.board![index],
                            style: TextStyle(
                              color: game.board![index] == "X"
                                  ? Colors.blue
                                  : Colors.pink,
                              fontSize: 80.0,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )),
          SizedBox(
            height: 25.0,
          ),
          Text(
            result,
            style: TextStyle(color: Colors.white, fontSize: 40.0),
          ),
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                game.board = Game.initGameBoard();
                lastValue = "X";
                gameOver = false;
                turn = 0;
                result = "";
                scoreboard = [0, 0, 0, 0, 0, 0, 0, 0];
                isPlaying = false;
                controller.stop();
              });
            },
            icon: Icon(Icons.replay),
            label: Text("REPEAT THE GAME"),
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Color.fromARGB(255, 26, 35, 126)),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(
                context,
                rootNavigator: true,
              ).pop(context);
            },
            icon: Icon(Icons.arrow_back),
            label: Text("BACK"),
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Color.fromARGB(255, 26, 35, 126)),
          ),
        ],
      ),
    );
  }
}

//SnakeGame
class _HomePageState extends State<HomePage> {
  // Down or right - head val is grater than other
  //up or left - head val is less than other
  // head refers to last element of array
  List<int> snakePosition = [24, 44, 64];
  int foodLocation = Random().nextInt(700);
  bool start = false;
  Direction direction = Direction.down;
  List<int> totalSpot = List.generate(760, (index) => index); //totalspot
  startGame() {
    start = true;
    snakePosition = [24, 44, 64];
    Timer.periodic(const Duration(milliseconds: 300), (timer) {
      updateSnake();
      if (gameOver()) {
        gameOverAlert();
        timer.cancel();
      }
    });
  }

  updateSnake() {
    if (this.mounted) {
      setState(() {
        switch (direction) {
          case Direction.down:
            if (snakePosition.last > 740) {
              snakePosition.add(snakePosition.last - 760 + 20);
            } else {
              snakePosition.add(snakePosition.last + 20);
            }
            break;
          case Direction.up:
            if (snakePosition.last < 20) {
              snakePosition.add(snakePosition.last + 760 - 20);
            } else {
              snakePosition.add(snakePosition.last - 20);
            }
            break;
          case Direction.right:
            if ((snakePosition.last + 1) % 20 == 0) {
              snakePosition.add(snakePosition.last + 1 - 20);
            } else {
              snakePosition.add(snakePosition.last + 1);
            }
            break;
          case Direction.left:
            if (snakePosition.last % 20 == 0) {
              snakePosition.add(snakePosition.last - 1 + 20);
            } else {
              snakePosition.add(snakePosition.last - 1);
            }
            break;
          default:
        }
        if (snakePosition.last == foodLocation) {
          totalSpot.removeWhere((element) => snakePosition.contains(element));

          foodLocation = totalSpot[Random().nextInt(totalSpot.length -
              1)]; //new food location is everywhere expect snackPosition
        } else {
          snakePosition.removeAt(0);
        }
      });
    }
  }

  bool gameOver() {
    final copyList = List.from(snakePosition);
    if (snakePosition.length > copyList.toSet().length) {
      return true;
    } else {
      return false;
    }
  }

  gameOverAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color.fromARGB(255, 26, 35, 126),
          title: const Text(
            'GAME OVER',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),
          ),
          content: Text(
            'YOUR SCORE IS ' + (snakePosition.length - 3).toString(),
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  startGame();
                  Navigator.of(context).pop(true);
                },
                child: const Text(
                  'PLAY AGAIN',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                )),
            TextButton(
                onPressed: () {
                  SystemNavigator.pop();
                },
                child: const Text(
                  'EXIT',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ))
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: SafeArea(
        child: GestureDetector(
          onVerticalDragUpdate: (details) {
            if (direction != Direction.up && details.delta.dy > 0) {
              direction = Direction.down;
            }
            if (direction != Direction.down && details.delta.dy < 0) {
              direction = Direction.up;
            }
          },
          onHorizontalDragUpdate: (details) {
            if (direction != Direction.left && details.delta.dx > 0) {
              direction = Direction.right;
            }
            if (direction != Direction.right && details.delta.dx < 0) {
              direction = Direction.left;
            }
          },
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 760,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 20),
            itemBuilder: (context, index) {
              if (snakePosition.contains(index)) {
                return Container(
                  color: Colors.white,
                );
              }
              if (index == foodLocation) {
                return Container(
                  color: Colors.red,
                );
              }
              return Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('images/grass.jpg'), fit: BoxFit.cover),
                ),
                //color: Color.fromARGB(255, 11, 197, 67),
              );
            },
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FloatingActionButton(
              heroTag: "btt1",
              onPressed: () {
                Navigator.of(
                  context,
                  rootNavigator: true,
                ).pop(context);
              },
              child: Icon(Icons.arrow_back),
              backgroundColor: Colors.white,
              foregroundColor: Color.fromARGB(255, 26, 35, 126),
            ),
            FloatingActionButton(
              heroTag: "btt2",
              onPressed: start ? () {} : startGame,
              child: start
                  ? Text((snakePosition.length - 3).toString())
                  : Icon(Icons.play_circle),
              backgroundColor: Colors.white,
              foregroundColor: Color.fromARGB(255, 26, 35, 126),
            ),
          ],
        ),
      ),
    );
  }
}
