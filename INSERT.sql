/*Добавьте в этот файл запросы, которые наполняют данными таблицы в схеме cafe данными*/

/* Заполняем таблицу cafe.restaurants. */
INSERT INTO cafe.restaurants(cafe_name, type, menu)
SELECT DISTINCT
	m.cafe_name, 
	s.type::cafe.restaurant_type,
	m.menu
FROM raw_data.menu m
JOIN raw_data.sales s ON m.cafe_name = s.cafe_name
;


/* Заполняем таблицу cafe.managers. */
INSERT INTO cafe.managers(name,phone)
SELECT DISTINCT
	manager,
	manager_phone 
FROM raw_data.sales;


/* Заполняем таблицу cafe.restaurant_manager_work_dates. */
INSERT INTO cafe.restaurant_manager_work_dates(restaurant_uuid, manager_uuid, date_begin, date_end)
SELECT
    r.restaurant_uuid,
    m.manager_uuid,
    MIN(s.report_date) AS date_begin,
    MAX(s.report_date) AS date_end
FROM raw_data.sales s
JOIN cafe.restaurants r ON s.cafe_name = r.cafe_name
JOIN cafe.managers m ON s.manager = m.name
GROUP BY r.restaurant_uuid, m.manager_uuid;


/* Заполняем таблицу cafe.sales. */
INSERT INTO cafe.sales(date, restaurant_uuid, avg_check)
SELECT DISTINCT
	s.report_date,
	r.restaurant_uuid,
	s.avg_check
FROM raw_data.sales s
JOIN cafe.restaurants r ON s.cafe_name = r.cafe_name;
