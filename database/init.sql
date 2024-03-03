CREATE DATABASE clarustodo;

\c cloudnice;

CREATE TABLE todo(
    todo_id SERIAL PRIMARY KEY,
    description VARCHAR(255)
);
