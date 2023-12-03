#!/usr/bin/env sh
SECRET_JSON=$(aws secretsmanager get-secret-value --secret-id $SECRET_KEY --query 'SecretString' --output text)
ENV_VARS=$(echo $SECRET_JSON | jq -r 'to_entries[] | "\(.key)=\(.value)"')

# Set the environment variables
eval $ENV_VARS
export HYDRA_PASSWORD=$HYDRA_PASSWORD
export STORY_PASSWORD=$STORY_PASSWORD

sql_dir="/home/gola/sql"

# Iterate through SQL files in the directory
for sql_file in "$sql_dir"/*.sql; do
  if [ -f "$sql_file" ]; then
    # Run envsubst
    envsubst < "$sql_file" > "${sql_file}.tmp"

    # Check the exit status of envsubst
    if [ $? -ne 0 ]; then
      echo "Unable to substitute variables in $sql_file"
      exit 1
    fi

    # Rename the temporary file back to the original name
    mv "${sql_file}.tmp" "$sql_file"
  fi
done

# Run flyway migration
/home/gola/flyway -url=jdbc:postgresql://"${DB_HOST}":"${DB_PORT}"/"${DB_NAME}" -schemas="${DB_NAME}" -user="${DB_USER}" -password="${POSTGRES_PASSWORD}" -connectRetries=60 -mixed=true migrate

if [ $? -ne 0 ]; then
    echo "Flyway migration failed"
    exit 1
fi

exit 0
