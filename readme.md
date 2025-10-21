# Bee Movies DBT - Advanced SQL

[![SQL](https://img.shields.io/badge/Built%20With-SQL-blue)](https://en.wikipedia.org/wiki/SQL) 
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-336791?logo=postgresql&logoColor=white)](https://www.postgresql.org/)

---

## DBT Overview

SQL Movie Database Analysis 🎬

Bee Movies is an Indian film production company which has produced many super-hit movies. They have usually released movies for the Indian audience but for their next project, they are planning to release a movie for the global audience in 2022.

The production company wants to plan their every move analytically based on data and have approached you for help with this new project.

You have to use SQL to analyse the given data and give recommendations to Bee Movies based on the insights

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

### 📝 Set-up your DBT
  - You can run this script to load the data on the MySQL / PostgreSQL workbench
  - And start with the querying project on the database
[Get Data!](https://raw.githubusercontent.com/ndlryan/AdvanceSQL-Analysis-for-Beemovies/refs/heads/main/import-data.sql)

### ✨ Know your DBT
  - This file contains the ERD diagram to help you understand the relationship between those tables
  - Study the ERD closely so that you get an initial understanding of the relations and how data from different tables can be joined.
[Get ERD!](https://github.com/ndlryan/AdvanceSQL-Analysis-for-Beemovies/raw/main/ERD.xlsx)

### 🔎 Analyze Your DBT
  - For your convenience, the entire analytics process has been divided into four segments
  - The questions in each segment with business objectives are written in the script given below.
[Get Question!](https://raw.githubusercontent.com/ndlryan/AdvanceSQL-Analysis-for-Beemovies/refs/heads/main/bee-movies-question.sql)

---

## 💡 Key SQL Concepts Demonstrated

1. Analyzed a movie database using SQL to answer 25+ business questions.

2. Cleaned dirty data (NULLs, non-numeric strings like '$', 'INR ') using REPLACE, CAST, and WHERE IS NOT NULL.

3. Used aggregate functions (COUNT, SUM, AVG) with GROUP BY and HAVING for summaries.

4. Implemented advanced window functions (ROW_NUMBER, RANK, LAG) with PARTITION BY for ranking and time-series analysis.

5. Leveraged CTEs (WITH ... AS) to break down complex, multi-step problems into logical parts.

---

## Author

**Ryan**  
[GitHub Profile](https://github.com/ndlryan)

This project provided extensive hands-on practice in SQL, moving from basic queries to complex analytical techniques. By cleaning data, joining multiple tables, and applying both aggregate and window functions, we successfully extracted meaningful insights about movie performance, genre trends, and key contributors (directors, actors). The experience highlighted the importance of precise data cleaning and the power of CTEs and window functions for tackling sophisticated, multi-layered business questions.
