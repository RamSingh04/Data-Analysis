CREATE DATABASE LEVEL2;

USE LEVEL2;

CREATE TABLE Restaurant (
Restaurant_ID INT PRIMARY KEY NOT NULL,	
Restaurant_Name	VARCHAR(100) NOT NULL,
Country_Code INT NOT NULL,	
City VARCHAR(30) NOT NULL,
Address VARCHAR(150) NOT NULL,	
Locality VARCHAR(90) NOT NULL,	
Locality_Verbose VARCHAR(90) NOT NULL,	
Longitude INT NOT NULL,	
Latitude INT NOT NULL,	
Cuisines VARCHAR(150) NOT NULL,	
Average_Cost_for_two INT NOT NULL,	
Currency VARCHAR(50) NOT NULL,	
Has_Table_booking VARCHAR(15) NOT NULL,	
Has_Online_delivery VARCHAR(15) NOT NULL,	
Is_delivering_now VARCHAR(15) NOT NULL,	
Switch_to_order_menu VARCHAR(15) NOT NULL,	
Price_range INT NOT NULL,	
Aggregate_rating INT NOT NULL,	
Rating_color VARCHAR(15) NOT NULL,	
Rating_text VARCHAR(15) NOT NULL,	
Votes INT NOT NULL
);
Drop TABLE Restaurant;

SHOW GLOBAL VARIABLES LIKE 'local_infile';

SET GLOBAL local_infile = 'ON';

Load data infile "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Restaurant.csv" into table Restaurant
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

Select *  FROM  Restaurant ;


-- Level 2 Task 1
Select *  FROM  Restaurant ;

-- Task: Restaurant Ratings Analyze the distribution of aggregate ratings and determine the most common rating range.

SELECT AGGREGATE_RATING_CATEGORY,NUMBER_OF_RESTAURANT_WITH_EACH_RATING_CATEGORY, ( (NUMBER_OF_RESTAURANT_WITH_EACH_RATING_CATEGORY * 100) / (SELECT COUNT(DISTINCT Restaurant_Name) AS TOTAL_NUMBER_OF_RESTAURANT  FROM  Restaurant )) AS PERCENTAGE_OF_RESTAURANT_IN_EACH_RATING_CATEGORY
 FROM (
Select Aggregate_rating AS AGGREGATE_RATING_CATEGORY, COUNT(Aggregate_rating) AS NUMBER_OF_RESTAURANT_WITH_EACH_RATING_CATEGORY  FROM  Restaurant GROUP BY Aggregate_rating
) AS EACH_RATING_CATEGORY
ORDER BY AGGREGATE_RATING_CATEGORY DESC;

SELECT AGGREGATE_RATING_CATEGORY,NUMBER_OF_RESTAURANT_WITH_EACH_RATING_CATEGORY, ( (NUMBER_OF_RESTAURANT_WITH_EACH_RATING_CATEGORY * 100) / (SELECT COUNT(DISTINCT Restaurant_Name) AS TOTAL_NUMBER_OF_RESTAURANT  FROM  Restaurant )) AS PERCENTAGE_OF_RESTAURANT_IN_EACH_RATING_CATEGORY
 FROM (
Select Aggregate_rating AS AGGREGATE_RATING_CATEGORY, COUNT(Aggregate_rating) AS NUMBER_OF_RESTAURANT_WITH_EACH_RATING_CATEGORY  FROM  Restaurant GROUP BY Aggregate_rating
) AS EACH_RATING_CATEGORY
ORDER BY PERCENTAGE_OF_RESTAURANT_IN_EACH_RATING_CATEGORY DESC
LIMIT 2;


-- Calculate the average number of votes received by restaurants.

SELECT AVG(Votes) AS AVERAGE_VOTES_PER_RESTAURANT
FROM Restaurant;

SELECT COUNT(Restaurant_Name) 
FROM Restaurant;

-- AVG VOTE AS BELO FOR REFERENCE
SELECT 1498645/9551 
FROM Restaurant;

-- Level 2 Task 2
SELECT * 
FROM Restaurant;

-- Task: Cuisine Combination Identify the most common combinations of cuisines in the dataset.
SELECT Cuisines, Votes, Aggregate_rating
FROM Restaurant 
ORDER BY Votes DESC LIMIT 5;


-- Determine if certain cuisine combinations tend to have higher ratings.
SELECT Cuisines, Aggregate_rating
FROM Restaurant 
ORDER BY Aggregate_rating DESC LIMIT 5;

WITH RELATION_BETWEEN_CUSINES_COMBINATION_AND_RATINGS AS (
  SELECT Restaurant_ID,
         CASE
           WHEN LOCATE(',', Cuisines) = 1 THEN SUBSTRING(Cuisines, 1, LOCATE(',', Cuisines) - 1)  -- First cuisine
           ELSE Cuisines  -- If no comma or only one cuisine
         END AS FIRST_CUSINE,
         CASE
           WHEN LOCATE(',', Cuisines) > 1 THEN SUBSTRING(Cuisines, LOCATE(',', Cuisines) + 1) -- Second cuisine (if exists)
           ELSE NULL
         END AS SECOND_CUISINE
  FROM Restaurant
  WHERE LENGTH(Cuisines) - LENGTH(REPLACE(Cuisines, ',', '')) >= 1
)
SELECT FIRST_CUSINE,
       COUNT(*) AS Number_Of_Restaurants,
       AVG(Restaurant.Aggregate_rating) AS Average_Rating
FROM RELATION_BETWEEN_CUSINES_COMBINATION_AND_RATINGS
LEFT JOIN Restaurant ON RELATION_BETWEEN_CUSINES_COMBINATION_AND_RATINGS.Restaurant_ID = Restaurant.Restaurant_ID
GROUP BY FIRST_CUSINE
ORDER BY Number_Of_Restaurants DESC;


-- Level 2 Task 3

-- Task: Geographic Analysis Plot the locations of restaurants on a map using longitude and latitude coordinates.
-- Identify any patterns or clusters of restaurants in specific areas.

-- Level 2 Task 4
SELECT * FROM Restaurant;

-- Task: Restaurant Chains Identify if there are any restaurant chains present in the dataset.

SELECT Restaurant_Name FROM Restaurant
GROUP BY Restaurant_Name
HAVING COUNT(Restaurant_Name) > 1;

-- Analyze the ratings and popularity of different restaurant chains.

WITH ANALYZE_RATINGS_AND_POPULARITY AS (
  SELECT *
  FROM Restaurant
  WHERE Aggregate_rating IS NOT NULL
)
SELECT 
  Restaurant_Name,
  AVG(Aggregate_rating) AS Average_rating,
  SUM(Votes) AS Total_Votes,
  COUNT(DISTINCT Locality) AS Number_of_Location
FROM ANALYZE_RATINGS_AND_POPULARITY
GROUP BY Restaurant_Name
ORDER BY Total_Votes DESC;
