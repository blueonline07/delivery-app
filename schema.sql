CREATE DATABASE test_db;

\c test_db; -- Connect to the database

CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100),
  age INT,
  country VARCHAR(100),
  role VARCHAR(100)
);

INSERT INTO users (name, age, country, role) VALUES
('John Doe', 28, 'USA', 'Developer'),
('Jane Smith', 34, 'Canada', 'Designer'),
('Sam Wilson', 25, 'UK', 'Manager'),
('Lucy Brown', 30, 'Australia', 'Analyst');
INSERT INTO users (name, age, country, role) VALUES
('Alice Johnson', 29, 'USA', 'Developer'),
('Bob Martin', 32, 'Canada', 'Designer'),
('Charlie Lee', 27, 'UK', 'Manager'),
('Diana Prince', 31, 'Australia', 'Analyst'),
('Ethan Hunt', 26, 'USA', 'Developer'),
('Fiona Gallagher', 33, 'Canada', 'Designer'),
('George Clooney', 28, 'UK', 'Manager'),
('Hannah Montana', 30, 'Australia', 'Analyst'),
('Ian Somerhalder', 29, 'USA', 'Developer'),
('Jack Sparrow', 34, 'Canada', 'Designer'),
('Karen Gillan', 25, 'UK', 'Manager'),
('Liam Neeson', 30, 'Australia', 'Analyst'),
('Megan Fox', 28, 'USA', 'Developer'),
('Nina Dobrev', 32, 'Canada', 'Designer'),
('Oscar Isaac', 27, 'UK', 'Manager'),
('Penelope Cruz', 31, 'Australia', 'Analyst'),
('Quentin Tarantino', 26, 'USA', 'Developer'),
('Rachel McAdams', 33, 'Canada', 'Designer'),
('Steve Rogers', 28, 'UK', 'Manager'),
('Tony Stark', 30, 'Australia', 'Analyst');
