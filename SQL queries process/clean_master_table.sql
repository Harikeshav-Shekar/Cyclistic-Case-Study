SELECT DISTINCT rideable_type FROM divvy_tripdata_2024_full_year;

SELECT DISTINCT member_casual FROM divvy_tripdata_2024_full_year;

SELECT COUNT(*) FROM divvy_tripdata_2024_full_year WHERE member_casual IS NULL || rideable_type IS NULL;

SET SQL_SAFE_UPDATES = 0;	
UPDATE divvy_tripdata_2024_full_year
SET start_station_name = TRIM(start_station_name);
SET SQL_SAFE_UPDATES = 1;

SET SQL_SAFE_UPDATES = 0;	
UPDATE divvy_tripdata_2024_full_year
SET end_station_name = TRIM(end_station_name);
SET SQL_SAFE_UPDATES = 1;

SET SQL_SAFE_UPDATES = 0;	
UPDATE divvy_tripdata_2024_full_year
SET ride_id = TRIM(ride_id);
SET SQL_SAFE_UPDATES = 1;

ALTER TABLE divvy_tripdata_2024_full_year
DROP COLUMN start_station_id,
DROP COLUMN start_lat,
DROP COLUMN start_lng,
DROP COLUMN end_station_id,
DROP COLUMN end_lat,
DROP COLUMN end_lng;

ALTER TABLE divvy_tripdata_2024_full_year
ADD COLUMN trip_duration INT;

SET SQL_SAFE_UPDATES = 0;	
UPDATE divvy_tripdata_2024_full_year
SET trip_duration = ABS(ended_at - started_at);
SET SQL_SAFE_UPDATES = 1;

ALTER TABLE divvy_tripdata_2024_full_year
DROP COLUMN started_at,
DROP COLUMN ended_at;

SET SQL_SAFE_UPDATES = 0;	
DELETE FROM divvy_tripdata_2024_full_year
WHERE start_station_name IS NULL OR end_station_name IS NULL;
SET SQL_SAFE_UPDATES = 1;

SELECT COUNT(*) FROM divvy_tripdata_2024_full_year;

SELECT * FROM divvy_tripdata_2024_full_year LIMIT 1000;

DROP TABLE divvy_tripdata_2024_12;