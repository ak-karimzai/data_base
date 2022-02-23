-- 1 insert when changing
drop table if exists user_audits;
create table user_audits(
	usr_id int primary key not null,
	usr_name varchar,
	chaged_date timestamp
);

create or replace function log_changed_usr_name()
    returns trigger
    as
    $$
begin
	if new.username <> old.username then 
    	insert into user_audits values (old.id, old.username::varchar, now());
    end if;
    return new;
end; $$ language plpgsql;

drop trigger id_or_usrname_changed on users;

create trigger usrname_changed after update 
	on users
    for each row
    execute procedure log_changed_usr_name();

update users 
set username = 'new'
where id = 1023;

select * from user_audits ;

-- 2 instead of
create view user_view as
	select * from users
	where id < 500;
	
create or replace function user_delete()
    returns trigger
    as
    $$
begin
    -- 
    update user_view
    set username = 'Deleted User'
    where id = old.id;
    -- 
    return new;
end; $$ language plpgsql;

create trigger close_usr_del instead of delete on user_view
    for each row execute procedure user_delete();
	
