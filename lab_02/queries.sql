-- 1 - =
/* name, gender and name of 2nd room */
SELECT DISTINCT username, gender, cr.room_name
FROM users
    JOIN participants as p on users.id = p.id
    JOIN chat_rooms as cr on cr.id = p.room_id
WHERE p.room_id = 2
ORDER BY username;

-- 2- Like
/* name, age and gender of users between 20 and 22 */
SELECT DISTINCT username, age, gender
FROM users
WHERE age BETWEEN 20 and 22
ORDER BY age;

-- 3 - Like
/* all users which username started with a and finished with a*/
SELECT username
FROM users
WHERE username like 'A%a';

-- 4 - IN
/* username and messages between 18 and 20 */
SELECT users.username, message
from messages
    JOIN users on users.id = messages.user_id
WHERE user_id in (
    SELECT DISTINCT id
    from users
    WHERE age BETWEEN 18 and 20
);

-- 5 - excist
SELECT cr.*
from chat_rooms AS cr
WHERE EXISTS(
    SELECT * FROM chat_rooms
        JOIN messages as m on chat_rooms.id = m.room_id
    WHERE LENGTH(m.message) < 20
);

-- 6. Инструкция SELECT, использующая предикат сравнения с квантором. 
/* 1st room users which age is greather than AVG age from 4th room */
SELECT username, age
from users
    JOIN participants as p on users.id = p.user_id
    JOIN chat_rooms as cr on cr.id = p.room_id
WHERE age > ALL(
    SELECT avg(age)
    FROM users
        JOIN participants as p on users.id = p.user_id
        JOIN chat_rooms as cr on cr.id = p.room_id
    where cr.id = 4)
    AND cr.id = 1;

/* 7. Инструкция SELECT, использующая агрегатные функции в выражениях столбцов. */
SELECT SUM(age) as age_sum, count(age) as age_count, avg(age) as averge_age
FROM ( SELECT * 
    from users
        JOIN participants as p ON users.id = p.user_id
        JOIN chat_rooms as cr on cr.id = p.room_id
    WHERE cr.id = 2
) as exp;

/* 8. Инструкция SELECT, использующая скалярные подзапросы в выражениях столбцов. */
/* средная возраст 2nd комнате */
SELECT room_name,
    (
        SELECT AVG(age)
        from users
            JOIN participants as p on users.id = p.user_id
            JOIN chat_rooms as cr on cr.id = p.room_id
        WHERE cr.id = 2
    ) as averge_room_age
from chat_rooms
where id = 2;

/* 9. Инструкция SELECT, использующая простое выражение CASE. */
/* проверка возрасти на 30 */
SELECT username, age,
    CASE
        when age >=30 then 'age approved'
        else 'age not approved'
        end
    as age_check
from users;

/* 9. Инструкция SELECT, использующая простое выражение CASE. */
/* проверка возрасти на все */
SELECT username, age,
    CASE
        when age <=30 then '+'
        when age <= 50 then '++'
        else '+++'
        end
    as age_check
from users;

/* 11. Создание новой временной локальной таблицы из результирующего набора данных инструкции SELECT. */
create temp table temp_table as
select username, cr.room_name
from users
    JOIN participants as p on users.id = p.user_id
    JOIN chat_rooms as cr on cr.id = p.room_id;

select * from temp_table;
drop table temp_table;

/* 12. Инструкция SELECT, использующая вложенные коррелированные подзапросы
   в качестве производных таблиц в предложении FROM.*/
SELECT *
FROM chat_rooms as cr
    JOIN (
        select username, p.room_id
        from users
            JOIN participants as p on users.id = p.id
    ) as u on  cr.id = u.room_id;

/* 13. Инструкция SELECT, использующая вложенные подзапросы с уровнем вложенности 3. */
/* максимальная возразт каждой комнате */
SELECT z.room_name, z.max_age
from (
    SELECT id as room_id, room_name, k.max_age
    from chat_rooms
        JOIN (
            select room_id, max(u.age) as max_age
            from participants
                JOIN users as u on participants.user_id = u.id
                JOIN chat_rooms as cr on cr.id = participants.room_id
            group by room_id) as k on chat_rooms.id = k.room_id) as z;

/* 14. Инструкция SELECT, консолидирующая данные с помощью предложения GROUP BY, но без предложения HAVING. */
/* пересчитать одинаковые имена */
SELECT username, count(id) as qty
from users
GROUP by username;

/* 15. Инструкция SELECT, консолидирующая данные с помощью предложения GROUP BY и предложения HAVING. */
/* пересчитать имена с А% */
SELECT username, count(id) as qty
from users
GROUP by username
HAVING username like ('A%');

/* 16. Однострочная инструкция INSERT, выполняющая вставку в таблицу одной строки значений. */
INSERT into chat_rooms values (1001, 'TopChat', 100, 'qwerty1234');

/* 17. Многострочная инструкция INSERT, выполняющая вставку в таблицу результирующего набора данных вложенного подзапроса. */
INSERT into chat_rooms
SELECT (SELECT MAX(id) + 1 from chat_rooms), 'BestChat', 100, 'qwerty1234'
from chat_rooms as cr
WHERE capacity > 80;

/* 18. Простая инструкция UPDATE. */
UPDATE chat_rooms
set room_name = 'NEWNAME'
where id = 1001;

/* 19. Инструкция UPDATE со скалярным подзапросом в предложении SET. */
UPDATE chat_rooms
set room_name = (
    SELECT room_name
    from chat_rooms
    ORDER by id desc fetch next 1 rows only
)
where id = 1001;

/* 20. Простая инструкция DELETE. */
DELETE chat_rooms
where id = 1001;

/* 21. Инструкция DELETE с вложенным коррелированным подзапросом в предложении WHERE. */
DELETE users
where id = (
    select id from users
    where age = 60
);

/* 22. Инструкция SELECT, использующая простое обобщенное табличное выражение */
with test(id, username, gender) as (
    select id, username, gender
    from users
)

select * from test;

-- 23
create table category
(
    id              integer      not null primary key,
    name            varchar(100) not null,
    parent_category integer references category
);

INSERT INTO category
values (1, 'Root Node', null);
INSERT INTO category
values (2, 'Software', 1);
INSERT INTO category
values (3, 'Hardware', 1);
INSERT INTO category
values (4, 'Notebooks', 3);
INSERT INTO category
values (5, 'Phones', 3);
INSERT INTO category
values (6, 'Applications', 2);
INSERT INTO category
values (7, 'Database Software', 2);
INSERT INTO category
values (8, 'Relational DBMS', 7);
INSERT INTO category
values (9, 'Tools', 7);
INSERT INTO category
values (10, 'Command Line Tools', 9);
INSERT INTO category
values (11, 'GUI Tools', 9);
INSERT INTO category
values (12, 'Android Phones', 5);
INSERT INTO category
values (13, 'IPhone', 5);
INSERT INTO category
values (14, 'Windows Phones', 5);

WITH recursive rec (id, name, parent_category, depth) as (
    SELECT id, name, parent_category, 0 AS depth
    FROM category
    WHERE name = 'Software' -- start of recursion
    UNION ALL
    SELECT child.id, child.name, child.parent_category, depth + 1
    from category child
             join rec parent on parent.id = child.parent_category -- the self join build up the recursion
    WHERE depth < 3 -- control depth ( <= 1 )
)

SELECT * from rec;


drop table category;

/* 24. Оконные функции. Использование конструкций MIN/MAX/AVG OVER() */
SELECT MAX(age) AS MAX_AGE, MIN(age) AS MIN_AGE
FROM users;

SELECT username, age, AVG(age) OVER ( PARTITION BY username) AS avg_age, MAX(age)
FROM users
GROUP BY username, age;


-- 25
Create table myRooms as
select *
from CHAT_ROOMS
union all
select *
from CHAT_ROOMS
union all
select *
from CHAT_ROOMS;

select *
from myRooms where id = 587;

delete
from myRooms
where id in (select rid
                from (select id rid,
                             row_number() over (partition by
                                 ID, ROOM_NAME, CAPACITY, PASSWORD 
                      order by ID) rn
                      from myRooms) as u
                where id <> 1);

drop table myRooms;