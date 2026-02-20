# 📊 Education Indicators and Future Life Expectancy

## 1. Problem Statement
Life expectancy is a slow-moving but critical indicator of societal well-being.  
This project investigates whether **education-related indicators**—such as enrollment rates and education expenditure—are associated with **future changes in life expectancy**.

The central question is:

> *Given a country’s education indicators and current life expectancy at year t, can we meaningfully explain or predict life expectancy five years later?*

Rather than focusing only on model accuracy, the project emphasizes **data integration, temporal reasoning, and honest interpretation**.

---

## 2. Data Sources
The analysis uses multiple publicly available datasets containing:

- Life expectancy (both sexes)
- Primary, secondary, and tertiary education enrollment
- Education expenditure (percentage of GDP and total expenditure)

Each dataset was originally provided as a separate CSV file with **different country coverage, year ranges, and reporting standards**, requiring careful preprocessing.

---

## 3. Data Preparation & Cleaning (Python / pandas)
Each dataset was cleaned individually using pandas:

- Standardized column names
- Converted year and value columns to numeric types
- Removed irrelevant or constant columns
- Explicitly handled missing values and inconsistencies
- Normalized country names where possible

The goal at this stage was to ensure that each dataset could be reliably joined on a `(Country, Year)` basis.

---

## 4. Data Integration & Feature Engineering (SQLite / SQL)
Cleaned datasets were loaded into an SQLite database to ensure **reproducibility and transparency** of data integration.

Using SQL:
- Multiple datasets were joined using `(Country, Year)` as composite keys
- A **strict panel dataset** was constructed, retaining only country–year observations with complete feature availability
- A **future target variable** was engineered by aligning life expectancy at year *t* with life expectancy at year *t + 5*

This resulted in a modeling-ready dataset where:
- Inputs represent conditions at time *t*
- The target represents an outcome observed in the future

---

## 5. Exploratory Data Analysis (EDA)
Exploratory analysis was conducted **only on the strict panel dataset** to maintain consistency between descriptive analysis and modeling.

Key EDA steps included:
- Visualizing life expectancy trends over time for countries with complete data
- Examining relationships between education indicators and life expectancy
- Identifying data availability constraints across countries and years

### EDA Observations
- Life expectancy generally shows a steady upward trend over time
- Education indicators are positively associated with life expectancy
- Data coverage limitations significantly affect which countries can be analyzed jointly

EDA was used to **validate the modeling approach**, not to overclaim causal relationships.

---

## 6. Predictive Modeling (Baseline)
A baseline supervised learning model was built to predict **life expectancy at year t + 5**.

### Modeling Approach
- Features: education indicators + current life expectancy at year *t*
- Target: life expectancy at year *t + 5*
- Time-based train/test split (training on earlier years, testing on later years)
- Ridge Regression used as a transparent, interpretable baseline model
- Features standardized prior to modeling

### Evaluation
Model performance was evaluated using **Mean Absolute Error (MAE)** on future (held-out) years to avoid temporal leakage.

---

## 7. Model Interpretation & Findings
Inspection of model coefficients revealed that:

- **Current life expectancy** is by far the strongest predictor of future life expectancy
- Education indicators contribute **marginally** once baseline life expectancy is accounted for
- This suggests that education effects are largely embedded in existing health conditions rather than driving short-term changes over a five-year horizon

These results highlight the **inertia of life expectancy** and the difficulty of short-term forecasting using structural indicators alone.

---

## 8. Key Takeaways
- Building a clean, temporally consistent dataset is often more challenging—and more important—than model selection
- Strong baseline predictors can dominate more complex socioeconomic variables
- Honest modeling reveals limitations of data and problem scope rather than masking them
- Time-aware validation is essential for any forecasting task

---

## 9. Project Status
This project represents a **completed end-to-end data science workflow**:
- Data cleaning
- Data integration
- Exploratory analysis
- Baseline predictive modeling
- Interpretation and documentation

Future extensions (e.g. alternative targets, feature engineering, or non-linear models) can be added as independent iterations without altering the core pipeline.

---

## 10. Technologies Used
- Python (pandas, matplotlib, scikit-learn)
- SQLite (SQL)
- Jupyter Notebook



This project investigated whether education indicators help predict life expectancy five years into the future. Using a time-aware baseline regression model, the results show that while education variables are associated with life expectancy levels, their incremental predictive contribution over a short five-year horizon is limited once current life expectancy is accounted for.

These findings suggest that life expectancy exhibits strong temporal persistence, and that structural factors such as education are likely reflected in existing health conditions rather than driving substantial short-term changes.
