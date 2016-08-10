#!/bin/bash

echo "Sleeping for 20 seconds..."
for (( i = 0; i < 20; i++ )); do
  SECONDS_LEFT=$(( 20 - $i ))
  printf "\r               \r"
  echo -n "Time left: $SECONDS_LEFT seconds"
  [[ $SECONDS_LEFT -gt 0 ]] && sleep 1
done
printf "\r                                   \r"
echo "OK!"
