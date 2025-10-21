# Bee Movies DBT - Advanced SQL

[![SQL](https://img.shields.io/badge/Built%20With-SQL-blue)](https://en.wikipedia.org/wiki/SQL) 
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-336791?logo=postgresql&logoColor=white)](https://www.postgresql.org/)

---

## DBT Overview

SQL Movie Database Analysis 🎬
This project is a deep dive into a comprehensive movie database, utilizing a wide range of SQL techniques to answer complex business questions. The analysis moves from basic data cleaning and exploration to advanced window functions, multi-level aggregations, and performance analysis.

This repository contains the complete SQL script with 25+ queries used to analyze the dataset.

---

## Analysis Overview

| Analysis                        | Description                                      |
| ------------------------------- | ------------------------------------------------ |
|🧹 1. Data Cleaning & Validation| Checking for Empty Data / Data Type Conversion   |
|📊 2. Movie & Genre Analysis    | Top Movies / Genre Popularity / Rating Categories / Complex Filtering  |
|💰 3. Financial & Performance Analysis| Top N per Group (CTEs applied) / Top Production Houses     |
|🏆 4. Actor & Director Ranking | Top N Actresses/Actors / Top Director per Genre  |
|📈 5. Time-Series & Statistical Analysis | Average Inter-Movie Duration / Comprehensive Director Report  |

---

## Database setup

📝 Set-up your DBT
  - You can run this script to load the data on the MySQL / PostgreSQL workbench
  - And start with the querying project on the database
[Get Data!](https://raw.githubusercontent.com/ndlryan/AdvanceSQL-Analysis-for-Beemovies/refs/heads/main/import-data.sql)

✨ Know your DBT
  - This file contains the ERD diagram to help you understand the relationship between those tables
  - Study the ERD closely so that you get an initial understanding of the relations and how data from different tables can be joined.
[Get ERD!](https://github.com/ndlryan/AdvanceSQL-Analysis-for-Beemovies/raw/main/ERD.xlsx)

---

## 💡 Key SQL Concepts Demonstrated
This project heavily utilizes modern SQL features to solve complex, multi-step problems.
- Common Table Expressions (CTEs)
- Window Functions (Analytics): ROW_NUMBER(), RANK(), and DENSE_RANK(), PARTITION BY, LAG(), running totals and moving averages.
- Advanced Aggregation
- Data Cleaning Functions
- Complex Joins

---

## Author

**Ryan**  
[GitHub Profile](https://github.com/ndlryan)
