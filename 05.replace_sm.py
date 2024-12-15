import netCDF4 as nc
import argparse

def update_soil_moisture_data(year, start_month, end_month, max_domain):
    def get_sm_path(year, month, day, domain_number):
        if domain_number == 1:
            res = "36km"
        elif domain_number == 2:
            res = "12km"
        else:
            print("Invalid domain number!")
            
        if day == 1:
            if month == 3:
                ld = 28
            elif month == 8:
                ld = 31
            else:
                ld = 30
            return f"/data8/hty/reproject_gdal/{year}/sm_{res}_{year}{str(month-1).zfill(2)}{str(ld).zfill(2)}19.nc"
        else:
            return f"/data8/hty/reproject_gdal/{year}/sm_{res}_{year}{str(month).zfill(2)}{str(day-1).zfill(2)}19.nc"

    for month in range(start_month, end_month + 1):
        for dd in range(1, 32 if month in [3, 5, 7, 8, 10] else 31):
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
    parser.add_argument("--month", type=str, help="Specify the month range in the format 'MM:MM'")
    parser.add_argument("--max-domain", type=int, help="Specify the max domain")

    args = parser.parse_args()

    if args.year is None or args.month is None or len(args.month) != 5 or args.month[2] != ":" or args.max_domain is None:
        print("Please provide the correct format for year (--year), month range (--month), and max domain (--max-domain).")
        print("Example: python xxx.py --year=2019 --month=03:10 --max-domain=2")
    else:
        year = args.year
        start_month, end_month = map(int, args.month.split(":"))
        max_domain = args.max_domain

        update_soil_moisture_data(year, start_month, end_month, max_domain)
