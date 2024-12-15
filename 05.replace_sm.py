import netCDF4 as nc
import argparse

def update_soil_moisture_data(year, start_month, end_month, max_domain):
    def is_leap_year(year):
        return (year % 4 == 0 and year % 100 != 0) or year % 400 == 0

    def get_days_in_month(year, month):
        days_in_month = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
        if is_leap_year(year) and month == 2:
            return 29
        return days_in_month[month - 1]

    def get_sm_path(year, month, day, domain_number):
        if domain_number == 1:
            res = "36km"
        elif domain_number == 2:
            res = "12km"
        else:
            print("Invalid domain number!")

        if day == 1:
            if month == 1:
                prev_month = 12
                prev_year = year - 1
            else:
                prev_month = month - 1
                prev_year = year
            ld = get_days_in_month(prev_year, prev_month)
            return f"/data8/hty/reproject_gdal/{year}/sm_{res}_{prev_year}{str(prev_month).zfill(2)}{str(ld).zfill(2)}19.nc"
        else:
            return f"/data8/hty/reproject_gdal/{year}/sm_{res}_{year}{str(month).zfill(2)}{str(day-1).zfill(2)}19.nc"

    for month in range(start_month, end_month + 1):
        num_days = get_days_in_month(year, month)
        for dd in range(1, num_days + 1):
            for domain_number in range(1, max_domain + 1):
                sm_path = get_sm_path(year, month, dd, domain_number)
                wrf_path = f"./{str(month).zfill(2)}_{str(dd).zfill(2)}/wrfinput_d{str(domain_number).zfill(2)}"
                wrf = nc.Dataset(wrf_path, mode='r+')
                sm = nc.Dataset(sm_path)
                if domain_number == 1:
                    nx, ny = 129, 199
                elif domain_number == 2:
                    nx, ny = 204, 204
                else:
                    print("Invalid domain number!")
                    break

                for x in range(nx):
                    for y in range(ny):
                        if wrf['LANDMASK'][0, x, y] == 1 and sm['Band1'][x, y] > 0:
                            wrf['SMOIS'][0, 0, x, y] = sm['Band1'][x, y]
                wrf.close()
                sm.close()
                print(f"Successfully changed surface soil moisture of {str(month).zfill(2)}_{str(dd).zfill(2)} for domain {str(domain_number).zfill(2)}")

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
