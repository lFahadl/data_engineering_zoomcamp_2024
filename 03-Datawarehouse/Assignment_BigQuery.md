CREATE OR REPLACE EXTERNAL TABLE `qwiklabs-gcp-03-7afcaae838a8.zoomcamp.nyc-green-taxi-data-external`
OPTIONS (
  format = 'PARQUET',
  uris = ['gs://green_taxi_2022_data/green_taxi_data_2022/green_tripdata_2022-*.parquet']
);


/* 
Write a query to count the distinct number of PULocationIDs for the entire dataset on both the tables.
What is the estimated amount of data that will be read when this query is executed on the External Table and the Table?
*/
SELECT COUNT(DISTINCT(PULocationID)) FROM `zoomcamp.nyc-green-taxi-data`; --6.41MB
SELECT COUNT(DISTINCT(PULocationID)) FROM `zoomcamp.nyc-green-taxi-data-external`; -- 0MB


-- How many records have a fare_amount of 0?
SELECT count(fare_amount)
from `zoomcamp.nyc-green-taxi-data-external`
where fare_amount = 0;
-- 1622


-- Create a partitioned and clustered table from external table
CREATE OR REPLACE TABLE `zoomcamp.nyc-green-taxi-data-external-partitioned-clustered`
PARTITION BY DATE(lpep_pickup_datetime) 
CLUSTER BY PUlocationID AS
SELECT * FROM `zoomcamp.nyc-green-taxi-data-external`;


-- Write a query to retrieve the distinct PULocationID between lpep_pickup_datetime 06/01/2022 and 06/30/2022 (inclusive)
-- Estimate the bytes with materialized table and partitioned table.
SELECT DISTINCT(PULocationID)
FROM `zoomcamp.nyc-green-taxi-data`
WHERE lpep_pickup_datetime BETWEEN '2022-06-01' AND '2022-06-30'; -- 12.82MB


SELECT DISTINCT(PULocationID)
FROM zoomcampnyc-green-taxi-data-external-partitioned-clustered`
WHERE lpep_pickup_datetime BETWEEN '2022-06-01' AND '2022-06-30'; -- 1.12MB


SELECT count(*) FROM `zoomcamp.nyc-green-taxi-data`; -- 0B



