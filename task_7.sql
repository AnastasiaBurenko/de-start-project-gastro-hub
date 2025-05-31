/*добавьте сюда запросы для решения задания 6*/

BEGIN;  -- Начало транзакции

LOCK TABLE cafe.managers IN ACCESS EXCLUSIVE MODE;  --Блокировка таблица

ALTER TABLE cafe.managers ADD COLUMN phone_numbers TEXT[];  -- Добавление нового атрибута для создания массива номеров

-- Создание cte для предварительного расчета новых номеров
WITH updated_numbers AS (
    SELECT 
        manager_uuid,
        '8-800-2500-' || 99 + ROW_NUMBER() OVER (ORDER BY name) AS new_phone,
        phone
    FROM 
        cafe.managers
	)
UPDATE cafe.managers m  -- Обновление нового атрибута
SET phone_numbers = ARRAY[
    u.new_phone,
    u.phone 
]
FROM updated_numbers u
WHERE m.manager_uuid = u.manager_uuid;

ALTER TABLE cafe.managers DROP COLUMN phone;  -- Удаление старых номеров

COMMIT;  -- Завершение транзакции и снятие блокировки

/*
ACCESS EXCLUSIVE MODE используется для блокировки таблицы cafe.managers в режиме, 
который не разрешает другим пользователям вносить изменения в эту таблицу 
во время выполнения текущей транзакции.
*/