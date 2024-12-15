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

# Determine if the year is a leap year
is_leap_year() {
    year=$1
    if (( (year % 400 == 0) || (year % 4 == 0 && year % 100 != 0) )); then
        return 0
    else
        return 1
    fi
}

# Iterate over the specified months
for ((m=start_month; m<=end_month; m++))
do
    month=$(printf "%02d" $m)
    days=$(days_in_month "$month" "$year")
    
    if [ "$m" -eq "$start_month" ] && [ "$m" -eq "$end_month" ]; then
        for ((d=1; d<=$days; d++))
        do
            day=$(printf "%02d" $d)
            ./wrf_setup -d "${month}_${day}"
        done
    elif [ "$m" -eq "$start_month" ]; then
        for ((d=1; d<=$days; d++))
        do
            day=$(printf "%02d" $d)
            ./wrf_setup -d "${month}_${day}"
        done
    elif [ "$m" -eq "$end_month" ]; then
        for ((d=1; d<=$days; d++))
        do
            day=$(printf "%02d" $d)
            ./wrf_setup -d "${month}_${day}"
        done
    else
        for ((d=1; d<=$days; d++))
        do
            day=$(printf "%02d" $d)
            ./wrf_setup -d "${month}_${day}"
        done
    fi
done
