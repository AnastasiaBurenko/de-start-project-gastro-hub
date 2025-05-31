/*добавьте сюда запрос для решения задания 3*/

SELECT DISTINCT
	r.cafe_name,
	COUNT(manager_uuid) OVER (PARTITION BY cafe_name) AS manager_changes
FROM cafe.restaurant_manager_work_dates rmwd
JOIN cafe.restaurants r USING(restaurant_uuid)
ORDER BY manager_changes DESC
LIMIT 3;
