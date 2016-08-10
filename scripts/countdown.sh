#!/bin/bash

SECONDS=$1
echo "Sleeping for $SECONDS seconds..."
for (( i = 0; i < $SECONDS; i++ )); do
  SECONDS_LEFT=$(( $SECONDS - $i ))
  printf "\r               \r"
  echo -n "Time left: $SECONDS_LEFT seconds"
  [[ $SECONDS_LEFT -gt 0 ]] && sleep 1
done
printf "\r                                   \r"
echo "OK!"
