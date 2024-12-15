#!/bin/bash
#PBS -N 04.wrf-fnl-2022
#PBS -o wrf.04.o
#PBS -e wrf.04.e
#PBS -l walltime=100:00:00
#PBS -l nodes=1:ppn=8

#cd $PBS_O_WORKDIR

year=2016
#for mm in 02
#for mm in 04 06 09 11
#for mm in 01 03 05 07 08 10 12
for mm in 11
do
#for day in 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28
for day in 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30
#for day in 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31

do
  cp wrf.job.template wrf.job.1
  sed -i "s/MM/${mm}/g" wrf.job.1 
  sed -i "s/DD/${day}/g" wrf.job.1 
  sed -i "s/YY/${year}/g" wrf.job.1 
  mv wrf.job.1 ${mm}_${day}/wrf.job
  cp wrf.sh ${mm}_${day}/wrf.sh
done
done
