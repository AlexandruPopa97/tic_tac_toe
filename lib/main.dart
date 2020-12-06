import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Game(),
    );
  }
}

class Game extends StatefulWidget {
  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
  bool isRed = true; //True == red, False == green
  bool endGame = false;
  List<int> status = <int>[0, 0, 0, 0, 0, 0, 0, 0, 0];

  Color getColor(int index) {
    if (status[index] == 0)
      return Colors.white;
    else if (status[index] == -1)
      return Colors.red;
    else
      return Colors.green;
  }

  void partialResetLine(int indexLine) {
    //Reset every Container color except val ones
    for (int i = 0; i < status.length; i++) {
      if (i != indexLine * 3 + 0 && i != indexLine * 3 + 1 && i != indexLine * 3 + 2) {
        status[i] = 0;
      }
    }
  }

  void partialResetColumn(int indexColumn) {
    for (int i = 0; i < status.length; i++) {
      if (i != indexColumn + 0 && i != indexColumn + 3 && i != indexColumn + 6) {
        status[i] = 0;
      }
    }
  }

  void resetMainDiagonal() {
    for (int i = 0; i < status.length; i++) {
      if (i != 0 && i != 4 && i != 8) {
        status[i] = 0;
      }
    }
  }

  void resetSecondDiagonal() {
    for (int i = 0; i < status.length; i++) {
      if (i != 2 && i != 4 && i != 6) {
        status[i] = 0;
      }
    }
  }

  void resetAll() {
    for (int i = 0; i < status.length; i++) {
      status[i] = 0;
    }
    isRed = true;
    endGame = false;
  }

  void checkEnd() {
    //Check every line
    for (int i = 0; i < 3; i++) {
      if (status[i * 3] == status[i * 3 + 1] && status[i * 3 + 1] == status[i * 3 + 2]) {
        if (status[i * 3] == -1 || status[i * 3] == 1) {
          partialResetLine(i);
          endGame = true;
          return;
        }
      }
    }
    //Check every column
    for (int i = 0; i < 3; i++) {
      if (status[i + 0] == status[i + 3] && status[i + 3] == status[i + 6]) {
        if (status[i] == -1 || status[i] == 1) {
          partialResetColumn(i);
          endGame = true;
          return;
        }
      }
    }
    //Check every diagonal
    if (status[0] == status[4] && status[4] == status[8]) {
      if (status[0] == -1 || status[0] == 1) {
        resetMainDiagonal();
        endGame = true;
        return;
      }
    }
    if (status[2] == status[4] && status[4] == status[6]) {
      if (status[2] == -1 || status[2] == 1) {
        resetSecondDiagonal();
        endGame = true;
        return;
      }
    }
    //Check draw
    if (!status.contains(0)) {
      endGame = true;
      return;
    }
    endGame = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'tic-tac-toe',
            style: TextStyle(color: Colors.black),
          ),
        ),
        backgroundColor: Colors.yellow,
      ),
      body: Column(
        children: <Widget>[
          GridView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: 9,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
            ),
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: () {
                  setState(() {
                    if (status[index] == 0) {
                      isRed ? status[index] = -1 : status[index] = 1;
                      isRed = !isRed;
                    }
                    checkEnd();
                  });
                },
                child: AnimatedContainer(
                  decoration: BoxDecoration(
                    color: getColor(index),
                    border: const Border(
                      bottom: BorderSide(color: Colors.black),
                      left: BorderSide(color: Colors.black),
                    ),
                  ),
                  duration: const Duration(milliseconds: 500),
                ),
              );
            },
          ),
          Visibility(
            visible: endGame,
            child: RaisedButton(
              onPressed: () {
                setState(() {
                  resetAll();
                });
              },
              child: const Text('Play again!'),
            ),
          )
        ],
      ),
    );
  }
}
