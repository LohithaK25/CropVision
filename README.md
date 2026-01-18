# CropVision - Crop Yield Analysis Project

## Overview
CropVision is a Big Data Analytics project that predicts crop yield across Indian states using **Hadoop, Hive, PySpark, and Power BI**. The project integrates multiple datasets: crop yield, soil nutrients, and historical weather, to generate insights and predictive models for crop production.

## Features
- Data ingestion and preprocessing in **HDFS** and **Hive**.
- Combining multiple datasets into a **master dataset** for analysis.
- Data visualization and interactive dashboards in **Power BI**.
- Machine Learning models in **PySpark MLlib**: Linear Regression, Random Forest, Gradient Boosted Trees, Decision Tree.
- Model evaluation using **RMSE** and **R²** metrics on both original and log-transformed yield.

## Folder Structure
- `data/` - Sample CSV datasets.
- `hive_scripts/` - SQL scripts for Hive table creation and data export.
- `spark_code/` - PySpark notebooks for feature engineering and model building.
- `powerbi_queries/` - DAX queries for dashboards.
- `export/` - CSV outputs (optional, large files excluded).
- `docs/` - Project report in PDF.
- `README.md` - Project overview and instructions.

## Setup Instructions

### 1. Install Prerequisites
- **Java 11**, **Hadoop**, and **Apache Spark**.
- Python dependencies:
```bash
pip install findspark pyspark pandas numpy matplotlib seaborn openpyxl
````

### 2. Upload Datasets to Hadoop HDFS

Start Hadoop services:

```bash
start-dfs.sh
start-yarn.sh
hdfs dfsadmin -safemode leave
jps
```

Create directories in HDFS for datasets:

```bash
hdfs dfs -mkdir -p /user/hadoop/cropdata/crop
hdfs dfs -mkdir -p /user/hadoop/cropdata/soil
hdfs dfs -mkdir -p /user/hadoop/cropdata/weather
```

Move CSV files into HDFS:

```bash
hdfs dfs -mv /user/hadoop/cropdata/crop_yield.csv /user/hadoop/cropdata/crop/
hdfs dfs -mv /user/hadoop/cropdata/state_soil_data.csv /user/hadoop/cropdata/soil/
hdfs dfs -mv /user/hadoop/cropdata/state_weather_data_1997_2020.csv /user/hadoop/cropdata/weather/
```

### 3. Export Final Dataset from Hive

After creating and joining tables in Hive, combine part files and add a header:

```bash
cat /home/hadoop/export_crop_data/* > /home/hadoop/crop_model_data.csv

echo "crop,year,season,state,area,production,fertilizer,pesticide,yield,nitrogen,phosphorus,potassium,ph,avg_temp_c,total_rainfall_mm,avg_humidity_percent" \
| cat - /home/hadoop/crop_model_data.csv > /home/hadoop/crop_model_data_with_header.csv

# Verify CSV
head /home/hadoop/crop_model_data_with_header.csv
```

### 4. Run PySpark Modeling

Open the notebook:

```bash
spark_code/crop_yield_prediction.ipynb
```

Follow steps for preprocessing, feature engineering, and model training.

### 5. Visualizations in Power BI

* Import the final CSV (`crop_model_data_with_header.csv`) into Power BI.
* Use the DAX queries from `powerbi_queries/crop_analysis_dax.txt` to create dashboards and KPIs.
