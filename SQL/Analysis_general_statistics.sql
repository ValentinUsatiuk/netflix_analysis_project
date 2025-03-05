-- Загальну кількість записів у базі
select count(*) as all_entries
from netflix_titles;
-- 8807

-- Кількість фільмів та серіалів окремо
select type, count(type) as count_type
from netflix_titles
group by type;
--Movie	6131, TV Show 2676

-- контент за роками(скільки фільмів чи серіалів додано в рік)
SELECT type, 
       EXTRACT(YEAR FROM CAST(date_added AS DATE)) AS year_added, 
       COUNT(*) AS total_count
FROM netflix_titles
WHERE date_added IS NOT NULL
GROUP BY type, year_added
ORDER BY year_added;

--Географія контенту
select country, count(title) as count_title
from netflix_titles
group by country
order by country;

-- розподіл по контент по країнам 
SELECT c.country_name, t.release_year, COUNT(t.show_id) AS total_titles
FROM netflix_titles t,
	LATERAL(SELECT unnest(string_to_array(t.country, ', ')) AS country_name) c
WHERE release_year IS NOT NULL
GROUP BY c.country_name, t.release_year
ORDER BY t.release_year, total_titles DESC;

-- топ 10 країн за контеном 
SELECT c.country_name, COUNT(t.show_id) AS total_titles
FROM netflix_titles t,
	LATERAL(SELECT unnest(string_to_array(t.country, ', ')) AS country_name) c
GROUP BY c.country_name
ORDER BY total_titles DESC
LIMIT 10;

-- Топ 10 жанрів на платформі
select c.listed_in, COUNT(t.show_id) AS total_titles
from netflix_titles t,
	LATERAL(SELECT unnest(string_to_array(t.listed_in, ', ')) AS listed_in) c
group by c.listed_in
order by total_titles DESC
limit 10;

select t.type, c.listed_in, COUNT(t.show_id) AS total_titles
from netflix_titles t,
	LATERAL(SELECT unnest(string_to_array(t.listed_in, ', ')) AS listed_in) c
group by t.type, c.listed_in
order by total_titles DESC;

select t.type, c.listed_in, t.release_year, COUNT(t.show_id) AS total_titles
from netflix_titles as t,
	lateral(SELECT unnest(string_to_array(t.listed_in, ', ')) AS listed_in) as c
WHERE release_year IS NOT NULL
group by t.type, c.listed_in,t.release_year
order by total_titles DESC;
	