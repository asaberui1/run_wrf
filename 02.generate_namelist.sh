#!/bin/bash
# Usage: bash script.sh --month=01(:12) --year=xxxx --path=/directory/to/met_em/

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
        --path=*)
        path="${arg#*=}"
        path_new=$(echo "$path" | sed 's/\//\\\//g')
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

# Check if path argument is provided
if [ -z "$path" ]; then
    echo "Please provide a path using --path=/directory/to/met_em/"
    exit 1
fi

# Iterate over months and days
for (( month=10#$start_month; month<=10#$end_month; month++ ))
do
    m=$(printf "%02d" $month)
    for day in {01..31}
    do
        # Check if the directory exists
        if [ -d "${m}_${day}/" ]; then
            ds=$(date -d "${year}/${m}/${day} -6hours" +%d 2>/dev/null)
            ms=$(date -d "${year}/${m}/${day} -6hours" +%m 2>/dev/null)
            de=$(date -d "${year}/${m}/${day} +1day" +%d 2>/dev/null)
            me=$(date -d "${year}/${m}/${day} +1day" +%m 2>/dev/null)
            ye=$(date -d "${year}/${m}/${day} +1day" +%Y 2>/dev/null)
            
            # Skip invalid dates (e.g., February 30)
            if [ -z "$ds" ] || [ -z "$ms" ] || [ -z "$de" ] || [ -z "$me" ] || [ -z "$ye" ]; then
                continue
            fi
            
            echo "${ms}/${ds}" "${me}/${de}"
            cp namelist.template namelist.input
            sed -i "s/YYYY/${year}/g" namelist.input
            sed -i "s/YYYE/${ye}/g" namelist.input
            sed -i "s/DS/${ds}/g" namelist.input
            sed -i "s/MS/${ms}/g" namelist.input
            sed -i "s/DE/${de}/g" namelist.input
            sed -i "s/ME/${me}/g" namelist.input
            sed -i "s/PATHPATHPATH/${path_new}/g" namelist.input
            mv namelist.input "${m}_${day}/namelist.input"
        fi
    done
done

# Clean up namelist.input if it still exists
if [ -f "./namelist.input" ]; then
    rm ./namelist.input
fi
