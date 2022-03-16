
/*Premise: We are consultants and one day decide to go to Benny's tacos for some breakfast
burritos. Benny sees us dressed up very nicely in our MSBA attire and asks us what we do. 
After talking to him for a while he tells us about his ambitions to expand Benny's tacos to 
be one of the biggest restaurant chains in Los Angeles. However, Benny is very busy with his 
current place in Westchester and doesn't know much about expanding his business or the steps 
he would have to take to do so. Eventually, we get to negotiating and he tells us that he will 
offer us a lifetime supply of burrito's and chips if we can help kick off his La expansion. 
We are given no further information about his restaurant as he has to get back to running his 
business. From here, we decide to look through the Yelp API and see what we can do to start 
off our project!*/

USE sakila;



DROP TABLE yelp;
CREATE TABLE yelp SELECT * FROM yelp1;

##########################################################################################
#looking at all the rows
SELECT * FROM yelp;


##########################################################################################
#Cleaning data - making $ into values so they can be sorted

UPDATE yelp
SET price = REPLACE(price, "$$", 2);

UPDATE yelp
SET price = REPLACE(price, "$", 1);

#ordering them by price to make sure it works
SELECT * FROM yelp
WHERE price <> "NA"
ORDER BY price DESC;



##########################################################################################
#dropping useless columns
ALTER TABLE yelp
DROP COLUMN address1;

ALTER TABLE yelp
DROP COLUMN address2;

ALTER TABLE yelp
DROP COLUMN url;

ALTER TABLE yelp
DROP COLUMN state;

SELECT * FROM yelp;

##########################################################################################
#dropping data points that are not in desired region
DELETE FROM yelp
WHERE longitude > -118;

DELETE FROM yelp
WHERE longitude < -119;

DELETE FROM yelp
WHERE latitude < 33.89;

##########################################################################################
#adding pricing based on bennys prices

UPDATE yelp
SET price = 2
WHERE name LIKE "%Benny%";

SELECT * FROM yelp
WHERE name LIKE "%Benny%";


##########################################################################################
#data investigation

#looking at the amount of tables who have mexican as their alias
SELECT COUNT(*)
FROM yelp
WHERE alias = 'mexican';

#upon further examination, it is not only the places with "mexican" as an alias that serve mexican food.
#it seems like they can be things like "seafood" but still serve mexican food

#counting amount by zip code
SELECT COUNT(*), zip_code
FROM yelp
GROUP BY zip_code;

#counting amount by rating
SELECT COUNT(*), rating
FROM yelp
GROUP BY rating;

##########################################################################################
/*An understanding of Benny's Tacos: The first step in expanding our restaurnat is understanding
what we are currently doing and our pricing. Thus, we used our dataset to search for Benny's tacos 
and see there is only one location and that our pricing is 1. We have an overall rating of 4.5 which is great
and we have a review count of 852 which is above average! This is a great start and allows us to 
better determine what we need to do to expand Benny's. */

SELECT * FROM yelp
WHERE name LIKE "%Benny%";


SELECT AVG(rating)
FROM yelp;

#Average rating: 3.82

SELECT AVG(review_count) 
FROM yelp;

#Average review count: 159

/*FOR MEETING:
1. Tableau
2. Key words related to Benny's reviews 
3. Key words relatied to restaurants where we want to expand 
4. PPT and Paper? - pull up what is due
5. 
*/
SELECT * FROM yelp
ORDER BY longitude;

##########################################################################################
/* The next step is to use tableau to get an understanding of what our dataset looks like on a map
This is done by using the latitude and longitude and will give us a visual representation of our 
data. After this is done, we can also look at what the pricing is like as well as rating and median 
income in specific areas to determine where we might want to expand. When that is done we can do a 
further analysis on restaurants in that area to get a better picture of not just mexican restaurants 
in that zip code,but restaturants in general to determine if we have to change anything about our 
menu and pricing. */




##########################################################################################
/* After doing our research in Tableau, we concluded that the three zip codes we want to look
into are 90034, 90036, and 90026. With this information, we will do a deeper dive into the 
restaurnats in those areas and determine where we think we can fit desired similarities yet 
also differentiate ourselves. to do this, we will download yelp data based on those zip codes 
and generate three more datasets for each zip code. */

##########################################################################################
/*We have now generated the datasets and we are going to do some cleaning on them. */

##########################################################################################
/*Cleaning 90026 */
DROP TABLE yelp_90026_copy;
CREATE TABLE yelp_90026_copy SELECT * FROM yelp_90026;

DELETE
FROM yelp_90026_copy
WHERE zip_code <> 90026;

UPDATE yelp_90026_copy
SET price = REPLACE(price, "$$", 2);

UPDATE yelp_90026_copy
SET price = REPLACE(price, "$", 1);

##########################################################################################
/*Cleaning 90034 */
DROP TABLE yelp_90034_copy;
CREATE TABLE yelp_90034_copy SELECT * FROM yelp_90034;

DELETE
FROM yelp_90034_copy
WHERE zip_code <> 90034;

UPDATE yelp_90034_copy
SET price = REPLACE(price, "$$", 2);

UPDATE yelp_90034_copy
SET price = REPLACE(price, "$", 1);

##########################################################################################
/*Cleaning 90036 */
DROP TABLE yelp_90036_copy;
CREATE TABLE yelp_90036_copy SELECT * FROM yelp_90036;

DELETE
FROM yelp_90036_copy
WHERE zip_code <> 90036;

UPDATE yelp_90036_copy
SET price = REPLACE(price, "$$", 2);

UPDATE yelp_90036_copy
SET price = REPLACE(price, "$", 1);


##########################################################################################
/* Now that we have those datasets cleaned out, we can look at them and analyze each zip code 
and their restaurants as well as text mining analysis on reviews and determine our rankings 
for where we might want to place our next Benny's. We also want to generate some statistics on 
the three zip codes to frame our decisions along with our visuals and that will be done below. */


##########################################################################################
#Average Price

#Average Price - 90026: 1.70
SELECT ROUND(AVG(price),2) AS "Average Price in 90026"
FROM yelp_90026_copy
WHERE price <> "NA";

#Average Price - 90026: 1.83
SELECT ROUND(AVG(price),2) AS "Average Price in 90034"
FROM yelp_90034_copy
WHERE price <> "NA";

#Average Price - 90026: 1.63
SELECT ROUND(AVG(price),2) AS "Average Price in 90036"
FROM yelp_90036_copy
WHERE price <> "NA";

##########################################################################################
#Average Rating

#Average Rating - 90026: 4.13
SELECT ROUND(AVG(rating),2) AS "Average Rating in 90026"
FROM yelp_90026_copy;

#Average Rating - 90026: 3.88
SELECT ROUND(AVG(rating),2) AS "Average Rating in 90034"
FROM yelp_90034_copy;

#Average Rating - 90026: 3.75
SELECT ROUND(AVG(rating),2) AS "Average Rating in 90036"
FROM yelp_90036_copy;

##########################################################################################
#Count of Mexican Restaurants

#Count of Mexican Restaurants in 90026 - 90026: 47
SELECT COUNT(*) AS "Count of Mexican Restaurants in 90026"
FROM yelp_90026_copy
WHERE alias LIKE "%mex%"
OR alias LIKE "%taco%"
OR alias LIKE "%foodstands%"
OR alias LIKE "%foodtrucks%";

#Count of Mexican Restaurants in 90034 - 90026: 33
SELECT COUNT(*) AS "Count of Mexican Restaurants in 90034"
FROM yelp_90034_copy
WHERE alias LIKE "%mex%"
OR alias LIKE "%taco%"
OR alias LIKE "%foodstands%"
OR alias LIKE "%foodtrucks%";

#Count of Mexican Restaurants in 90034 - 90026: 22
SELECT COUNT(*) AS "Count of Mexican Restaurants in 90036"
FROM yelp_90036_copy
WHERE alias LIKE "%mex%"
OR alias LIKE "%taco%"
OR alias LIKE "%foodstands%"
OR alias LIKE "%foodtrucks%";



