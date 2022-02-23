-- 1) Хранимая процедура без параметров или с параметрами
create or replace procedure insert_new_usr(usr_id int, usr_name text, usr_pass text, usr_email text, usr_gen varchar(1), age int)
as $$
begin
	insert into users values(usr_id, usr_name, usr_pass, usr_email, usr_gen, age);
end; $$ language plpgsql;

call insert_new_usr(1001, 'new usr', 'asdasdfsdf', 'asda@fds.com', 'm', '20');

select * from users
where id = 1001;

-- 2) Рекурсивную хранимую процедуру или процедуры с рекурсивным OTB
create or replace procedure fib_n(res inout int, n_max int, fst int default 1, snd int default 1)
language plpgsql as
$$
declare 
	tmp int;
begin
	tmp = fst + snd;
	if tmp <= n_max then
		res = tmp;
		raise notice 'elem = %', res;
		call fib_n(res, n_max, snd, tmp);
	end if;
end;
$$;

call fib_n(0, 100);

-- 3 прос с курсором
create or replace procedure print_messages_usr(
	usr_id integer
) as $$
declare
	my_cursor cursor(usr_id integer) for 
		select message from messages
		where user_id = usr_id;
	rec record;
	i int default 1;
begin 
	open my_cursor(usr_id);

	loop
		fetch my_cursor into rec;
		exit when not found;
		
		raise notice 'message no % = %', i, rec::varchar;
	end loop;
	close my_cursor;
end; $$ language plpgsql;

call print_messages_usr(1);

-- 4 прос с метаданными
create or replace procedure print_details(t_name varchar)
language plpgsql as $$
declare 
	my_cursor cursor for 
		select column_name, data_type
		from information_schema.columns
		where table_name = t_name;
	tmp record;
begin
	open my_cursor;
    loop
        fetch my_cursor
        into tmp;
        exit when not found;
        raise notice 'column name = %; data type = %', tmp.column_name, tmp.data_type;
    end loop;
    close my_cursor;
end;
$$;

call print_details('users');

-- zashit
create or replace procedure print_records(t_name varchar)
language plpgsql as $$
declare
	records int default 0;
begin
	select reltuples into records from pg_class where relname = t_name;
	raise notice 'Number of records in table = %', records;
end;
$$;

call print_records('users');