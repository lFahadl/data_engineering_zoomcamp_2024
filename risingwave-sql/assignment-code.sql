
-- Q1
CREATE MATERIALIZED VIEW trip_time_stats AS
SELECT
    pickup_zone.zone AS pickup_zone,
    dropoff_zone.zone AS dropoff_zone,
    AVG(tpep_dropoff_datetime - tpep_pickup_datetime) AS avg_trip_time,
    MIN(tpep_dropoff_datetime - tpep_pickup_datetime) AS min_trip_time,
    MAX(tpep_dropoff_datetime - tpep_pickup_datetime) AS max_trip_time
FROM
    trip_data
JOIN taxi_zone AS 
    pickup_zone ON trip_data.pulocationid = pickup_zone.location_id
JOIN taxi_zone AS dropoff_zone 
    ON trip_data.dolocationid = dropoff_zone.location_id
GROUP BY
    pickup_zone.zone, dropoff_zone.zone;


SELECT pickup_zone, dropoff_zone, avg_trip_time, count_trip_time
FROM trip_time_stats
ORDER BY avg_trip_time DESC
LIMIT 1;


-- Q2
CREATE MATERIALIZED VIEW trip_time_stats_COUNT AS
SELECT
    pickup_zone.zone AS pickup_zone,
    dropoff_zone.zone AS dropoff_zone,
    COUNT(tpep_dropoff_datetime - tpep_pickup_datetime) AS count_trip_time,
    AVG(tpep_dropoff_datetime - tpep_pickup_datetime) AS avg_trip_time,
    MIN(tpep_dropoff_datetime - tpep_pickup_datetime) AS min_trip_time,
    MAX(tpep_dropoff_datetime - tpep_pickup_datetime) AS max_trip_time
FROM
    trip_data
JOIN taxi_zone AS 
    pickup_zone ON trip_data.pulocationid = pickup_zone.location_id
JOIN taxi_zone AS dropoff_zone 
    ON trip_data.dolocationid = dropoff_zone.location_id
GROUP BY
    pickup_zone.zone, dropoff_zone.zone;

SELECT pickup_zone, dropoff_zone, avg_trip_time, count_trip_time
FROM trip_time_stats
ORDER BY avg_trip_time DESC
LIMIT 1;



-- Q3
WITH t AS (
    SELECT MAX(tpep_pickup_datetime) AS latest_pickup_time
    FROM trip_data
)
SELECT
    taxi_zone.Zone AS taxi_zone,
    COUNT(*) AS pickup_count
FROM t, trip_data
JOIN taxi_zone 
    ON trip_data.PULocationID = taxi_zone.location_id
WHERE
    trip_data.tpep_pickup_datetime <= t.latest_pickup_time
    AND trip_data.tpep_pickup_datetime >= t.latest_pickup_time - interval '17' hour
GROUP BY taxi_zone.Zone
ORDER BY pickup_count DESC
LIMIT 3;
