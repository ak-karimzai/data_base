-- 1) Из таблиц базы данных, созданной в первой
-- лабораторной работе, извлечь данные в JSON.
select row_to_json(u) from users u ; 
select row_to_json(m) from messages m ;
select row_to_json(cr) from chat_rooms cr ;
select row_to_json(p) from participants p ;

-- 2. Выполнить загрузку и сохранение JSON файла в таблицу.
-- Созданная таблица после всех манипуляций должна соответствовать таблице
-- базы данных, созданной в первой лабораторной работе.
\copy (select row_to_json(u) from users u) to '/uni/db/lab_05/users.json'

create table users_copy
(
    id INT NOT NULL,
    username varchar NOT NULL,
    password varchar NOT NULL,
    email varchar,
    gender varchar(1),
    age INT
);

create table if not exists t (j json);
\copy t from '~/uni/lab_05/users.json';

insert into users_copy (id, username, password, email, gender, age) select (j->>'id')::int, j->>('username')::varchar, 
j->>('password')::varchar, j->>('email')::varchar, j->>('gender')::varchar(1), j->>("age")::int from t;

-- Создать таблицу, в которой будет атрибут(-ы) с типом XML или JSON, или
-- добавить атрибут с типом XML или JSON к уже существующей таблице.
-- Заполнить атрибут правдоподобными данными с помощью команд INSERT
-- или UPDATE.
create table json_temp (
	data json
);
insert into json_temp(data) values
	('{"car_name": "Corolla", "characteristics":{"color": "white", "model": 2021}}'),
	('{"car_name": "Land Cruiser", "characteristics":{"color": "Black", "model": 2020}}');

-- Извлечь JSON фрагмент из JSON документа.
select data->'car_name' from json_temp jt ;

-- Извлечь значения конкретных узлов или атрибутов JSON документа.
select data->'characteristics'->'color' from json_temp jt ;

create or replace function check_exists(json_row json, key varchar)
returns boolean
as $$
begin
    return (json_row->key) is not NULL;
end;
$$ language plpgsql;

select check_exists('{"car_name": "Corolla", "characteristics":{"color": "white", "model": 2021}}', 'characteristics');
select check_exists('{"car_name": "Corolla", "characteristics":{"color": "white", "model": 2021}}', 'model');

update json_temp set data = data || '"characteristics":{"model": 2022}'
where (data->'characteristics'->'model')::number = 2021;

-- Разделить JSON документ на несколько строк по узлам.
SELECT * FROM jsonb_array_elements('[{"car_name": "Corolla", "characteristics":{"color": "white", "model": 2021}},
	                                {"car_name": "Land Cruiser", "characteristics":{"color": "Black", "model": 2020}}]');

create temp table mytemptable(name varchar);

select c.relname
from pg_namespace n
  join pg_class   c on n.oid=c.relnamespace
where n.nspname='pg_temp_1';