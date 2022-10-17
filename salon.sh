#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"
echo -e "\n~~~~~ MY SALON ~~~~~"
echo -e "\nWelcome to My Salon, how can I help you?\n"
MAIN_MENU () {
  if [[ $1 ]]
  then
  echo -e "\n$1"
  fi
  SERVICES_RESULT=$($PSQL "SELECT * FROM services")
  echo "$SERVICES_RESULT" | sed 's/ |/)/'
  read SERVICE_ID_SELECTED
}

MAIN_MENU

SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id='$SERVICE_ID_SELECTED'")
if [[ -z $SERVICE_NAME ]]
then
MAIN_MENU "I could not find that service. What would you like today?"
fi
echo -e "\nWhat's your phone number?"
read CUSTOMER_PHONE
CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
if [[ -z $CUSTOMER_NAME ]]
then
echo -e "\nI don't have a record for that phone number, what's your name?"
read CUSTOMER_NAME
#agregar cliente a customers
CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(phone, name) VALUES ('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
fi
echo -e "\nWhat time would you like your $SERVICE_NAME, $CUSTOMER_NAME?"
read SERVICE_TIME
# obtener customer id
CUSTOMER_ID_SELECTED=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
#agregar turno a appoinments
APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(service_id, customer_id, time) VALUES ($SERVICE_ID_SELECTED, $CUSTOMER_ID_SELECTED, '$SERVICE_TIME')")
echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."



# I have put you down for a cut at 10:30, Fabio.

