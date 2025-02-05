#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z "$1" ]]
then
  echo "Please provide an element as an argument."
  exit 0

else
   if [[ "$1" =~ ^[0-9]+$ ]]
   then
     ELEMENT_INFO=$($PSQL "
     SELECT e.atomic_number, e.symbol, e.name, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius, t.type
     FROM elements e JOIN properties p ON e.atomic_number = p.atomic_number
     JOIN types t ON t.type_id = p.type_id
     WHERE e.atomic_number='$1'")
   else
     ELEMENT_INFO=$($PSQL "
     SELECT e.atomic_number, e.symbol, e.name, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius, t.type
     FROM elements e JOIN properties p ON e.atomic_number = p.atomic_number
     JOIN types t ON t.type_id = p.type_id
     WHERE e.symbol='$1' OR e.name='$1'")
   fi
  
 if [[ -z "$ELEMENT_INFO" ]]
 then
  echo "I could not find that element in the database."
  exit 0 
 else
  echo "$ELEMENT_INFO" | sed 's/|/ /g' | while read ATOMIC_NUMBER SYMBOL NAME ATOMIC_MASS MELTING_POINT BOILING_POINT TYPE
  do
  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  done
  exit 0
 fi
fi
