#!/bin/bash
#for mm in 02
#for mm in 04 06 09 11
#for mm in 01 03 05 07 08 10 12
mkdir -p ./wrfout

for mm in 11
do
#for day in 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28
#for day in 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30
for day in 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31
do
  cd ./${mm}_${day}/
  
  cnt=0

  if ls -1qA | grep -q "^rsl."; then

    for file in rsl.*; do
      last_line=$(tail -n 1 "$file" | tr '[:upper:]' '[:lower:]')
      if [[ $last_line == *success* ]]; then
        continue
      else
        echo "Something went wrong when running wrf.exe in ${mm}_${day}. Please check the error logs."
        ((cnt++))
        mv file ../error_log/${mm}_${day}_${file}
      fi
    done
      
    if cnt==0 && ls -1qA | grep -q "^wrfout"; then
      echo "Successfully running wrf.exe in ${mm}_${day}!"
      cd ../wrfout/
      ln -sf ../${mm}_${day}/wrfout* .
      #rm rsl.*
    fi
  fi

  cd ../
done
done
