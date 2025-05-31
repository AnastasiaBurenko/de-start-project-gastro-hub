/*добавьте сюда запрос для решения задания 5*/

WITH menu_cte AS (
	SELECT
		r.cafe_name,
        'Пицца' AS type,
        menu_item.key AS pizza_name,
        menu_item.value::INTEGER AS pizza_price
    FROM  cafe.restaurants r, jsonb_each_text(r.menu::jsonb -> 'Пицца') AS menu_item
    WHERE  r.type = 'pizzeria'
	),
menu_with_rank AS (
    SELECT 
        cafe_name,
        type,
        pizza_name,
        pizza_price,
        ROW_NUMBER() OVER (PARTITION BY cafe_name ORDER BY pizza_price DESC) AS rn
    FROM menu_cte
    )
SELECT 
    cafe_name,
    type,
    pizza_name,
    pizza_price
FROM menu_with_rank
WHERE rn = 1
ORDER BY cafe_name;
