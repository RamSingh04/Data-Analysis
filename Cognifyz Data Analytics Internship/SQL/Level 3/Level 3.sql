CREATE DATABASE LEVEL3;

USE LEVEL3;

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
Drop DATABASE Level3;
SHOW GLOBAL VARIABLES LIKE 'local_infile';

SET GLOBAL local_infile = 'ON';

Load data infile "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Restaurant.csv" into table Restaurant
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

Select *  FROM  Restaurant ;



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
