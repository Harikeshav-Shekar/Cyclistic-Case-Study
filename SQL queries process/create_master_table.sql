CREATE TABLE divvy_tripdata_2024_full_year (
	ride_id VARCHAR(50) PRIMARY KEY,
    rideable_type VARCHAR(50),
    started_at INT,
    start_station_name VARCHAR(100),
    start_station_id VARCHAR(50),
    ended_at INT,
    end_station_name VARCHAR(100),
    end_station_id VARCHAR(50),
    start_lat DECIMAL(18, 15),
    start_lng DECIMAL(18, 15),
    end_lat DECIMAL(18, 15),
    end_lng DECIMAL(18, 15),
    member_casual VARCHAR(20)
);

INSERT IGNORE INTO divvy_tripdata_2024_full_year 
SELECT * FROM divvy_tripdata_2024_12;