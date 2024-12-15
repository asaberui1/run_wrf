#!/bin/bash
#PBS -N 01.wrf-fnl-2022
#PBS -o wrf.01.o
#PBS -e wrf.01.e
#PBS -l walltime=24:00:00
#PBS -l nodes=1:ppn=1

#cd $PBS_O_WORKDIR
#for mm in 02
#for mm in 04 06 09 11
#for mm in 01 03 05 07 08 10 12
for mm in 11
do
#for d in 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28
for d in 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30
#for d in 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31
do
  ./wrf_setup -d ${mm}_${d}
done
done
