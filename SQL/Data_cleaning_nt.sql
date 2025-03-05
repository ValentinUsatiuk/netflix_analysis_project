select * from netflix_titles
limit 100;

UPDATE public.netflix_titles
SET 
    show_id = NULLIF(show_id, 'nan'),
    "type" = NULLIF("type", 'nan'),
    title = NULLIF(title, 'nan'),
    director = NULLIF(director, 'nan'),
    "cast" = NULLIF("cast", 'nan'),
    country = NULLIF(country, 'nan'),
    date_added = NULLIF(date_added, 'nan'),
    rating = NULLIF(rating, 'nan'),
    duration = NULLIF(duration, 'nan'),
    listed_in = NULLIF(listed_in, 'nan'),
    description = NULLIF(description, 'nan');

-- пропуски у всіх важливих колонках
SELECT 
    COUNT(*) AS total_records,
    COUNT(show_id) AS filled_show_id,
    COUNT(type) AS filled_type,
    COUNT(title) AS filled_title,
    COUNT(director) AS filled_director,
    COUNT("cast") AS filled_cast,
    COUNT(country) AS filled_country,
    COUNT(date_added) AS filled_date_added,
    COUNT(release_year) AS filled_release_year,
    COUNT(rating) AS filled_rating,
    COUNT(duration) AS filled_duration,
    COUNT(listed_in) AS filled_listed_in
FROM netflix_titles;

--неправильні роки випуску
SELECT DISTINCT release_year
FROM netflix_titles
ORDER BY release_year;
-- роки вірні 

-- Перевірка duration (тривалість)
SELECT DISTINCT duration
FROM netflix_titles
order by duration;

SELECT *
FROM netflix_titles
WHERE duration is null or duration ~ '^\d+$';

UPDATE netflix_titles
SET duration = rating
WHERE duration IS NULL AND rating ~ '^\d+ min$';

UPDATE netflix_titles
SET rating = NULL
WHERE rating ~ '^\d+ min$';

-- Перевірка текстових значень
--Знайти нетипові країни
SELECT DISTINCT country
FROM netflix_titles
ORDER BY country;

SELECT *
FROM netflix_titles
WHERE country LIKE ',%';
-- , South Korea \ , France, Algeria
UPDATE netflix_titles
SET country = TRIM(LEADING ',' FROM country)
WHERE country LIKE ',%';

--нетипові вікові рейтинги
SELECT DISTINCT rating
FROM netflix_titles;
-- id -- s5814, s5542, s5795

-- Перевірка дублікатів
SELECT title, COUNT(*)
FROM netflix_titles
GROUP BY title
HAVING COUNT(*) > 1;
-- Consequences - 2
SELECT *
FROM netflix_titles
WHERE title = 'Consequences';

DELETE FROM netflix_titles
WHERE title = 'Consequences'
AND show_id NOT IN (
    SELECT MIN(show_id)
    FROM netflix_titles
    WHERE title = 'Consequences'
);

-- тестові записи
SELECT *
FROM netflix_titles
WHERE title ILIKE '%test%' OR title ILIKE '%example%';
-- немає тестових записів


--проблемні значення в date_added
SELECT date_added
FROM netflix_titles
WHERE date_added IS NULL OR date_added = ''
LIMIT 10;
-- 10 

UPDATE netflix_titles
SET date_added = NULL
WHERE date_added = '';


-- записи, у яких немає країни робимо -"Unknown
UPDATE netflix_titles
SET country = 'Unknown'
WHERE country IS NULL OR country = '';

