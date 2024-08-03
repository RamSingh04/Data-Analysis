CREATE DATABASE COGNIFYZ;

USE COGNIFYZ;

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

-- Task of Internship is as below

-- *****************************************************************************************************************************************************************************
-- Level 1

-- Level 1 Task 1 

-- Task : Top Cuisines Determine the top three most common cuisines in the dataset. 

-- Answer of Level 1 Task 1 Part 1

-- Top Cusines decided by their highest number of votes and selcted voting count as well
SELECT Cuisines, Votes 
FROM Restaurant 
ORDER BY Votes DESC LIMIT 3;

-- Top Cusines decided by their highest number of votes 
SELECT Cuisines, Votes 
FROM Restaurant 
ORDER BY Votes DESC LIMIT 3;

-- Top Cusines decided by their Occurences un the  Dataset number of votes 
SELECT Cuisines, COUNT(Cuisines) AS CUISINES_COUNT
FROM Restaurant
GROUP BY Cuisines
ORDER BY CUISINES_COUNT DESC
LIMIT 3;

-- Calculate the percentage of restaurants that serve each of the top cuisines. 

SELECT COUNT(DISTINCT Restaurant_Name) AS Total_Number_Of_Restaurant  
FROM  Restaurant ;

SELECT COUNT(DISTINCT Restaurant_Name) AS Total_Number_Of_Restaurant_Serving_Top_Cuisines  
FROM  Restaurant 
WHERE Cuisines IN ("Italian","American","Pizza","Burger","Cafe","Continental","Asian","North Indian") ;

SELECT COUNT(DISTINCT Restaurant_Name) * 100 /  (SELECT COUNT(DISTINCT Restaurant_Name)  
FROM  Restaurant 
WHERE Cuisines IN ("Italian","American","Pizza","Burger","Cafe","Continental","Asian","North Indian") ) AS PERCENTAGE_OF_RESTAURANT 
FROM Restaurant;

WITH TOP_CUISINES AS (
  SELECT Cuisines, COUNT(Cuisines) AS CUISINES_COUNT
  FROM Restaurant
  GROUP BY Cuisines
  ORDER BY CUISINES_COUNT DESC
  LIMIT 10
)
SELECT 
  TC.Cuisines,
  ROUND(CAST(TC.CUISINES_COUNT AS FLOAT) / TOTAL_RESTAURANTS * 100, 2) AS Percentage,
  TC.CUISINES_COUNT
FROM TOP_CUISINES TC
CROSS JOIN (
  SELECT COUNT(Restaurant_Name) AS TOTAL_RESTAURANTS
  FROM Restaurant
) AS TOTAL_RESTAURANTS;


-- Answer of Level 1 Task 1 Part 2 
SELECT ( (Total_Number_Of_Restaurant_Serving_Top_Cuisines * 100) / (SELECT COUNT(DISTINCT Restaurant_Name) AS Total_Number_Of_Restaurant  FROM  Restaurant )) AS PERCENTAGE_OF_RESTAURANT
 FROM (
SELECT COUNT(DISTINCT Restaurant_Name) AS Total_Number_Of_Restaurant_Serving_Top_Cuisines  FROM  Restaurant 
WHERE Cuisines IN ("Italian","American","Pizza","Burger","Cafe","Continental","Asian","North Indian")
) AS PERCENTAGE_SUBQUERY ;



-- *****************************************************************************************************************************************************************************

Select *  FROM  Restaurant ;
-- Level 1 Task 2 

-- Task: City Analysis Identify the city with the highest number of restaurants in the dataset.

SELECT  City AS CITY_NAME_WITH_HIGHEST_NUMBER_OF_RESTAURANT , COUNT(City) AS NUMBER_OF_RESTAURANT_IN_EACH_CITY 
FROM Restaurant 
GROUP BY City 
ORDER BY NUMBER_OF_RESTAURANT_IN_EACH_CITY DESC
LIMIT 1;

-- Calculate the average rating for restaurants in each city.
SELECT  City, AVG(Aggregate_rating) AS AVERAGE_RATING_OF_RESTAURANT_IN_EACH_CITY
FROM Restaurant 
-- WHERE CITY = "New Delhi" this is to check average rating of a single city, if require can add contion to forcefully select only those restaurants where rating is nit null
 WHERE Aggregate_rating IS NOT NULL
GROUP BY City 
ORDER BY AVERAGE_RATING_OF_RESTAURANT_IN_EACH_CITY DESC;



-- Below is just to show average rating for one city which is matching with above
SELECT City, AVG(Aggregate_rating)
FROM Restaurant 
Where City = "New Delhi";



-- Determine the city with the highest average rating.

SELECT  City, AVG(Aggregate_rating) AS AVERAGE_RATING_OF_RESTAURANT_IN_EACH_CITY
FROM Restaurant 
WHERE Aggregate_rating IS NOT NULL
GROUP BY City 
ORDER BY AVERAGE_RATING_OF_RESTAURANT_IN_EACH_CITY DESC
LIMIT 1;


-- Level 1 Task 3
Select *  FROM  Restaurant ;

-- Task: Price Range Distribution Create a histogram or bar chart to visualize the distribution of price ranges among the restaurants.
 
 Select Price_range,Currency,Restaurant_Name  
 FROM  Restaurant ;

Select Price_range, COUNT(Price_range) AS NUMBER_OF_RESTAURANT_AVAILABLE_IN_THIS_PRICE_RANGE  
FROM  Restaurant GROUP BY Price_range;

-- Calculate the percentage of restaurants in each price range category.

WITH PRICE_RANGES AS (
  SELECT Price_range, COUNT(Restaurant_Name) AS RESTAURANT_COUNT
  FROM Restaurant
  WHERE Price_range IS NOT NULL  -- Filter for restaurants with price range
  GROUP BY Price_range
)
SELECT 
  PR.Price_range,
  ROUND( CAST(PR.RESTAURANT_COUNT AS FLOAT) 
			/ TOTAL_RESTAURANTS * 100, 2) AS Percentage
FROM PRICE_RANGES PR
CROSS JOIN (
  SELECT COUNT(Restaurant_Name) AS TOTAL_RESTAURANTS
  FROM Restaurant
  WHERE Price_range IS NOT NULL  -- Consistent filtering for restaurants with price range
) AS TOTAL_RESTAURANTS;


SELECT PRICE_RANGE_CATEGORY,NUMBER_OF_RESTAURANT_AVAILABLE_IN_THIS_PRICE_RANGE, 
( 
	(NUMBER_OF_RESTAURANT_AVAILABLE_IN_THIS_PRICE_RANGE * 100) 
	/ 
	(SELECT COUNT(Restaurant_Name) AS Total_Number_Of_Restaurant  FROM  Restaurant WHERE Price_range IS NOT NULL )
) AS PERCENTAGE_OF_RESTAURANT_IN_EACH_PROCE_RANGE_CATEGORY
FROM (
Select Price_range AS PRICE_RANGE_CATEGORY,COUNT(Price_range) AS NUMBER_OF_RESTAURANT_AVAILABLE_IN_THIS_PRICE_RANGE  
FROM  Restaurant 
WHERE Price_range IS NOT NULL
GROUP BY Price_range
) AS PERCENTAGE_OF_RESTAURANT_IN_EACH_PRICE_CATEGORY;


Select COUNT(Price_range) AS NUMBER_OF_RESTAURANT_AVAILABLE_IN_THIS_PRICE_RANGE  FROM  Restaurant GROUP BY Price_range;


-- Level 1 Task 4
Select *  FROM  Restaurant ;

-- Task: Online Delivery Determine the percentage of restaurants that offer online delivery.

SELECT ( (NUMBER_OF_RESTAURANT_OFFERING_ONLINE_DELIVERY * 100) / (SELECT COUNT(Restaurant_Name) AS Total_Number_Of_Restaurant  FROM  Restaurant )) AS PERCENTAGE_OF_RESTAURANT_OFFERING_ONLINE_DELIVERY
 FROM (
Select COUNT(DISTINCT Restaurant_Name) AS NUMBER_OF_RESTAURANT_OFFERING_ONLINE_DELIVERY  FROM  Restaurant WHERE Has_Online_delivery = "Yes"
) AS ONLINE_DELIVERY_PERCENTAGE;



-- Compare the average ratings of restaurants with and without online delivery.
		SELECT AVG(Aggregate_rating) AS AVERAGE_RATING_OF_RESTAURANT_WITH_ONLINE_DELIVERY, COUNT(Has_Online_delivery)
         FROM Restaurant 
		 GROUP BY Has_Online_delivery
		HAVING Has_Online_delivery = "Yes"
        
        UNION ALL
        
        SELECT AVG(Aggregate_rating) AS AVERAGE_RATING_OF_RESTAURANT_WITH_OFFLINE_DELIVERY, COUNT(Has_Online_delivery)
         FROM Restaurant 
		 GROUP BY Has_Online_delivery
		HAVING Has_Online_delivery = "No";
        
	-- Below one is More Meaningfull
   SELECT
  CASE Has_Online_delivery
    WHEN 'Yes' THEN 'With Online Delivery'
    WHEN 'No' THEN 'Without Online Delivery'
  END AS Delivery_Status,
  AVG(Aggregate_rating) AS Average_Rating
FROM Restaurant
GROUP BY Has_Online_delivery;



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


-- Level 3 Task 1
Select *  FROM  Restaurant ;

-- Task: Restaurant Reviews 

-- Analyze the text reviews to identify the most common positive and negative keywords.

SELECT Rating_text,count(Rating_text)
FROM  Restaurant 
GROUP BY Rating_text;

WITH WORD_COUNT AS 
(
SELECT Rating_text,
	CASE 
    WHEN Rating_text IN ("Good","Very Good","Excellent") THEN "Positive Keywords : Excellent , Very Good, Good"
	WHEN Rating_text IN ("Poor") THEN "Negative Keywords: Poor"
    WHEN Rating_text = "Average" THEN "Neutral Keywpords : Average"
    ELSE "Not Rated"
    END AS WORD_CATEGORIZATION_IN_POSITIVE_OR_NEGATIVE
FROM Restaurant )
SELECT WORD_CATEGORIZATION_IN_POSITIVE_OR_NEGATIVE, COUNT(*) AS NUMBER_OF_REVIEWS
FROM WORD_COUNT
GROUP BY WORD_CATEGORIZATION_IN_POSITIVE_OR_NEGATIVE
ORDER BY NUMBER_OF_REVIEWS DESC
LIMIT 2;


-- Calculate the average length of reviews and explore if there is a relationship between review length and rating.

SELECT AVG(LENGTH(Rating_text)) AS AVERAGE_REVIEW_LENGTH
FROM Restaurant;


WITH WORD_COUNT AS 
(
SELECT Rating_text, Aggregate_rating,
	CASE 
    WHEN Rating_text IN ("Good","Poor","Not Rated") THEN "Short"
	WHEN Rating_text IN ("Average") THEN "Medium"
    WHEN Rating_text IN ("Very Good","Excellent")  THEN "Long"
    END AS REVIEW_TEXT_LENGTH
FROM Restaurant )
SELECT REVIEW_TEXT_LENGTH, COUNT(*) AS NUMBER_OF_REVIEWS, AVG(Aggregate_rating) AS AVERAGE_RATING
FROM WORD_COUNT
GROUP BY REVIEW_TEXT_LENGTH 
ORDER BY NUMBER_OF_REVIEWS DESC;

-- Level 3 Task 2
Select *  FROM  Restaurant ;

-- Task: Votes Analysis Identify the restaurants with the highest and lowest number of votes.

SELECT Restaurant_Name, Votes
FROM Restaurant
ORDER BY Votes DESC
LIMIT 1;

SELECT Restaurant_Name, Votes
FROM Restaurant
-- This condition can be used to Filtering out those restaurants who have 0 votes if you want to inculde those restaurants as well comment out or remove the WHERE caluse
WHERE Votes > 0 
ORDER BY Votes ASC
LIMIT 1;


-- Including Windows Function 
-- Highest Vote Received Restaurant
SELECT *,
  CASE WHEN Row_Number() OVER (ORDER BY Votes DESC) = 1 THEN 'Highest Vote Count'
       WHEN Row_Number() OVER (ORDER BY Votes ASC) = 1 THEN 'Lowest Vote Count'
  END AS Rating_Category
FROM (
  SELECT Restaurant_Name, Votes,
         ROW_NUMBER() OVER (ORDER BY Votes DESC) AS Desc_Rank,
         ROW_NUMBER() OVER (ORDER BY Votes ASC) AS Asc_Rank
  FROM Restaurant
  WHERE Votes > 0  -- Exclude restaurants with zero votes
) AS Ranked_Restaurants
ORDER BY Votes DESC
LIMIT 1;

-- Lowest Vote Received Restaurant

SELECT *,
  CASE WHEN Row_Number() OVER (ORDER BY Votes DESC) = 1 THEN 'Highest Vote Count'
       WHEN Row_Number() OVER (ORDER BY Votes ASC) = 1 THEN 'Lowest Vote Count'
  END AS Rating_Category
FROM (
  SELECT Restaurant_Name, Votes,
         ROW_NUMBER() OVER (ORDER BY Votes DESC) AS Desc_Rank,
         ROW_NUMBER() OVER (ORDER BY Votes ASC) AS Asc_Rank
  FROM Restaurant
  WHERE Votes > 0  -- Exclude restaurants with zero votes
) AS Ranked_Restaurants
ORDER BY Votes ASC 
LIMIT 1;

-- Analyze if there is a correlation between the number of votes and the rating of a restaurant.
Select *  
FROM  Restaurant ;

-- Level 3 Task 3
Select Average_Cost_for_two  
FROM  Restaurant 
ORDER BY Average_Cost_for_two ASC
LIMIT 1;
-- Task: Price Range vs. Online Delivery and Table Booking

-- Analyze if there is a relationship between the price range and the availability of online delivery and table booking.

SELECT Price_range,
	SUM(CASE WHEN Has_Online_delivery = 'Yes' THEN 1 ELSE 0 END) AS ONLNE_DELIVERY_AVAILABLE,
    SUM(CASE WHEN Has_Table_booking = 'Yes' THEN 1 ELSE 0 END) AS TABLE_BOOKING_AVAILABLE,
    COUNT(*) AS TOTAL_RESTAURANTS
    FROM Restaurant
    GROUP BY Price_range;

-- Determine if higher-priced restaurants are more likely to offer these services.

SELECT Price_range, AVG(Average_Cost_for_two) AS COST_OF_RESTAURANTS,
	SUM(CASE WHEN Has_Online_delivery = 'Yes' THEN 1 ELSE 0 END) AS ONLNE_DELIVERY_AVAILABLE,
    SUM(CASE WHEN Has_Table_booking = 'Yes' THEN 1 ELSE 0 END) AS TABLE_BOOKING_AVAILABLE,
    COUNT(*) AS TOTAL_RESTAURANTS
    FROM Restaurant
    GROUP BY Price_range;



SELECT Restaurant_Name,Average_Cost_for_two,Currency,
  CASE 
    WHEN Average_Cost_for_two <=3000 THEN 'Low Price'
     WHEN Average_Cost_for_two >=3001 and Average_Cost_for_two <= 9999 Then 'Medium Price'
    WHEN Average_Cost_for_two >= 10000 THEN 'High Price'
  END AS Price_Range,
  Has_Online_delivery ,
  Has_Table_booking
FROM Restaurant;

SELECT 
  Average_Cost_for_two,
  SUM(CASE WHEN Has_Online_delivery = 'Yes' THEN 1 ELSE 0 END) AS Delivery_Available,
  SUM(CASE WHEN Has_Table_booking = 'Yes' THEN 1 ELSE 0 END) AS Booking_Available,
  COUNT(*) AS Total_Restaurants
FROM (
 SELECT Restaurant_Name, Average_Cost_for_two, Currency,
  CASE 
    WHEN Average_Cost_for_two <=3000 THEN 'Low Price'
     WHEN Average_Cost_for_two >=3001 and Average_Cost_for_two <= 9999 Then 'Medium Price'
    WHEN Average_Cost_for_two >= 10000 THEN 'High Price'
  END AS Price_Range,
  Has_Online_delivery , Has_Table_booking
FROM Restaurant
) AS Categorized_Restaurants
GROUP BY Average_Cost_for_two;

SELECT 
  Price_Range,
  AVG(Average_Cost_for_two) AS Average_Cost,  -- Calculate average cost within each range
  SUM(CASE WHEN Has_Online_delivery = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) * 100 AS Online_Delivery_Percent,
  SUM(CASE WHEN Has_Table_booking = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) * 100 AS Table_Booking_Percent
FROM (
  SELECT Restaurant_Name, Average_Cost_for_two, Currency,
  CASE 
    WHEN Average_Cost_for_two <=3000 THEN 'Low Price'
     WHEN Average_Cost_for_two >=3001 and Average_Cost_for_two <= 9999 Then 'Medium Price'
    WHEN Average_Cost_for_two >= 10000 THEN 'High Price'
  END AS Price_Range,
  Has_Online_delivery , Has_Table_booking
FROM Restaurant
) AS Categorized_Restaurants
GROUP BY Price_Range;

-- Determine if higher-priced restaurants are more likely to offer these services.

WITH Categorized_Restaurants AS (
  SELECT 
    Restaurant_Name, 
    Average_Cost_for_two, 
    Currency,
    CASE 
    WHEN Average_Cost_for_two >=0 and Average_Cost_for_two <=3000 THEN 'Low Price'
     WHEN Average_Cost_for_two >=3001 and Average_Cost_for_two <= 9999 Then 'Medium Price'
    WHEN Average_Cost_for_two >= 10000 THEN 'High Price'
    ELSE 'Low Price'
    END AS Price_Range,
    Has_Online_delivery, 
    Has_Table_booking
  FROM Restaurant
)
SELECT 
  Price_Range,
  SUM(CASE WHEN Has_Online_delivery = "Yes" THEN 1 ELSE 0 END) AS Delivery_Available,
  SUM(CASE WHEN Has_Table_booking = 'Yes' THEN 1 ELSE 0 END) AS Booking_Available
FROM Categorized_Restaurants
GROUP BY Price_Range, Has_Online_delivery, Has_Table_booking
WITH ROLLUP;




