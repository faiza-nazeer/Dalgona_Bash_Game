# Dalgona_Bash_Game
a bash programme inspired by Squid game's dalgona game

CODE FUNCTIONALITIES:
The script includes several functions that work together to create an interactive shape-guessing game.

**display_shape()**
This function prints an ASCII representation of a randomly selected shape such as a Circle, Star, Umbrella, or Triangle. It uses color formatting to enhance visualization, making it easier for players to recognize the shapes.

**guess_shape()**
This function allows a player to guess the displayed shape within a specified time limit. The player gets three attempts to guess correctly. If they fail all attempts or run out of time, the correct answer is revealed. Correct guesses are acknowledged, while incorrect ones display the number of remaining attempts.

**Update Leaderboard ()**
This function updates the leaderboard.txt file with the results of the game. It supports different game modes: Single Player (logging the player’s score), Player vs Player (storing scores for both players), and Player vs Computer (recording the player's and computer’s scores).

## Main Game Logic (dalgona_game())
This function controls the entire game flow. It prompts the players for their names, allows them to select a difficulty level that determines the time limit, and lets them choose a game mode (Single Player, Player vs Player, or Player vs Computer). The game consists of three rounds where a shape is displayed, guesses are collected, and scores are calculated. At the end, the function determines the winner, updates the leaderboard, and asks the player if they want to play again.
The script follows a structured process where dalgona_game() calls display_shape() to show a shape, then guess_shape() to collect input, updates scores based on the results, and finally calls update_leaderboard() to save the results. This setup ensures an engaging and competitive experience with interactive elements and a persistent scoring system.


