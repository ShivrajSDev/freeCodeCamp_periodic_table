#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table -t --no-align -c"

SEARCH_FOR_ELEMENT() {
  if [[ -z $1 ]]
  then
    echo "Please provide an element as an argument."
  else
    if [[ $1 =~ ^[0-9]+$ ]]
    then
      ELEMENT_ATOMIC_NUMBER_ID=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$1;")
    else
      ELEMENT_ATOMIC_NUMBER_ID=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$1';")
      if [[ -z $ELEMENT_ATOMIC_NUMBER_ID ]]
      then
        ELEMENT_ATOMIC_NUMBER_ID=$($PSQL "SELECT atomic_number FROM elements WHERE name='$1';")
      fi   
    fi

    if [[ -z $ELEMENT_ATOMIC_NUMBER_ID ]]
    then
      echo "I could not find that element in the database."
    else
      echo "Element found."
    fi
  fi
}

SEARCH_FOR_ELEMENT $1