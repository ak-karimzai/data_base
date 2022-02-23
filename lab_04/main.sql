-- 1) Определяемую пользователем скалярную функцию CLR.
create or replace function get_room_info(room_id int)
returns chat_rooms
as $$
res = plpy.execute(f" \
    select * \
    from chat_rooms  \
    where id = {room_id};")
if res:
	return res[0]
$$ language plpython3u;

select * from get_room_info(2);

-- 2) Пользовательскую агрегатную функцию CLR.
create or replace function get_age_chars()
returns table(age_max int, age_min int, age_avg float)
as $$
res = plpy.execute("select max(age)::int, min(age)::int, avg(age)::int from users;")
if res:
    yield res[0]['max'], res[0]['min'], res[0]['avg']
$$ language plpython3u;

select * from get_age_chars();

-- 3) Определяемая пользователем табличная функция CLR
create or replace function get_users_between(_b int, _e int)
returns table(usr_id int, usr_name varchar, age int)
as $$
res = plpy.execute(f"select id, username, age from users \
					 where age between {_b} and {_e};")
for elem in res:
    yield(elem['id'], elem['username'], elem['age'])
$$ language plpython3u;

select * from get_users_between(20, 30);

-- 4) Хранимую процедуру CLR
create or replace procedure update_usr_name(_id int, new_name varchar)
as $$
query = plpy.prepare("update users set username = $2 \
					where id = $1", ["int", "varchar"])
plpy.execute(query, [_id, new_name])
$$ language plpython3u;

call update_usr_name(1, 'New name');

-- 5) Триггер CLR,
create table user_audits (
    usr_id int,
    usr_name varchar
);

create or replace function log_update_usr()
returns trigger as $$
query = plpy.prepare("insert into user_audits values ($1, $2);", ["int", "text"])

_new = TD['new']
_old = TD['old']
if _new["username"] != _old["username"]:
	plpy.execute(query, [_old["id"], _old["username"]])
return 'Modify'
$$ language plpython3u;

create trigger usr_update after update on users
	for each row execute procedure log_update_usr();

-- 6) Определяемый пользователем тип данных CLR.
create type rooms as (
    id int,
    room_name varchar,
    capacity int
);

create or replace function get_room_charc(_id int)
returns rooms as $$
class rooms:
	def __init__(self, i, r, c):
		self.id = i
		self.room_name = r
		self.capacity = c
		
query = plpy.execute("select id, room_name, capacity from chat_rooms;")

return rooms(query[0]["id"], query[0]["room_name"], query[0]["capacity"])
$$ language plpython3u;

select * from get_room_charc(2);

create or replace function clr_factorial(n int)
returns bigint as $$
res = None
if n <= 1:
    res = 1
else:
    res = n * clr_factorial(n - 1)
return res
$$ language plpython3u;

select clr_factorial(10);