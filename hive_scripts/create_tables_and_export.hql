-- Crop Yield Table
CREATE EXTERNAL TABLE IF NOT EXISTS crop_yield (
    crop STRING,
    year INT,
    season STRING,
    state STRING,
    area DOUBLE,
    production DOUBLE,
    fertilizer DOUBLE,
    pesticide DOUBLE,
    yield DOUBLE
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
LOCATION '/user/hadoop/cropdata/crop'
TBLPROPERTIES ("skip.header.line.count"="1");

-- Soil Data Table
CREATE EXTERNAL TABLE IF NOT EXISTS soil_data (
    state STRING,
    nitrogen DOUBLE,
    phosphorus DOUBLE,
    potassium DOUBLE,
    ph DOUBLE
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
LOCATION '/user/hadoop/cropdata/soil'
TBLPROPERTIES ("skip.header.line.count"="1");

-- Weather Data Table
CREATE EXTERNAL TABLE IF NOT EXISTS weather_data (
    state STRING,
    year INT,
    avg_temp_c DOUBLE,
    total_rainfall_mm DOUBLE,
    avg_humidity_percent DOUBLE
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
LOCATION '/user/hadoop/cropdata/weather'
TBLPROPERTIES ("skip.header.line.count"="1");

-- Final Combined Table
CREATE TABLE IF NOT EXISTS crop_model_data AS
SELECT
    c.crop,
    c.year,
    c.season,
    c.state,
    c.area,
    c.production,
    c.fertilizer,
    c.pesticide,
    c.yield,
    s.nitrogen,
    s.phosphorus,
    s.potassium,
    s.ph,
    w.avg_temp_c,
    w.total_rainfall_mm,
    w.avg_humidity_percent
FROM crop_yield c
LEFT JOIN soil_data s ON c.state = s.state
LEFT JOIN weather_data w ON c.state = w.state AND c.year = w.year;

-- Export Final Table to Local System
INSERT OVERWRITE LOCAL DIRECTORY '/home/hadoop/export_crop_data'
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
SELECT * FROM crop_model_data;