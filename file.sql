create or replace function get_avg_age()
returns double precision as $$
begin
	return (
		select avg(age)
		from users
	);
end;
$$ language plpgsql;

create or replace function get_user(u_id int = 1)
returns users as $$
begin
	return (
		select * 
		from users
		where id = u_id
	);
end;
$$ language plpgsql;

select * from get_avg_age();

select * from get_user();