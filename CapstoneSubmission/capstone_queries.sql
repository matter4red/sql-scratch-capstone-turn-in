
-- 1.2a What columns does the survey table have?
 SELECT *
 FROM survey
 LIMIT 10;

-- 1.2b What questions are asked as part of the survey? 
SELECT DISTINCT question
FROM survey
ORDER BY 1;

 -- 1.3 What does the quiz table look like?
 SELECT *
FROM quiz
LIMIT 9;

 -- 1.4 What does the home_try_on table look like?
SELECT *
FROM home_try_on
LIMIT 10;

 -- 1.5 What does the purchase table look like?
SELECT *
FROM purchase
LIMIT 8;

-- 2.1 What is the number of responses for each question?
SELECT question, COUNT(*) AS '#', (100.0 * COUNT(*) / 500) AS '%'
FROM survey
GROUP BY 1
ORDER BY 1;

-- 3.1 Temporary table for analysing the home try on funnel
SELECT DISTINCT q.user_id, h.user_id IS NOT NULL AS 'is_home_try_on', h.number_of_pairs, p.user_id IS NOT NULL AS 'is_purchase'
FROM quiz q 
LEFT JOIN home_try_on h ON q.user_id = h.user_id 
LEFT JOIN purchase p ON q.user_id = p.user_id
LIMIT 10;

-- 3.2 Count of conversions from quiz -> home_try_on -> purchases
WITH purchase_funnel AS (SELECT DISTINCT q.user_id, h.user_id IS NOT NULL AS 'is_home_try_on', h.number_of_pairs, p.user_id IS NOT NULL AS 'is_purchase'
FROM quiz q 
LEFT JOIN home_try_on h ON q.user_id = h.user_id 
LEFT JOIN purchase p ON q.user_id = p.user_id)
SELECT COUNT (*) AS 'quizzes_complete', SUM(is_home_try_on) AS 'count_home_try_on', SUM(is_purchase) AS 'count_purchases'
FROM purchase_funnel;

-- 3.3 Count conversion if 3 or 5 pairs were issued for home try on with percentages
WITH purchase_funnel AS (SELECT DISTINCT q.user_id, h.user_id IS NOT NULL AS 'is_home_try_on', h.number_of_pairs, p.user_id IS NOT NULL AS 'is_purchase'
FROM quiz q 
LEFT JOIN home_try_on h ON q.user_id = h.user_id 
LEFT JOIN purchase p ON q.user_id = p.user_id)
SELECT number_of_pairs, SUM(is_purchase) AS 'count_purchase', SUM(is_home_try_on) AS 'count_home_try_on', (1.0 * SUM(is_purchase) / SUM(is_home_try_on))
FROM purchase_funnel
WHERE number_of_pairs IS NOT NULL
GROUP BY 1
ORDER BY 1 DESC;

-- 4.1 Count responses by question
SELECT question, response, COUNT(*)
FROM survey
GROUP BY 1, 2
ORDER BY 1, 2;

-- 4.2a Count by color category (sales)
SELECT CASE 
	WHEN color LIKE ('%black%') THEN 'Black'
    WHEN color LIKE ('%tortoise%') THEN 'Tortoise'
    WHEN color LIKE ('%crystal%') THEN 'Crystal'
    WHEN color LIKE ('%driftwood%') THEN 'Two-Tone'
    WHEN color LIKE ('Sea Glass Gray') THEN 'Neutral'
END AS 'color_category', COUNT (*) AS '#'
FROM purchase
GROUP BY 1
ORDER BY 2 DESC;

-- 4.2b Count of users that answered question 4 of the survey and purchased glasses
SELECT COUNT (*)
FROM survey
INNER JOIN purchase ON survey.user_id = purchase.user_id
WHERE survey.question LIKE '4. %';

-- 4.3a Count by Price
SELECT price, COUNT(*) AS '#'
FROM purchase
GROUP BY 1
ORDER BY 1 DESC;

-- 4.3b Count by model_name
SELECT model_name, COUNT(*) AS '#'
FROM purchase
GROUP BY 1;
ORDER BY 1 DESC;