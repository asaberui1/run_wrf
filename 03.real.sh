#!/bin/bash
#PBS -N 03.08.wrf-fnl-2022
#PBS -o wrf.03.o
#PBS -e wrf.03.e
#PBS -l walltime=100:00:00
#PBS -l nodes=1:ppn=8

#cd $PBS_O_WORKDIR

#for month in 03 05 07 08 10 
#for month in 04 06 09 11 
for month in 11
do
for day in 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31
#for day in 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30
#for day in  01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29
do

  cd ./${month}_${day}
  ./real.exe

  if ls -1qA | grep -q "^wrfbdy_d" && ls -1qA | grep -q "^wrfinput_d"; then
    echo "Running real.exe successfully in ${month}_${day}!"
  else
    echo "Something went wrong when runing real.exe in ${month}_${day}. Go check it out, and you may need to re-run script 02 once!"
  fi

  cd ../
done 
done

