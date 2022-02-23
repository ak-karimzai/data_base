DELETE from chat_rooms;
DELETE from users;
DELETE from participants;
DELETE from messages;

\copy chat_rooms from '~/uni/db/lab_01/csv/chatrooms.csv' delimiter ',' csv header;
\copy users from '~/uni/db/lab_01/csv/users.csv' delimiter ',' csv header;
\copy participants from '~/uni/db/lab_01/csv/participants.csv' delimiter ',' csv header;
\copy messages from '~/uni/db/lab_01/csv/messages.csv' delimiter ',' csv header;

select count(*) as Number_of_elems from chat_rooms;
select count(*) as Number_of_elems from users;
select count(*) as Number_of_elems from participants;
select count(*) as Number_of_elems from messages;

-- insert into messages (id, snd_person, room_id, user_id, message, timestamp) values (1001, 2, 23, 43, 'Now', 1123123122), 
--                             (1002, 2, 23, 43, 'how', 1123123122), 
--                             (1003, 2, 23, 43, 'where', 1123123122);
                        
select * from messages;