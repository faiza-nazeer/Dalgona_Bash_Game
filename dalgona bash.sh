#!/bin/bash

# Colors for output
RED='\033[1;31m'  # Bright Red
GREEN='\033[1;32m' # Bright Green
YELLOW='\033[1;33m' # Bright Yellow
BLUE='\033[1;34m'   # Bright Blue
CYAN='\033[1;36m'   # Bright Cyan
NC='\033[0m'       # No Color

shapes=("Circle" "Star" "Umbrella" "Triangle")
LEADERBOARD_FILE="leaderboard.txt"

# Function to display ASCII shapes
display_shape() {
    case "$1" in
        "Circle")
            echo -e "${YELLOW}   *****    \n  *     *   \n *       *  \n  *     *   \n   *****    ${NC}"
            ;;
        "Star")
            echo -e "${BLUE}    *     \n   ***    \n  *****   \n   ***    \n    *     ${NC}"
            ;;
        "Umbrella")
            echo -e "${CYAN}  *****   \n *******  \n   ***    \n    |     \n    |     ${NC}"
            ;;
        "Triangle")
            echo -e "${GREEN}    *    \n   ***   \n  *****  \n ******* \n*********${NC}"
            ;;
    esac
}

# Function to get user input and validate against the random shape
guess_shape() {
    local player="$1"
    local chosen_shape="$2"
    local attempts=3
    local time_limit="$3"

    while [ $attempts -gt 0 ]; do
        echo -e "${YELLOW} $player, enter the shape name:${NC}"
        read -t "$time_limit" user_guess

        if [ -z "$user_guess" ]; then
            echo -e "${RED}⏳ Time's up!${NC}"
            echo
            return 1
        elif [ "$user_guess" == "$chosen_shape" ]; then
            echo -e "${GREEN}✅ Correct!${NC}"
            echo
            return 0
        else
            attempts=$((attempts - 1))
            echo -e "${RED}❌ Wrong guess! Attempts left: $attempts${NC}"
            echo
        fi
    done
    echo -e "${RED}💀 Game Over! The correct answer was: $chosen_shape${NC}"
    echo
    return 1
}

# Function to update leaderboard
update_leaderboard() {
    case $1 in
        "single")
            echo "Single Player: $2 - Score: $3" >> "$LEADERBOARD_FILE"
            ;;
        "pvp")
            echo "Player vs Player: $2 - $4, $3 - $5" >> "$LEADERBOARD_FILE"
            ;;
        "pvc")
            echo "Player vs Computer: $2 - $3, Computer - $4" >> "$LEADERBOARD_FILE"
            ;;
    esac
    echo -e "${CYAN}🏆 Leaderboard updated!${NC}"
}

# Function to play game based on mode
dalgona_game() {
    read -p " Enter Player 1 name: " player1
    echo -e "${BLUE} Select Difficulty: \n1) Hard \n2) Medium \n3) Easy${NC}"
    read -p "Enter choice: " difficulty
    case $difficulty in
        1) time_limit=5;;
        2) time_limit=10;;
        3) time_limit=15;;
        *) echo -e "${RED}⚠️ Invalid choice! Defaulting to Medium (10 sec).${NC}"; time_limit=10;;
    esac
    echo
    echo -e "${BLUE} Select Mode: \n1) Single Player \n2) Player vs Player \n3) Player vs Computer${NC}"
    read -p "Enter choice: " mode
    echo
    player1_score=0
    player2_score=0
    computer_score=0
    
    if [ "$mode" -eq 2 ]; then
        read -p " Enter Player 2 name: " player2
    fi
    
    for round in {1..3}; do
        echo
        echo -e "${CYAN}🔥 Round $round of 3 🔥${NC}"
        chosen_shape=${shapes[$((RANDOM % 4))]}
        display_shape "$chosen_shape"
    
        case $mode in
            1)  # Single Player
                if guess_shape "$player1" "$chosen_shape" "$time_limit"; then
                    ((player1_score++))
                fi
                ;;
            2)  # Player vs Player
                echo -e "${YELLOW} $player1's turn!${NC}"
                if guess_shape "$player1" "$chosen_shape" "$time_limit"; then
                    ((player1_score++))
                fi
                echo -e "${YELLOW} $player2's turn!${NC}"
                if guess_shape "$player2" "$chosen_shape" "$time_limit"; then
                    ((player2_score++))
                fi
                ;;
            3)  # Player vs Computer
                echo -e "${YELLOW} $player1's turn!${NC}"
                if guess_shape "$player1" "$chosen_shape" "$time_limit"; then
                    ((player1_score++))
                fi
                sleep 2
                comp_guess=${shapes[$((RANDOM % 4))]}
                echo -e "${YELLOW}Computer guessed: $comp_guess${NC}"
                if [ "$comp_guess" == "$chosen_shape" ]; then
                    ((computer_score++))
                fi
                ;;
            *)
                echo -e "${RED} Invalid mode! Exiting...${NC}"
                exit 1
                ;;
        esac
    done

    # Display final results
    case $mode in
        1)
            echo -e "${CYAN}🏆 Final Score: $player1 - $player1_score${NC}"
            update_leaderboard "single" "$player1" "$player1_score"
            ;;
        2)
            echo -e "${CYAN}🏆 Final Score: $player1 - $player1_score | $player2 - $player2_score${NC}"
            update_leaderboard "pvp" "$player1" "$player2" "$player1_score" "$player2_score"
            ;;
        3)
            echo -e "${CYAN}🏆 Final Score: $player1 - $player1_score | Computer - $computer_score${NC}"
            update_leaderboard "pvc" "$player1" "$player1_score" "$computer_score"
            ;;
    esac

    read -p " Do you want to play again? (y/n): " play_again
    if [[ "$play_again" == "y" || "$play_again" == "Y" ]]; then
        dalgona_game
    else
        echo -e "${BLUE} Thanks for playing! Goodbye!${NC}"
        echo
        exit 0
    fi
}

echo -e "${CYAN}🏆 Welcome to the Dalgona Challenge! 🏆${NC}"
echo
dalgona_game

