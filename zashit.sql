SELECT chat_rooms.id, room_name
from chat_rooms
    JOIN participants as p on chat_rooms.id = p.user_id
    JOIN users as u on p.user_id = u.id
where user_id between 100 and 100000 and
    room_name like 'N%';