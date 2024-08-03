CREATE DATABASE LEVEL1;

USE LEVEL1;

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

