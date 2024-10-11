-- N E T F L I X  _ P R O J E C T

create table Netflix
(  show_id	    varchar(10),
   type       varchar (10),
   title	    varchar (105),
   director     varchar (210),
   cast_s        varchar (1000),
   country      varchar (150),
   date_added	 varchar (50),
   release_year	 int    ,
   rating	     varchar (10),
   duration	     varchar  (15),
   listed_in	 varchar   (80),
   description   varchar  (250)
   )

   select * from Netflix;
   
   select count(*)
   from Netflix;

   
   --  PROB_LEMS

   
   --1) Count the number of Movies vs TV Shows 

   SELECT TYPE , count(*)
   FROM Netflix
   group by type

   --2) Find the most common rating for movies and TV shows

   WITH RatingCounts AS (
    SELECT 
        type,
        rating,
        COUNT(*) AS rating_count
    FROM netflix
    GROUP BY type, rating
),
RankedRatings AS (
    SELECT 
        type,
        rating,
        rating_count,
        RANK() OVER (PARTITION BY type ORDER BY rating_count DESC) AS rank
    FROM RatingCounts
)
   SELECT 
    type,
    rating AS most_frequent_rating
   FROM RankedRatings
   WHERE rank = 1;


--3) List All Movies Released in a Specific Year (e.g., 2021)

 select *
 from NETFLIX
 WHERE TYPE = 'Movie'
 and release_year = 2021


-- 4) Find the Top 5 Countries with the Most Content on Netflix

    SELECT * 
FROM
(
    SELECT 
        UNNEST(STRING_TO_ARRAY(country, ',')) AS country,
        COUNT(*) AS total_content
    FROM netflix
    GROUP BY 1
) AS t1
WHERE country IS NOT NULL
ORDER BY total_content DESC
LIMIT 5;
    
--5) Identify the Longest Movie


	SELECT 
    *
    FROM netflix
    WHERE type = 'Movie'
    ORDER BY SPLIT_PART(duration, ' ', 1)::INT DESC;

	
--6.Find each year and the average numbers of content release in India on netflix.

    SELECT 
    country,
    release_year,
    COUNT(show_id) AS total_release,
    ROUND(
        COUNT(show_id)::numeric /
        (SELECT COUNT(show_id) FROM netflix WHERE country = 'India')::numeric * 100, 2
    ) AS avg_release
   FROM netflix
   WHERE country = 'India'
   GROUP BY country, release_year
   ORDER BY avg_release DESC
   LIMIT 5;

---7) List All Movies that are Documentaries

	 SELECT * 
     FROM netflix
     WHERE listed_in LIKE '%Documentaries';

---8) Find All Content Without a Director

      SELECT * 
      FROM netflix
      WHERE director IS NULL;	 

--9) Find How Many Movies Actor 'Ryan reynolds' Appeared in the Last 10 Years	

    SELECT * 
    FROM netflix
    WHERE cast_s LIKE '%Ryan Reynolds%'
     AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;

---10)Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies
      Produced in Japan

    SELECT 
    UNNEST(STRING_TO_ARRAY(cast_s, ',')) AS actor,
    COUNT(*)
    FROM netflix
    WHERE country = 'Japan'
    GROUP BY actor
    ORDER BY COUNT(*) DESC
    LIMIT 10;

---11) Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords

     SELECT 
    category,
    COUNT(*) AS content_count
    FROM (
    SELECT 
        CASE 
            WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad'
            ELSE 'Good'
        END AS category
    FROM netflix)
     AS categorized_content
    GROUP BY category;	 
	  