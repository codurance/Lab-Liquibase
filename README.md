# Setup

To start laboratory stack:
``` bash
docker-compose up -d
```
To enter specific service shell:
```bash
docker-compose exec <service-name> sh
```
To destroy the lab 
```
docker-compose down
```
# Accessing PgAdmin page

To access PgAdmin go to http://localhost:5050

Default credentials:
```
username: pgadmin4@pgadmin.org
password: admin
```

# Adding Postgres container to PgAdmin

```
Hostname: postgres
Port: 5432
Username: pg_user
Password: pg_password
```

# Executing liquibase commands

To execute commands for Liquibase
```bash
docker-compose run --rm liquibase <command-name>
```
## Updates
To perform full update use this command:
```bash
docker-compose run --rm liquibase --defaultsFile=/liquibase/changelog/liquibase.properties update
```
To update to specific tag:
```bash
docker-compose run --rm liquibase --defaultsFile=/liquibase/changelog/liquibase.properties updateToTag <tag>
```
## Rollbacks
To perform rollback based on count of changeset:
```bash
docker-compose run --rm liquibase --defaultsFile=/liquibase/changelog/liquibase.properties rollbackCount <value>
```
To perform rollback to specific tag:
```bash
docker-compose run --rm liquibase --defaultsFile=/liquibase/changelog/liquibase.properties rollback <tag>
```
## Clearing checksums
If changes are made to the changesets that were already applied to DB, Liquibase will throw CheckSum error, to solve this issue use:
```bash
docker-compose run --rm liquibase --defaultsFile=/liquibase/changelog/liquibase.properties clearCheckSums
```
DO NOT USE IN PRODUCTION DB

## Generating snapshots as files in local environment
To generate the snapshot file on local drive path for the file must point to mounted volume
```bash
docker-compose run --rm liquibase --defaultsFile=/liquibase/changelog/liquibase.properties snapshot --outputFile=changelog/masterSnapshot.json
```

## Performing diff from two snapshots
```bash
/liquibase/liquibase --referenceUrl="offline:postgresql?snapshot=<path-to-snapshot>" --url="offline:postgresql?snapshot=<path-to-snapshot>" diff
```