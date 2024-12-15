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

for (( month=start_month; month<=end_month; month++ ))
do
    m=$(printf "%02d" $month)
    for day in {01..31}
    do
        ds=$(date -d "${year}/${m}/${day} -6hours" +%d)
        ms=$(date -d "${year}/${m}/${day} -6hours" +%m)
        de=$(date -d "${year}/${m}/${day} +1day" +%d)
        me=$(date -d "${year}/${m}/${day} +1day" +%m)
        ye=$(date -d "${year}/${m}/${day} +1day" +%Y)
        echo "${ms}/${ds}" "${me}/${de}"
        cp namelist.template namelist.input
        sed -i "s/YYYY/${year}/g" namelist.input
        sed -i "s/YYYE/${ye}/g" namelist.input
        sed -i "s/DS/${ds}/g" namelist.input
        sed -i "s/MS/${ms}/g" namelist.input
        sed -i "s/DE/${de}/g" namelist.input
        sed -i "s/ME/${me}/g" namelist.input
        mv namelist.input ${m}_${day}/namelist.input
    done
done
