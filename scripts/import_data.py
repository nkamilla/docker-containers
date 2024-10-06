# Import danych do PostgreSQL
import pandas as pd
from sqlalchemy import create_engine

# Ustawienie połączenia z PostgreSQL
engine = create_engine('postgresql://postgres:postgres@localhost:5432/movielens')

# Wczytanie danych do Pandas
movies = pd.read_csv('ml-latest-small/movies.csv')
ratings = pd.read_csv('ml-latest-small/ratings.csv')

# Import plików do PostgreSQL
movies.to_sql('movies', engine, index=False, if_exists='replace')
ratings.to_sql('ratings', engine, index=False, if_exists='replace')