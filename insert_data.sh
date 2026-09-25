#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE TABLE games, teams")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != "year" ]]
 then
  # get team id
  WINNER_ID=$($PSQL "select team_id from teams where name='$WINNER'")
  OPPONENT_ID=$($PSQL "select team_id from teams where name='$OPPONENT'")
  #if not found
  if [[ -z $WINNER_ID || -z $OPPONENT_ID ]]
  then
    #insert name
    INSERT_WINNER=$($PSQL "insert into teams (name) values ('$WINNER')")
    INSERT_OPPONENT=$($PSQL "insert into teams (name) values ('$OPPONENT')")
    if [[ $INSERT_WINNER == "INSERT 0 1" ]]
    then 
      echo Inserted into names, $WINNER
    elif [[ $INSERT_OPPONENET == "INSERT 0 1" ]]
    then
      echo Inserted into names, $OPPONENT
    fi

    #get new team_id
    WINNER_ID=$($PSQL "select team_id from teams where name='$WINNER'")
    OPPONENT_ID=$($PSQL "select team_id from teams where name='$OPPONENT'")
  fi

  # insert into games
  INSERT_GAMES=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
  if [[ $INSERT_GAME == "INSERT 0 1" ]]
  then 
    echo Inserted into games, $YEAR $ROUND $WINNER_ID $OPPONENT_ID $WINNER_GOALS $OPPONENT_GOALS
  fi
fi
done  
