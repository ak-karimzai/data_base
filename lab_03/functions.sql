-- 1
create or replace function get_avg_age()
returns double precision as $$
begin
	return (
		select avg(age)
		from users
	);
end;
$$ language plpgsql;

select * from get_avg_age();

-- 2
create or replace function get_user(u_id int = 0)
returns table (_id int, username TEXT,
    password TEXT,
    email TEXT,
    gender varchar(1),
    age INT) as $$
begin
	return query
		select *
		from users
		where id = u_id;
end;
$$ language plpgsql;

select * from get_user(23);

-- 3
create or replace function get_room_det_by_id(room_id int = 0)
returns table (r_name text, capa int, pass text) as $$
begin
	if room_id < 0 then
  		RAISE EXCEPTION 'incorect ID --> %', room_id
      	USING HINT = 'id must be > 0';
	end if;

	return query
		select room_name, capacity, password
		from chat_rooms
		where id = room_id;
end;
$$ language plpgsql;

select * from get_room_det_by_id(23);

-- 4
create or replace function factorial(_fact int)
returns bigint as $$
declare res bigint;
begin
	if _fact < 0 then
		raise exception 'incorect input --> %', _fact
		using hint = 'input arg must >= 0';
	else
		if _fact <= 1 then
			res = 1;
		else
			res = _fact * factorial(_fact - 1);
		end if;
	end if;

	return res;
end; $$ language plpgsql;

select * from factorial(10);