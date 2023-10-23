DO $$
BEGIN
    IF NOT EXISTS (SELECT FROM pg_catalog.pg_user WHERE usename = 'hydra') THEN
        CREATE USER hydra WITH PASSWORD '$HYDRA_PASSWORD';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_database WHERE datname = 'hydra') THEN
        EXECUTE 'CREATE DATABASE hydra WITH OWNER hydra';
        EXECUTE 'GRANT ALL PRIVILEGES ON DATABASE hydra TO hydra';
    END IF;

    IF NOT EXISTS (SELECT FROM pg_catalog.pg_user WHERE usename = 'story') THEN
        CREATE USER "story" WITH PASSWORD '$STORY_PASSWORD';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_database WHERE datname = 'story') THEN
        EXECUTE 'CREATE DATABASE "story" WITH OWNER "story"';
        EXECUTE 'GRANT ALL PRIVILEGES ON DATABASE "story" TO "story"';
    END IF;
END $$;

CREATE EXTENSION IF NOT EXISTS dblink;
