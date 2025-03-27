import pandas as pd
import mysql.connector
from mysql.connector import Error
from tqdm import tqdm
import os

# === CONFIGURATION ===
db_config = {
    'host': 'localhost',
    'user': 'root',
    'password': 'rootpassword',
    'database': 'divvy_tripdata_2024_database'
}
base_dir = r"C:\data"
months = [f"{i:02d}" for i in range(9, 13)]

# === CONNECT TO MYSQL ONCE ===
try:
    connection = mysql.connector.connect(**db_config)
    cursor = connection.cursor()

    for month in months:
        file_path = os.path.join(base_dir, f"2024{month}-divvy-tripdata.csv")
        table_name = f"divvy_tripdata_2024_{month}"

        print(f"📂 Processing file: {file_path}")

        # Read CSV with explicit type for ride_id
        df = pd.read_csv(file_path, dtype={'ride_id': str})


        # Extract only the minute part from started_at and ended_at
        def extract_minutes(val):
            try:
                if pd.isna(val):
                    return None
                t = pd.to_datetime(val, errors='coerce')
                if pd.isna(t):
                    parts = str(val).split(':')
                    return int(parts[0]) if len(parts) == 2 else None
                return t.minute
            except:
                return None

        df['started_at'] = df['started_at'].apply(extract_minutes)
        df['ended_at'] = df['ended_at'].apply(extract_minutes)

        # Insert query
        insert_query = f"""
            INSERT IGNORE INTO {table_name} (
                ride_id, rideable_type, started_at, ended_at,
                start_station_name, start_station_id, end_station_name, end_station_id,
                start_lat, start_lng, end_lat, end_lng, member_casual
            )
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
        """

        # Insert rows with progress bar
        for _, row in tqdm(df.iterrows(), total=len(df), desc=f"Inserting into {table_name}"):
            values = tuple(row.get(col, None) if pd.notna(row.get(col, None)) else None for col in [
                'ride_id', 'rideable_type', 'started_at', 'ended_at',
                'start_station_name', 'start_station_id', 'end_station_name', 'end_station_id',
                'start_lat', 'start_lng', 'end_lat', 'end_lng', 'member_casual'
            ])
            cursor.execute(insert_query, values)

        connection.commit()
        print(f"✅ Finished inserting data into {table_name}")

except Error as e:
    print(f"❌ MySQL Error: {e}")

except Exception as ex:
    print(f"❌ General Error: {ex}")

finally:
    if 'cursor' in locals():
        cursor.close()
    if 'connection' in locals() and connection.is_connected():
        connection.close()