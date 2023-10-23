-- Create the hydra user and database
CREATE USER hydra WITH PASSWORD '$HYDRA_PASSWORD';
CREATE DATABASE hydra WITH OWNER hydra;
GRANT ALL PRIVILEGES ON DATABASE hydra TO hydra;

-- Create the story user and database
CREATE USER "story" WITH PASSWORD '$STORY_PASSWORD';
CREATE DATABASE "story" WITH OWNER "story";
GRANT ALL PRIVILEGES ON DATABASE "story" TO "story";


CREATE EXTENSION IF NOT EXISTS dblink;
