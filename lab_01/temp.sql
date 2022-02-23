select * from users
join participants on user_id = users.id;

select * from users
where id between 1 and 100;

select username from users
where username like 'Alix%';

select id from users
where id in (select user_id from participants);

select * from messages
where EXISTS (select '1' from users
    join participants as p on p.user_id = users.id
    where users.id = 2
) and id = 2;

select * from messages
where room_id > all(select id from chat_rooms where id not in (1, 2, 3, 4, 5));

select round(avg(capacity), 4) as "Averge capacity", 
       round(max(capacity), 4) as "max Averge", 
       round(min(capacity), 4) as "min Averge"
from chat_rooms;

select case
    when capacity < 100 then "Low"
    when capacity between  100 and 400 then "med"
    else "High"
    end
from chat_rooms;