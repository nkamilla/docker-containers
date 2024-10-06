CREATE TABLE movies (
	movieId INT PRIMARY KEY,
	title VARCHAR(255),
	genres VARCHAR(255)
);

CREATE TABLE ratings (
	userID INT,
	movieId INT,
	rating DECIMAL,
	timestamp BIGINT
);

COPY movies(movieId, title, genres)
FROM '/docker-entrypoint-initdb.d/movies.csv'
DELIMITER ','
CSV HEADER;

COPY ratings(userId, movieId, rating, timestamp)
FROM '/docker-entrypoint-initdb.d/ratings.csv'
DELIMITER ','
CSV HEADER;