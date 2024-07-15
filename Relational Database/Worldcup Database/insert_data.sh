#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $WINNER != "winner" ]]
  then
    #get team_id
    WINNER_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    OPPONENT_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

    #if winner not found
    if [[ -z $WINNER_TEAM_ID ]]
    then
      #insert team_name
      INSERT_TEAM_NAME=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")

      #get winner_team_id
      WINNER_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
      if [[ $INSERT_TEAM_NAME == "INSERT 0 1" ]]
      then
        echo Inserted into name, $WINNER
      fi
    fi

    #if opponent not found
    if [[ -z $OPPONENT_TEAM_ID ]]
    then
      #insert team_name
      INSERT_TEAM_NAME=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      if [[ $INSERT_TEAM_NAME == "INSERT 0 1" ]]
      then
        echo Inserted into name, $OPPONENT
      fi

      #get opponent_team_id
      OPPONENT_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    fi

    #insert in games
    INSERT_GAME=$($PSQL "INSERT INTO games(year, round, winner_goals, opponent_goals, winner_id, opponent_id) VALUES($YEAR, '$ROUND', $WINNER_GOALS, $OPPONENT_GOALS, '$WINNER_TEAM_ID', '$OPPONENT_TEAM_ID')")
    if [[ $INSERT_GAME == "INSERT 0 1" ]]
    then
      echo Inserted into game, $YEAR $ROUND $WINNER $OPPONENT $WINNER_GOALS $OPPONENT_GOALS
    fi
  fi


done