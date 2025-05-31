/*добавьте сюда запросы для решения задания 6*/

BEGIN;  -- Начало транзакции

-- Создание CTE для расчета новых цен на капучино
WITH new_prices AS (
    SELECT 
        r.restaurant_uuid,
        menu_item.key AS cappuccino_name,
        menu_item.value::NUMERIC AS old_price,
        menu_item.value::NUMERIC * 1.2 AS new_price
    FROM cafe.restaurants r
    JOIN jsonb_each_text(r.menu::jsonb -> 'Кофе') AS menu_item ON menu_item.key = 'Капучино'
    WHERE r.type = 'coffee_shop'
    FOR UPDATE -- Блокировка строк
)
UPDATE cafe.restaurants r  -- Обновление цен
SET menu = jsonb_set(menu, 
    ARRAY['Кофе', 'Капучино'], 
    to_jsonb(np.new_price::TEXT))
FROM new_prices np
WHERE r.restaurant_uuid = np.restaurant_uuid;

COMMIT;  --Завершение транзакции и снятие блокировки со строк

/*
Чтобы обновить цены на капучино и одновременно ограничить изменение данных
в строках с "Капучино", можно использовать блокировку строк для защиты данных во время обновления. 
Это достигается с помощью блокировок на уровне строки (FOR UPDATE).
*/
