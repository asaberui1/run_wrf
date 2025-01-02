import netCDF4 as nc
import argparse
import os
import numpy as np
from datetime import date, timedelta

def update_soil_moisture_data(year, start_month, end_month, max_domain):
    def is_leap_year(year):
        return (year % 4 == 0 and year % 100 != 0) or year % 400 == 0

    def get_days_in_month(year, month):
        days_in_month = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
        if is_leap_year(year) and month == 2:
            return 29
        return days_in_month[month - 1]

    domain_config = {
        1: {"res": "36km", "nx": 129, "ny": 199},
        2: {"res": "12km", "nx": 204, "ny": 204},
    }

    for month in range(start_month, end_month + 1):
        num_days = get_days_in_month(year, month)
        for dd in range(1, num_days + 1):
            for domain_number in range(1, max_domain + 1):
                config = domain_config.get(domain_number)
                if config is None:
                    raise ValueError(f"Invalid domain number: {domain_number}")

                res, nx, ny = config["res"], config["nx"], config["ny"]

                prev_date = date(year, month, dd) - timedelta(days=1)
                sm_path = f"/data8/hty/reproject_gdal/{prev_date.year}/sm_{res}_{prev_date.strftime('%Y%m%d')}19.nc"
                wrf_path = f"./{str(month).zfill(2)}_{str(dd).zfill(2)}/wrfinput_d{str(domain_number).zfill(2)}"

                if not os.path.exists(sm_path) or not os.path.exists(wrf_path):
                    print(f"File not found: {sm_path} or {wrf_path}")
                    continue

                with nc.Dataset(wrf_path, mode='r+') as wrf, nc.Dataset(sm_path) as sm:
                    land_mask = wrf['LANDMASK'][0, :, :]
                    soil_moisture = sm['Band1'][:, :]
                    wrf['SMOIS'][0, 0, :, :] = np.where((land_mask == 1) & (soil_moisture > 0), soil_moisture, wrf['SMOIS'][0, 0, :, :])

                print(f"Successfully updated soil moisture for {str(month).zfill(2)}_{str(dd).zfill(2)}, domain {str(domain_number).zfill(2)}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--year", type=int, help="Specify the year")
    parser.add_argument("--month", type=str, help="Specify the month range or single month in the format 'MM' or 'MM:MM'")
    parser.add_argument("--max-domain", type=int, help="Specify the max domain")

    args = parser.parse_args()

    if args.year is None or args.month is None or args.max_domain is None:
        print("Please provide the correct format for year (--year), month range or single month (--month), and max domain (--max-domain).")
        print("Example: python xxx.py --year=2019 --month=03(:10) --max-domain=2")
        print("This script is written to change soil moisture in China domain!")
    else:
        year = args.year
        start_month, end_month = map(int, args.month.split(":")) if ":" in args.month else (int(args.month), int(args.month))
        max_domain = args.max_domain

        update_soil_moisture_data(year, start_month, end_month, max_domain)
