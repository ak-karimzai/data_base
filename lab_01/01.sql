DROP DATABASE IF EXISTS chat_room;
CREATE database chat_room;
\c chat_room;

CREATE TABLE chat_rooms
(
    id INT NOT NULL,
    room_name TEXT NULL,
    capacity INT,
    password TEXT
);

CREATE TABLE users
(
    id INT NOT NULL,
    username TEXT NOT NULL,
    password TEXT NOT NULL,
    email TEXT,
    gender varchar(1),
    age INT
);

CREATE TABLE Messages
(
    id INT NOT NULL,
    room_id INT NOT NULL,
    user_id INT NOT NULL,
    message TEXT,
    timestamp BIGINT
);

CREATE TABLE participants
(
    id INT NOT NULL,
    room_id INT NOT NULL,
    user_id INT NOT NULL
);