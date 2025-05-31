/*добавьте сюда запрос для решения задания 2*/

CREATE MATERIALIZED VIEW avg_check_years AS
SELECT
	EXTRACT(YEAR FROM date) AS year,
	r.cafe_name,
	r.type,
	ROUND(AVG(s.avg_check), 2) AS this_year_avg_check,
	LAG(ROUND(AVG(s.avg_check), 2)) OVER (PARTITION BY r.cafe_name ORDER BY EXTRACT(YEAR FROM date)) AS previous_year_avg_check,
	ROUND((ROUND(AVG(s.avg_check), 2) - LAG(ROUND(AVG(s.avg_check), 2)) OVER (PARTITION BY r.cafe_name ORDER BY EXTRACT(YEAR FROM date))) / LAG(ROUND(AVG(s.avg_check), 2)) OVER (PARTITION BY r.cafe_name ORDER BY EXTRACT(YEAR FROM date)) * 100, 2) AS changes
FROM cafe.sales s
JOIN cafe.restaurants r USING(restaurant_uuid)
WHERE EXTRACT(YEAR FROM date) <> 2023
GROUP BY EXTRACT(YEAR FROM date), r.cafe_name, r.type;
