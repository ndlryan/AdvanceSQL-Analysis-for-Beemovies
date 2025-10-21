================================================================================
Project: Bee Movies Database Analysis
Author: [Ryan]
Date: 2025-10-21
================================================================================
  

================================================================================
                                   SEGMENT 1
================================================================================  

-- Q1: Find the total number of rows in each table of the schema?
  
SELECT 
schemaname AS SchemaName,
relname AS TableName,
n_live_tup AS RowCount
FROM pg_stat_user_tables
WHERE shcemaname = 'public'
ORDER BY relname;

-- -----------------------------------------------------------------------------

-- Q2: Which columns in the movie table have null values?

SELECT 
COUNT(CASE WHEN id IS NULL THEN 1 END) AS id_null_count,
COUNT(CASE WHEN title IS NULL THEN 1 END) AS title_null_count,
COUNT(CASE WHEN year IS NULL THEN 1 END) AS year_null_count,
COUNT(CASE WHEN date_published IS NULL THEN 1 END) AS date_published_null_count,
COUNT(CASE WHEN duration IS NULL THEN 1 END) AS duration_null_count,
COUNT(CASE WHEN country IS NULL THEN 1 END) AS country_null_count,
COUNT(CASE WHEN worlwide_gross_income IS NULL THEN 1 END) AS income_null_count,
COUNT(CASE WHEN languages IS NULL THEN 1 END) AS languages_null_count,
COUNT(CASE WHEN production_company IS NULL THEN 1 END) AS company_null_count
FROM movie;

-- -----------------------------------------------------------------------------

-- Q3.1: Find the total number of movies released each year?

SELECT 
EXTRACT(YEAR FROM date_published) AS year,
COUNT(id) AS movie_release
FROM movie
GROUP BY EXTRACT(YEAR FROM date_published)
ORDER BY EXTRACT(YEAR FROM date_published);

-- Q3.2: How does the trend look month wise?

SELECT 
EXTRACT(MONTH FROM date_published) AS month,
COUNT(id) AS movie_count
FROM movie
GROUP BY EXTRACT(MONTH FROM date_published)
ORDER BY EXTRACT(MONTH FROM date_published);

-- -----------------------------------------------------------------------------

-- Q4: How many movies were produced in the USA or India in the year 2019?

SELECT
EXTRACT(YEAR FROM date_published) AS year,
country,
COUNT(id) AS movie_count
FROM movie
WHERE
EXTRACT(YEAR FROM date_published) = 2019
AND country in ('USA', 'India')
GROUP BY
EXTRACT(YEAR FROM date_published), country;

-- -----------------------------------------------------------------------------

-- Q5: Find the unique list of the genres present in the data set?

SELECT DISTINCT genre
FROM genre;

-- -----------------------------------------------------------------------------

-- Q6: Which genre had the highest number of movies produced overall?

SELECT 
genre,
COUNT(id) AS movie_count
FROM movie
JOIN genre ON movie_id = id
GROUP BY genre
ORDER BY movie_count DESC
LIMIT 1;

-- -----------------------------------------------------------------------------

-- Q7: How many movies belong to only one genre?

WITH one_genre_movie AS(
SELECT
title,
COUNT(genre) AS genre_count
FROM movie
JOIN genre ON movie_id = id
GROUP BY id, title
)
  
SELECT COUNT(title) AS movie_count
FROM one_genre_movie
WHERE genre_count = 1

-- -----------------------------------------------------------------------------

-- Q8: What is the average duration of movies in each genre?
  
SELECT
genre,
ROUND(AVG(duration), 2) AS avg_duration
FROM movie 
JOIN genre ON id = movie_id
GROUP BY genre
ORDER BY avg_duration DESC;

-- -----------------------------------------------------------------------------

-- Q9: What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced?

WITH movie_by_genre AS(
SELECT
genre,
COUNT(id) AS movie_count,
RANK() OVER(ORDER BY COUNT(id) DESC) AS genre_rank
FROM movie
JOIN genre ON movie_id = id
GROUP BY genre
)
  
SELECT genre,
movie_count,
genre_rank
FROM movie_by_genre
WHERE genre = 'Thriller';

================================================================================
                                   SEGMENT 2
================================================================================  

-- Q10: Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
  
SELECT 
max(avg_rating) AS max_avg_rate,
min(avg_rating) AS min_avg_rate,
max(total_votes) AS max_vote,
min(total_votes) AS min_vote,
max(median_rating) AS max_med_rate,
min(median_rating) AS min_med_rate
FROM ratings;

-- -----------------------------------------------------------------------------

-- Q11: Which are the top 10 movies based on average rating?

SELECT
title,
avg_rating,
DENSE_RANK() OVER(ORDER BY avg_rating DESC) AS movie_rank
FROM movie
JOIN ratings ON id = movie_id
ORDER by avg_rating DESC
LIMIT 10;

-- -----------------------------------------------------------------------------

-- Q12: Summarise the ratings table based on the movie counts by median ratings.

SELECT 
median_rating,
COUNT(movie_id) AS movie_count
FROM ratings
GROUP BY median_rating
ORDER BY median_rating;

-- -----------------------------------------------------------------------------

-- Q13: Which production house has produced the most number of hit movies (average rating > 8)

WITH top_company AS(
SELECT
production_company,
COUNT(id) AS movie_count,
RANK() OVER(ORDER BY COUNT(id) DESC) AS company_rank
FROM movie
JOIN ratings ON id = movie_id
WHERE avg_rating > 8 
AND production_company IS NOT NULL
GROUP BY production_company
)
  
SELECT 
production_company,
movie_count,
company_rank
FROM top_company
WHERE company_rank = 1;

-- -----------------------------------------------------------------------------

-- Q14: How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?

SELECT 
g.genre AS genre,
COUNT(g.movie_id) AS movie_count
FROM movie AS m
JOIN genre AS g ON m.id = g.movie_id
JOIN ratings AS r ON g.movie_id = r.movie_id
WHERE r.total_votes > 1000
AND country = 'USA'
AND EXTRACT(YEAR FROM m.date_published) = 2017
AND EXTRACT(MONTH FROM m.date_published) = 3
GROUP BY genre
ORDER BY movie_count DESC;

-- -----------------------------------------------------------------------------

-- Q15: Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?

SELECT 
m.title AS title,
r.avg_rating AS avg_rating,
r.median_rating AS med_rating,
STRING_AGG (g.genre, ',') AS genre
FROM movie AS m
JOIN genre AS g ON m.id = g.movie_id
JOIN ratings AS r ON g.movie_id = r.movie_id
WHERE m.title LIKE 'The%'
AND r.avg_rating > 8
GROUP BY title, avg_rating, med_rating;

-- -----------------------------------------------------------------------------

-- Q16: Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?

SELECT 
COUNT(DISTINCT m.id) AS movie_count
FROM movie AS m
JOIN genre AS g ON m.id = g.movie_id
JOIN ratings AS r ON g.movie_id = r.movie_id
WHERE r.median_rating = 8
AND m.date_published BETWEEN '2018-04-01' AND '2019-04-01';

-- -----------------------------------------------------------------------------

-- Q17: Do German movies get more votes than Italian movies? 

SELECT
CASE WHEN SUM(CASE WHEN m.country = 'Germany' THEN r.total_votes ELSE 0 END) >
SUM(CASE WHEN m.country = 'Italy' THEN r.total_votes ELSE 0 END)
THEN 'Yes'
ELSE 'No'
END AS German_Has_More_Vote
FROM movie AS m
JOIN ratings AS r ON m.id = r.movie_id
WHERE country IN ('Germany', 'Italy');

================================================================================
                                   SEGMENT 3
================================================================================  

-- Q18: Which columns in the names table have null values??

SELECT
COUNT(1)
FROM names
WHERE id IS NULL
AND name IS NULL
AND height IS NULL
AND date_of_birth IS NULL
AND known_for_movies IS NULL;

-- -----------------------------------------------------------------------------

-- Q19: Who are the top three directors in the top three genres whose movies have an average rating > 8

WITH TOP_GENRE AS(
SELECT 
g.genre,
COUNT(m.id) AS movie_count
FROM movie AS m
JOIN genre AS g ON m.id = g.movie_id
JOIN ratings AS r ON g.movie_id = r.movie_id
WHERE avg_rating > 8
GROUP BY g.genre
ORDER BY movie_count DESC
LIMIT 3
)

SELECT
n.name AS director_name,
COUNT(m.id) as movie_count
FROM movie AS m
JOIN director_mapping AS dm ON m.id = dm.movie_id
JOIN names AS n ON dm.name_id = n.id
JOIN genre AS g ON m.id = g.movie_id
JOIN ratings AS r ON m.id = r.movie_id
WHERE avg_rating > 8
AND g.genre IN (SELECT genre FROM TOP_GENRE)
GROUP BY n.name
ORDER BY movie_count DESC
LIMIT 3;

-- -----------------------------------------------------------------------------

-- Q20: Who are the top two actors whose movies have a median rating >= 8?

SELECT 
n.name AS actor_name,
COUNT(m.id) AS movie_count
FROM movie AS m
JOIN role_mapping AS rm ON m.id = rm.movie_id
JOIN names AS n ON rm.name_id = n.id
JOIN ratings AS r ON m.id = r.movie_id
WHERE rm.category = 'actor'
AND r.median_rating >= 8
GROUP BY n.name
ORDER BY movie_count DESC
LIMIT 2;

-- -----------------------------------------------------------------------------

-- Q21: Which are the top three production houses based on the number of votes received by their movies?

SELECT 
production_company,
SUM(total_votes) AS vote_count,
ROW_NUMBER() OVER (ORDER BY SUM(total_votes) DESC) AS prod_comp_rank
FROM movie
JOIN ratings ON movie_id = id
GROUP BY production_company;

-- -----------------------------------------------------------------------------

-- Q22: Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?

SELECT
n.name AS actor_name,
COUNT(m.id) AS movie_count,
SUM(r.total_votes) AS total_votes,
ROUND(SUM(r.avg_rating * r.total_votes) / SUM(r.total_votes),2) AS weighted_average_rating
FROM
movie AS m
JOIN role_mapping AS rm ON m.id = rm.movie_id
JOIN names AS n ON rm.name_id = n.id
JOIN ratings AS r ON m.id = r.movie_id
WHERE
m.country = 'India'
AND rm.category = 'actor'
GROUP BY n.name
HAVING COUNT(m.id) >= 5
ORDER BY
weighted_average_rating DESC,
total_votes DESC
LIMIT 1;

-- -----------------------------------------------------------------------------

-- Q23: Find out the top five actresses in Hindi movies released in India based on their average ratings

SELECT
n.name AS actor_name,
COUNT(m.id) AS movie_count,
SUM(r.total_votes) AS total_votes,
ROUND(SUM(r.avg_rating * r.total_votes) / SUM(r.total_votes),2) AS weighted_average_rating
FROM
movie AS m
JOIN role_mapping AS rm ON m.id = rm.movie_id
JOIN names AS n ON rm.name_id = n.id
JOIN ratings AS r ON m.id = r.movie_id
WHERE
m.country = 'India'
AND rm.category = 'actress'
AND m.languages LIKE '%Hindi%'
GROUP BY n.name
HAVING COUNT(m.id) >= 3
ORDER BY
weighted_average_rating DESC,
total_votes DESC
LIMIT 5;

-- -----------------------------------------------------------------------------

-- Q24: Select thriller movies as per avg rating and classify them in the following category: 
-- Rating > 8: Superhit movies
-- Rating between 7 and 8: Hit movies
-- Rating between 5 and 7: One-time-watch movies
-- Rating < 5: Flop movies

SELECT 
CASE 
WHEN avg_rating > 8 THEN 'Superhit movies'
WHEN avg_rating >= 7 THEN 'Hit movies'
WHEN avg_rating >= 5 THEN 'One-time-watch movies'
ELSE 'Flop movies' 
END AS movie_category,
COUNT(1) AS count
FROM genre AS g
JOIN ratings AS r ON r.movie_id = g.movie_id
WHERE g.genre = 'Thriller'
GROUP BY movie_category;

================================================================================
                                   SEGMENT 4
================================================================================  

-- Q25.1: What is the genre-wise running total and moving average of the average movie duration?

With avg_duration_cnt AS(
SELECT 
g.genre AS genre,
ROUND(AVG(duration),2) AS avg_duration
FROM movie AS m
JOIN genre AS g ON m.id = g.movie_id
GROUP BY g.genre
ORDER BY avg_duration DESC
)

SELECT
genre,
avg_duration,
ROUND(SUM(avg_duration) OVER(ORDER BY genre
ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW),2) AS running_total_duration,
ROUND(AVG(avg_duration) OVER(ORDER BY genre
ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING),2) AS moving_avg_duration
FROM avg_duration_cnt
ORDER BY genre;

-- Q25.2: What is the genre-wise running total and moving average of the average movie duration?

WITH TOP_GENRE AS(
SELECT 
g.genre,
COUNT(m.id) AS movie_count
FROM movie AS m
JOIN genre AS g ON m.id = g.movie_id
JOIN ratings AS r ON g.movie_id = r.movie_id
WHERE avg_rating > 8
GROUP BY g.genre
ORDER BY movie_count DESC
LIMIT 3
),
  
MOVIE_RANK AS(
SELECT
m.title,
m.year,
g.genre,
r.avg_rating,
ROW_NUMBER() OVER (PARTITION BY m.year  ORDER BY r.avg_rating DESC ) AS movie_rank
FROM
movie AS m
JOIN genre AS g ON m.id = g.movie_id
JOIN ratings AS r ON m.id = r.movie_id
WHERE g.genre IN (SELECT genre FROM TOP_GENRE)
)
  
SELECT *
FROM MOVIE_RANK
WHERE movie_rank <= 5
ORDER BY year DESC, movie_rank;

-- -----------------------------------------------------------------------------

-- Q26.1: Which are the five highest-grossing movies of each year that belong to the top three genres? 
        (Note: The top 3 genres would have the most number of movies.)

WITH TOP_GENRES AS(
SELECT 
g.genre,
COUNT(m.id) AS movie_count
FROM movie AS m
JOIN genre AS g ON m.id = g.movie_id
GROUP BY g.genre
ORDER BY COUNT(m.id) DESC
LIMIT 3
),

TOP_MOVIES AS(
SELECT 
g.genre,
m.year,
title,	
CAST(REPLACE(REPLACE(m.worlwide_gross_income, '$', ''), 'INR ', '') AS BIGINT)AS world_grossing,
ROW_NUMBER () OVER (PARTITION BY m.year ORDER BY CAST( REPLACE(REPLACE(m.worlwide_gross_income, '$', ''), 'INR','') AS BIGINT) DESC) AS movie_rank
FROM movie AS m
JOIN genre AS g ON m.id = g.movie_id
WHERE m.worlwide_gross_income IS NOT NULL
AND g.genre IN (SELECT genre FROM TOP_GENRES)
GROUP BY m.id, m.title, m.year, g.genre, m.worlwide_gross_income
)

SELECT 
genre,
year,
title,
world_grossing
FROM TOP_MOVIES
WHERE movie_rank <= 5
ORDER BY year DESC, movie_rank;

-- Q26.2: find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.

WITH TOP_GENRES AS(
SELECT 
g.genre,
COUNT(m.id) AS movie_count
FROM movie AS m
JOIN genre AS g ON m.id = g.movie_id
GROUP BY g.genre
ORDER BY COUNT(m.id) DESC
LIMIT 3
),

TOP_MOVIES AS(
SELECT 
m.production_company,
m.languages,
m.id,
ROW_NUMBER () OVER (PARTITION BY m.year ORDER BY CAST(REPLACE(REPLACE(m.worlwide_gross_income, '$', ''), 
'INR ','') AS BIGINT)DESC) AS movie_rank
FROM movie AS m
JOIN genre AS g ON m.id = g.movie_id
WHERE m.worlwide_gross_income IS NOT NULL
AND g.genre IN (SELECT genre FROM TOP_GENRES)
GROUP BY m.id, m.title, m.year, g.genre, m.worlwide_gross_income, m.production_company, m.languages
),

MULTILINGUAL_HIT AS(
SELECT production_company
FROM TOP_MOVIES
WHERE movie_rank <=5
AND production_company IS NOT NULL
AND languages LIKE '%,%'
)

SELECT 
production_company,
COUNT(production_company) as hit_count
FROM MULTILINGUAL_HIT
GROUP BY production_company
ORDER BY hit_count DESC
LIMIT 2;

-- -----------------------------------------------------------------------------

-- Q27: Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?

SELECT 
m.production_company AS prod_comp,
COUNT(m.id) AS movie_count,
ROW_NUMBER() OVER(ORDER BY COUNT(m.id) DESC) AS prod_comp_rank
FROM movie AS m 
JOIN ratings AS r ON m.id = r.movie_id
WHERE r.median_rating >= 8 
AND m.languages LIKE '%,%'
AND m.production_company IS NOT NULL
GROUP BY m.production_company
ORDER BY movie_count DESC, prod_comp_rank ASC
LIMIT 2;

-- -----------------------------------------------------------------------------

-- Q28: Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre

SELECT
n.name AS actress_name,
SUM(r.total_votes) as total_votes,
COUNT(m.id) AS movie_count,
ROUND(SUM(r.avg_rating * r.total_votes) / SUM(r.total_votes), 2) AS actress_rating,
ROW_NUMBER() OVER(ORDER BY COUNT(m.id) DESC) AS actress_rank
FROM movie AS m
JOIN ratings AS r ON m.id = r.movie_id
JOIN role_mapping AS rm ON m.id = rm.movie_id
JOIN names AS n ON rm.name_id = n.id
JOIN genre AS g ON m.id = g.movie_id
WHERE r.avg_rating > 8
AND g.genre = 'Drama'
AND rm.category = 'actress'
GROUP BY n.name
ORDER BY actress_rank
LIMIT 3;

-- -----------------------------------------------------------------------------

-- Q29: Get the following details for top 9 directors (based on number of movies)

WITH DIRECTOR_STATS AS(
SELECT
n.id AS director_id,
n.name AS director_name,
COUNT(m.id) AS movie_count,
ROUND(SUM(r.avg_rating * r.total_votes) / SUM(r.total_votes), 2) AS avg_movie_rating,
SUM(r.total_votes) AS total_votes,
MIN(avg_rating) AS min_rating,
MAX(avg_rating) AS max_rating,
SUM(m.duration) AS total_movie_duration,
ROW_NUMBER() OVER(ORDER BY COUNT(m.id) DESC) as director_rank
FROM movie AS m 
JOIN ratings AS r ON m.id = r.movie_id
JOIN director_mapping AS dm ON m.id = dm.movie_id
JOIN names AS n ON dm.name_id = n.id
GROUP BY n.id, n.name
),

AVG_INTER AS(
SELECT
director_id,
ROUND(AVG(gap_days),2) AS avg_inter_movies_days
FROM(
SELECT 
dm.name_id as director_id,
m.date_published,
LAG(m.date_published, 1) OVER (PARTITION BY dm.name_id ORDER BY m.date_published) AS last_released_date,
(m.date_published - LAG(m.date_published, 1) OVER (PARTITION BY dm.name_id ORDER BY m.date_published)) AS gap_days
FROM movie AS m
JOIN director_mapping AS dm ON m.id = dm.movie_id
WHERE m.date_published IS NOT NULL
) AS MovieGaps
WHERE gap_days IS NOT NULL
GROUP BY director_id
)

SELECT
DS.director_id,
DS.director_name,
DS.movie_count AS number_of_movies,
AI.avg_inter_movies_days,
DS.avg_movie_rating,
DS.total_votes,
DS.min_rating,
DS.max_rating,
DS.total_movie_duration
FROM DIRECTOR_STATS as DS
LEFT JOIN AVG_INTER as AI ON DS.director_id = AI.director_id
ORDER BY DS.director_rank
LIMIT 9;

-- -----------------------------------------------------------------------------
