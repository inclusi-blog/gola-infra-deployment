#!/usr/bin/env sh
SECRET_JSON=$(aws secretsmanager get-secret-value --secret-id $SECRET_KEY --query 'SecretString' --output text)
ENV_VARS=$(echo $SECRET_JSON | jq -r 'to_entries[] | "\(.key)=\(.value)"')

# Set the environment variables
eval $ENV_VARS

sql_dir="/home/gola/sql"

# Iterate through SQL files in the directory
for sql_file in "$sql_dir"/*.sql; do
  if [ -f "$sql_file" ]; then
    # Run envsubst
    envsubst < "$sql_file" > "${sql_file}.tmp"

    # Rename the temporary file back to the original name
    mv "${sql_file}.tmp" "$sql_file"
  fi
done

if [ $? -eq 0 ]; then
    /home/gola/flyway -url=jdbc:postgresql://"${DB_HOST}":"${DB_PORT}"/"${DB_NAME}" -schemas="${DB_NAME}" -user="${DB_USER}" -password="${DEV_DB_POSTGRES_PASSWORD}" -connectRetries=60 -mixed=true migrate
else
    echo "Unable to substitute credentials"
    exit 1
fi