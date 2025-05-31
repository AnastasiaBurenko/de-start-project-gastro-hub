/*добавьте сюда запрос для решения задания 1*/

CREATE OR REPLACE VIEW top_avg_check AS
    WITH avg_check AS (
        SELECT
            r.cafe_name,
            r.type,
            ROUND(AVG(s.avg_check), 2) AS avg_check
        FROM cafe.sales s
        JOIN cafe.restaurants r USING(restaurant_uuid)
        GROUP BY r.cafe_name, r.type
    	),
    row_num AS (
        SELECT
            cafe_name,
            type,
            avg_check,
            ROW_NUMBER() OVER (PARTITION BY type ORDER BY avg_check DESC) AS rn
        FROM avg_check
    	)
    SELECT
        cafe_name,
        type,
        avg_check
    FROM row_num
    WHERE rn <= 3;
