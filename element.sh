#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ $1 ]]
then
  if [[ $1 =~ ^[0-9]+$ ]] ;
  then
    OUTPUT=$($PSQL "SELECT elements.atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements FULL JOIN properties ON elements.atomic_number = properties.atomic_number FULL JOIN types ON properties.type_id = types.type_id WHERE elements.atomic_number = '$1'")
  else
    OUTPUT=$($PSQL "SELECT elements.atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements FULL JOIN properties ON elements.atomic_number = properties.atomic_number FULL JOIN types ON properties.type_id = types.type_id WHERE symbol = '$1' OR name = '$1'")
  fi


  if [[ -z $OUTPUT ]]
  then
  echo "I could not find that element in the database."
  else
  
  echo "$OUTPUT" | while IFS="|" read NUMBER NAME SYMBOL TYPE MASS MELTING BOILING

do echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
done

fi

else
  echo -e "Please provide an element as an argument."
fi

