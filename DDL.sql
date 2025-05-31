/*Добавьте в этот файл все запросы, для создания схемы сafe и
 таблиц в ней в нужном порядке*/

/* Создаем схему cafe */
create schema if not exists cafe;


/* 1. Создаем тип enum. */
create type cafe.restaurant_type as enum ('coffee_shop', 'restaurant', 'bar', 'pizzeria');


/* 2. Создаем таблицу cafe.restaurants с информацией о ресторанах. */
create table if not exists cafe.restaurants (
	restaurant_uuid UUID PRIMARY KEY DEFAULT GEN_RANDOM_UUID(),
	cafe_name text,
	type cafe.restaurant_type,
	menu jsonb
	);


/* 3. Создаем таблицу cafe.managers с информацией о менеджерах. */
create table if not exists cafe.managers (
	manager_uuid UUID PRIMARY KEY DEFAULT GEN_RANDOM_UUID(),
	name text,
	phone text
	);


/* 4. Создаем таблицу cafe.restaurant_manager_work_dates с информацией о работе менеджеров. */
create table if not exists cafe.restaurant_manager_work_dates (
	restaurant_uuid UUID NOT null,
	manager_uuid UUID NOT null,
    date_begin DATE NOT NULL,
    date_end DATE NOT NULL,
    PRIMARY KEY (restaurant_uuid, manager_uuid),
    FOREIGN KEY (restaurant_uuid) REFERENCES cafe.restaurants(restaurant_uuid),
    FOREIGN KEY (manager_uuid) REFERENCES cafe.managers(manager_uuid)
	);


/* 5. Создаем таблицу cafe.sales с информацией о продажах. */
create table if not exists cafe.sales (
	date DATE NOT NULL,
	restaurant_uuid UUID NOT null,
    avg_check NUMERIC(6,2),
    PRIMARY KEY (date, restaurant_uuid),
    FOREIGN KEY (restaurant_uuid) REFERENCES cafe.restaurants(restaurant_uuid)
	);
