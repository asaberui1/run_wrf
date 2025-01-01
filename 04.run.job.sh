#!/bin/bash
# Usage: bash script.sh --month=01(:12) --year=xxxx

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

# Loop through the specified months
for (( mm=10#$start_month; mm<=10#$end_month; mm++ ))
do
    month=$(printf "%02d" $mm)  # Format month with leading zero
    for day in {01..31}
    do
        if [ -d "${month}_${day}" ]; then
            # Copy and modify the wrf.job.template
            cp wrf.job.template wrf.job.1
            sed -i "s/MM/${month}/g" wrf.job.1 
            sed -i "s/DD/${day}/g" wrf.job.1 
            sed -i "s/YY/${year}/g" wrf.job.1 
            mv wrf.job.1 "${month}_${day}/wrf.job"

            # Copy the wrf.sh file to the directory
            cp wrf.sh "${month}_${day}/wrf.sh"
        fi
    done
done
