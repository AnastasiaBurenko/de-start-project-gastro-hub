/*добавьте сюда запрос для решения задания 4*/

WITH cnt_pizza AS (
	SELECT 
	    r.cafe_name,
	    COUNT(menu_item.key) AS cnt_pizza,
	    DENSE_RANK() OVER (ORDER BY count(menu_item.key) DESC) AS dr
	FROM cafe.restaurants r, JSONB_EACH_TEXT(r.menu::jsonb ->'Пицца') AS menu_item
	WHERE r.type = 'pizzeria'
	GROUP BY r.cafe_name
		)
SELECT cafe_name
FROM cnt_pizza 
WHERE dr = 1;