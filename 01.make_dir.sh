#!/bin/bash
# Usage: bash script.sh --month=01:12 --year=xxxx

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

# Function to determine the number of days in a month
days_in_month() {
    month=$1
    year=$2
    cal "$month" "$year" | awk 'NF {DAYS = $NF}; END {print DAYS}'
}

# Iterate over the specified months
for ((m=10#$start_month; m<=10#$end_month; m++))
do
    month=$(printf "%02d" $m)
    days=$(days_in_month "$month" "$year")
    for ((d=1; d<=$days; d++))
    do
        day=$(printf "%02d" $d)
        bash wrf_setup -d "${month}_${day}"
    done
done
