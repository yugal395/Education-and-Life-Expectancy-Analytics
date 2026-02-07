# 📊 Education Indicators and Future Life Expectancy

## Overview
This project investigates whether education-related indicators are associated with changes in life expectancy over time.  
The focus is on building a **clean, reproducible country–year panel dataset** by integrating multiple education and health datasets, followed by exploratory analysis and preparation for future predictive modeling.

The project emphasizes **data preparation, integration, and temporal reasoning**, with machine learning planned as a later extension.

---

## Problem Statement
Can education indicators observed at a given point in time help explain or predict improvements in life expectancy in the future?

To answer this, the project constructs a dataset that links:
- education enrollment and expenditure at year *t*
- life expectancy outcomes at later years

This requires careful handling of missing data, inconsistent coverage, and time-based alignment across datasets.

---

## Data Sources
The project uses publicly available datasets containing:
- Life expectancy (both sexes)
- Primary, secondary, and tertiary education enrollment
- Education expenditure (as % of GDP and total expenditure)

Each dataset is provided separately and differs in country and year coverage.

---

## Data Preparation & Integration

### 1. Data Cleaning (Python / pandas)
Each dataset was cleaned individually using pandas:
- Standardized column names
- Converted year and value columns to numeric types
- Removed irrelevant or constant columns
- Explicitly handled missing or malformed values

Cleaned datasets were saved for reproducibility.

---

### 2. Data Integration (SQLite / SQL)
Cleaned datasets were loaded into an SQLite database.

SQL was used to:
- Integrate multiple datasets using `(Country, Year)` as keys
- Construct a **strict panel dataset** containing only country–year observations with complete feature availability
- Engineer a **future target variable** by linking life expectancy at year *t* to life expectancy at year *t + 5*

This separation ensures that data construction is transparent, reproducible, and independent of downstream analysis.

---

## Exploratory Data Analysis (EDA)
Exploratory analysis was conducted on the final panel dataset used for modeling.

Key EDA steps included:
- Visualizing life expectancy trends over time for countries with complete data
- Examining relationships between education indicators and life expectancy using scatter plots
- Identifying data availability limitations across countries and years

The analysis confirms:
- a general upward trend in life expectancy over time
- a positive association between education indicators and life expectancy

These findings motivate the subsequent use of education variables for predictive modeling.

---

## Project Structure
├── data/
│ ├── raw/ # Original datasets
│ ├── cleaned/ # Cleaned CSV files
│ └── education_life.db # SQLite database
├── sql/
│ ├── build_panel.sql
│ └── build_model_data.sql
├── notebooks/
│ ├── data_cleaning.ipynb
├── output/
│ └──Cleaned datasets 
└── README.md



---

## Current Status
At this stage, the project provides:
- A clean, integrated country–year panel dataset
- A time-shifted life expectancy target suitable for supervised learning
- Exploratory insights validating the modeling approach

---

## Next Steps
Planned extensions include:
- Training baseline machine learning models (e.g. Ridge Regression, Random Forest)
- Evaluating predictive performance using time-based train/test splits
- Interpreting feature contributions to future life expectancy changes

---

## Technologies Used
- Python (pandas, matplotlib)
- SQLite (SQL)
- Jupyter Notebook

---

## Notes
Exploratory analysis was intentionally conducted on the same strict dataset used for modeling to ensure consistency between descriptive insights and predictive results.
