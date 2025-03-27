import csv
import mysql.connector

# Config
DB_CONFIG = {
    'host': 'localhost',
    'user': 'root',
    'password': 'rootpassword',
    'database': 'divvy_tripdata_2024_database'
}

TABLE_NAME = 'divvy_tripdata_2024_full_year'
OUTPUT_FILE = r'C:\data\divvy_tripdata_2024_full_year.csv'

# Connect using a streaming cursor
conn = mysql.connector.connect(**DB_CONFIG)
cursor = conn.cursor(buffered=False)  # Do NOT buffer to keep memory usage low

# Query the table
cursor.execute(f"SELECT * FROM {TABLE_NAME}")

# Open CSV file for writing
with open(OUTPUT_FILE, 'w', newline='', encoding='utf-8') as f:
    writer = csv.writer(f)
    
    # Write headers
    writer.writerow([i[0] for i in cursor.description])
    
    # Stream and write each row
    for row in cursor:
        writer.writerow(row)

cursor.close()
conn.close()

print(f"Exported table '{TABLE_NAME}' to {OUTPUT_FILE}")
