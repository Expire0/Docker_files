**Docker Compose Commands:**
```bash
docker-compose ps
docker-compose stop
docker-compose start
docker-compose down
docker-compose up
docker-compose up -d
docker-compose logs
docker-compose up --scale <servicename=num>
docker-compose up --build
docker-compose exec <serviceName> <command>
docker-compose logs airflow_scheduler



**Cleaning Metadata in PostgreSQL:**
```sql
# Connect to PostgreSQL database
docker-compose exec postgres psql -U postgres

# Switch to your Airflow metadata database
\c your_database_name
\dt list all tables

# Truncate all tables (CAUTION: This will delete all data)
TRUNCATE TABLE your_table_name CASCADE;

# Exit from PostgreSQL
\q


