import 'dart:io';

void main() {
  List<String> board = List.generate(
      9,
      (_) =>
          ' '); // Create a list to represent the tic-tac-toe board, initialized with empty spaces
  bool isPlayer1Turn = true; // Variable to keep track of player's turn
  int moves = 0; // Variable to count the number of moves made

  print('Welcome to Tic-Tac-Toe!\n'); // Print a welcome message
  printBoard(board); // Call a function to print the current state of the board

  while (true) {
    print(
        '\n${isPlayer1Turn ? "Player 1" : "Player 2"}, enter your move (1-9): '); // Prompt the current player to enter their move

    String? input = stdin.readLineSync(); // Read the input from the player

    if (input == null) {
      print('Invalid input. Please try again.');
      continue;
    }

    try {
      int move = int.parse(input); // Convert the input to an integer

      if (move < 1 || move > 9 || board[move - 1] != ' ') {
        // Check if the move is invalid
        print('Invalid move. Try again.');
        continue;
      }

      board[move - 1] = isPlayer1Turn
          ? 'X'
          : 'O'; // Update the board with the current player's move
      moves++;
      printBoard(board);

      if (checkWin(board)) {
        // Check if there is a winner
        print('${isPlayer1Turn ? "Player 1" : "Player 2"} wins!');
        break;
      } else if (moves == 9) {
        // Check if it's a draw
        print("It's a draw!");
        break;
      }

      isPlayer1Turn = !isPlayer1Turn; // Switch turns between players
    } catch (e) {
      print('Invalid input. Please enter a number (1-9).');
    }
  }
}

void printBoard(List<String> board) {
  // Function to print the current state of the board
  print('');
  print(
      '${board[0]} | ${board[1]} | ${board[2]}'); // Print the first row of the board
  print('---------');
  print(
      '${board[3]} | ${board[4]} | ${board[5]}'); // Print the second row of the board
  print('---------');
  print(
      '${board[6]} | ${board[7]} | ${board[8]}'); // Print the third row of the board
  print('');
}

bool checkWin(List<String> board) {
  // Function to check if there is a winner
  List<List<int>> winConditions = [
    [0, 1, 2], // top row
    [3, 4, 5], // middle row
    [6, 7, 8], // bottom row
    [0, 3, 6], // left column
    [1, 4, 7], // middle column
    [2, 5, 8], // right column
    [0, 4, 8], // left diagonal
    [2, 4, 6], // right diagonal
  ];

  for (var condition in winConditions) {
    if (board[condition[0]] != ' ' &&
        board[condition[0]] == board[condition[1]] &&
        board[condition[0]] == board[condition[2]]) {
      return true;
    }
  }

  return false;
}
