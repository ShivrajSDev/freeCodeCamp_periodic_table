#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

SEARCH_FOR_ELEMENT() {
  # if no argument was provided when running script
  if [[ -z $1 ]]
  then
    # notify user to provide an argument and exit
    echo "Please provide an element as an argument."
  else
    # if argument is a number
    if [[ $1 =~ ^[0-9]+$ ]]
    then
      # check for existing record based on atomic number
      ELEMENT_ATOMIC_NUMBER_ID=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$1;")
    else
      # check for existing record based on symbol or otherwise name
      ELEMENT_ATOMIC_NUMBER_ID=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$1';")
      if [[ -z $ELEMENT_ATOMIC_NUMBER_ID ]]
      then
        ELEMENT_ATOMIC_NUMBER_ID=$($PSQL "SELECT atomic_number FROM elements WHERE name='$1';")
      fi   
    fi

    # if no record was found
    if [[ -z $ELEMENT_ATOMIC_NUMBER_ID ]]
    then
      # notify user and exit
      echo "I could not find that element in the database."
    else
      # retrieve and display element info
      DISPLAY_ELEMENT_INFO $ELEMENT_ATOMIC_NUMBER_ID
    fi
  fi
}

DISPLAY_ELEMENT_INFO() {
  ELEMENT_SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$1;")
  ELEMENT_NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number=$1;")
  ELEMENT_ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$1;")
  ELEMENT_MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$1;")
  ELEMENT_BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$1;")
  ELEMENT_TYPE_ID=$($PSQL "SELECT type_id FROM properties WHERE atomic_number=$1;")
  ELEMENT_TYPE=$($PSQL "SELECT type FROM types WHERE type_id=$ELEMENT_TYPE_ID;")

  echo -e "\nThe element with atomic number $1 is $ELEMENT_NAME ($ELEMENT_SYMBOL). It's a $ELEMENT_TYPE, with a mass of $ELEMENT_ATOMIC_MASS amu. $ELEMENT_NAME has a melting point of $ELEMENT_MELTING_POINT celsius and a boiling point of $ELEMENT_BOILING_POINT celsius."
}

SEARCH_FOR_ELEMENT $1