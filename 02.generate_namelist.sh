#!/bin/bash
#PBS -N 02.wrf-fnl-2022
#PBS -o wrf.02.o
#PBS -e wrf.02.e
#PBS -l walltime=24:00:00
#PBS -l nodes=1:ppn=1

#cd $PBS_O_WORKDIR

year=2016
#for month in 02
#for month in 04 06 09 11
#for month in 01 03 05 07 08 10 12
for month in 11
do
#for day in 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28
for day in 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30
#for day in 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31

do
  ds=$( date -d "${year}/${month}/${day} -6hours" +%d )
  ms=$( date -d "${year}/${month}/${day} -6hours" +%m )
  de=$( date -d "${year}/${month}/${day} +1day" +%d )
  me=$( date -d "${year}/${month}/${day} +1day" +%m )
  ye=$( date -d "${year}/${month}/${day} +1day" +%Y )
  echo "${ms}/${ds}" "${me}/${de}"
  cp namelist.template namelist.input 
  sed -i "s/YYYY/${year}/g" namelist.input 
  sed -i "s/YYYE/${ye}/g" namelist.input 
  sed -i "s/DS/${ds}/g" namelist.input 
  sed -i "s/MS/${ms}/g" namelist.input 
  sed -i "s/DE/${de}/g" namelist.input 
  sed -i "s/ME/${me}/g" namelist.input  
  mv namelist.input ${month}_${day}/namelist.input
done 
done
