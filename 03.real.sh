#!/bin/bash
#PBS -N 03.wrf-real
#PBS -o wrf.03.o
#PBS -e wrf.03.e
#PBS -l walltime=100:00:00
#PBS -l nodes=1:ppn=8

#cd $PBS_O_WORKDIR

# Usage: bash script.sh --month=01(:12) --year=xxxx (--data=xxx)

# Parse command line arguments
for arg in "$@"
do
    case $arg in
        --month=*)
        months="${arg#*=}"
        if [[ $months == *":"* ]]; then
            IFS=":" read -r start_month end_month <<< "$months"
        else
            start_month=$months
            end_month=$months
        fi
        ;;
        --year=*)
        year="${arg#*=}"
        ;;
        --data=*)
        data="${arg#*=}"
        ;;
    esac
done

# Check if month argument is provided
if [ -z "$months" ]; then
    echo "Please provide month(s) using --month=03(:10)"
    exit 1
fi

# Check if year argument is provided
if [ -z "$year" ]; then
    echo "Please provide a year using --year=xxxx"
    exit 1
fi

# Check if data argument is provided
if [ -z "$data" ]; then
    echo "No data provided. A default value of fnl is set."
    data="fnl"
fi

# Loop through the specified month(s)
for (( month=start_month; month<=end_month; month++ ))
do
    m=$(printf "%02d" $month)
    for day in {01..31}
    do
        if [ -d "./${m}_${day}" ]; then
            cd ./${m}_${day}
            ./real.exe

            if ls -1qA | grep -q "^wrfbdy_d" && ls -1qA | grep -q "^wrfinput_d"; then
                echo "Running real.exe successfully in ${m}_${day}!"
            else
                echo "Something went wrong when running real.exe in ${m}_${day}. Go check it out, and you may need to re-run script 02 once!"
                exit 1
            fi

            cd ../
        fi
    done
done
