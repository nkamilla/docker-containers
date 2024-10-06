# MovieLens Data Analysis with Docker and PostgreSQL

## Overview

This project sets up a data analysis environment using Docker. It includes two containers:
1. A **PostgreSQL** database to store the MovieLens dataset.
2. A **Jupyter Notebook** container for running Python-based data analysis.

The dataset used is the MovieLens dataset (ml-latest-small), which contains information about movies, users, and ratings.

## Requirements

- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/install/)

## Setup Instructions

### 1. Clone the repository

```bash
git clone https://github.com/nkamilla/docker-containers.git
cd docker-containers
```

### 2. Download the MovieLens Dataset

Download the latest MovieLens dataset from [here](https://grouplens.org/datasets/movielens/latest/) (ml-latest-small.zip), extract it, and place the extracted `ml-latest-small` directory into the `data/` folder in the project root.

### 3. Build and Run Containers

To build and run the Docker containers, use the following command:

```bash
docker-compose up --build
```

This will:
- Set up a **PostgreSQL** container running the database.
- Set up a **Jupyter Notebook** container for running data analysis.

### 4. Access Jupyter Notebook

Once the containers are up and running, open a browser and go to:

```
http://localhost:8888
```

Jupyter Notebook will be accessible from this URL. You can create new notebooks or open existing ones.

### 5. Import Data to PostgreSQL

In the Jupyter Notebook, run the `import_data.py` script to import the MovieLens data into PostgreSQL:

```bash
!python /home/nkamill/scripts/import_data.py
```

This will load the `movies.csv` and `ratings.csv` data into the PostgreSQL database.

### 6. Query Data Using SQL

You can now run SQL queries to analyze the data. Below are some example queries that were used in the analysis:

#### Example SQL Queries

1. **How many movies are in the dataset?**
movies_count = pd.read_sql('SELECT COUNT(*) FROM movies;', engine)
print(movies_count.iloc[0, 0])

2. **What is the most frequent movie genre?**
genres = pd.read_sql('SELECT genres FROM movies;', engine)
all_genres = genres['genres'].str.split('|', expand=True).stack().value_counts()
print(f'Najczęściej występujący gatunek: {all_genres.index[0]}')
3. **What are the top 10 highest-rated movies?**
   top_rated_movies = pd.read_sql('''
  SELECT m.title, AVG(r.rating) as avg_rating
  FROM ratings r
  JOIN movies m ON r."movieId" = m."movieId"
  GROUP BY m.title
  ORDER BY avg_rating DESC
  LIMIT 10;
''', engine)
print(f"10 najwyżej oceniach filmów:\n{top_rated_movies}")

4. **Who are the top 5 users by number of ratings?**
   top_users = pd.read_sql('''
  SELECT "userId", COUNT(*) as ratings_count
  FROM ratings
  GROUP BY "userId"
  ORDER BY ratings_count DESC
  LIMIT 5;
''', engine)
print(f"5 użytkowników z największą liczbą ocen:\n{top_users}")

5. **When was the first and last rating made and what were the rated movies?**
  first_last_rating = pd.read_sql('''
      WITH first_last_ratings AS (
        SELECT
            "movieId",
            MIN(timestamp) AS first_rating,
            MAX(timestamp) AS last_rating
        FROM ratings
        GROUP BY "movieId"
    )
    SELECT
        m.title,
        TO_TIMESTAMP(flr.first_rating) AS first_rating_date,
        TO_TIMESTAMP(flr.last_rating) AS last_rating_date
    FROM first_last_ratings flr
    JOIN movies m ON m."movieId" = flr."movieId"
    ORDER BY flr.first_rating ASC, flr.last_rating DESC
    LIMIT 2;
''', engine)
print(f"Pierwsza i ostatnia ocena:\n{first_last_rating}")

6. **Find all movies released in 1990:**

   movies_1990 = pd.read_sql("SELECT title FROM movies WHERE title LIKE '%%(1990)%%';", engine)
print(f"Filmy z 1990 roku:\n{movies_1990}")

### 7. Shutting Down

To stop and remove the containers, run the following command:

```bash
docker-compose down
```

This will stop the running containers and remove them.

## Project Structure

```
в”њв”Ђв”Ђ data/
в”‚   в””в”Ђв”Ђ ml-latest-small/         # MovieLens dataset directory (after extraction)
в”њв”Ђв”Ђ notebooks/                   # Jupyter notebooks for analysis
в”њв”Ђв”Ђ Dockerfile                   # Dockerfile for the analytics container
в”њв”Ђв”Ђ docker-compose.yml           # Docker Compose file to run both PostgreSQL and Jupyter
в”њв”Ђв”Ђ import_data.py               # Python script to import data into PostgreSQL
в””в”Ђв”Ђ README.md                    # This file
```

## Notes

- Ensure that Docker and Docker Compose are installed on your system before running the project.
- The PostgreSQL database will be available on port `5432` (by default).
- The Jupyter Notebook will be accessible on port `8888`.

## License

This project is provided for educational purposes and is licensed under Kamilla
