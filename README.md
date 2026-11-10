# DevOps Assessment: Terraform + Database Reliability

## 1. Project Overview

This project demonstrates infrastructure provisioning using Terraform and database reliability practices using PostgreSQL.

The solution includes:
- AWS infrastructure design using Terraform.
- Separate Dev and Prod environments.
- Application Load Balancer and ECS Fargate.
- Private PostgreSQL RDS database.
- Local PostgreSQL deployment using Docker Compose.
- Database schema, seed data, and indexing.
- Query performance analysis using EXPLAIN ANALYZE.
- Database backup and restore scripts.

**Note:** This assessment prepares and validates Terraform plans. No AWS resources are deployed.

## 2. Architecture

### AWS Infrastructure

Internet → Application Load Balancer → ECS Fargate → Private RDS PostgreSQL

- VPC with public and private subnets across two Availability Zones.
- Internet Gateway for public subnet connectivity.
- NAT Gateway for private subnet outbound connectivity.
- Application Load Balancer in public subnets.
- ECS Fargate tasks in private subnets.
- RDS PostgreSQL in private subnets.
- Security groups restrict application traffic and database access.
- CloudWatch log group for ECS application logs.

### Security

- ALB accepts HTTP traffic on port 80.
- ECS accepts application traffic only from the ALB security group.
- RDS accepts PostgreSQL traffic on port 5432 only from the ECS security group.
- RDS is not publicly accessible.
- Database passwords are supplied through Terraform environment variables.

## 3. Environment Configuration

| Configuration | Dev | Prod |
|---|---|---|
| ECS desired count | 1 | 2 |
| Fargate CPU | 256 | 512 |
| Fargate memory | 512 MB | 1024 MB |
| RDS instance | db.t3.micro | db.t3.small |
| Storage | 20 GB | 50 GB |
| Backup retention | 1 day | 7 days |
| Multi-AZ | Disabled | Enabled |
| Deletion protection | Disabled | Enabled |
| Log retention | 7 days | 30 days |

Each environment uses a separate local Terraform state path:
- `infra/envs/dev/terraform.tfstate`
- `infra/envs/prod/terraform.tfstate`

For a real team deployment, configure remote S3 state with separate keys and state locking.

## 4. Database Setup

PostgreSQL 16 is deployed locally using Docker Compose.

Start the database:

```powershell
docker compose up -d
```

Database details:
- Database: `hotel_booking`
- Username: `admin`
- Port: `5432`

### Database Tables

**hotel_bookings**
- id
- org_id
- hotel_id
- city
- checkin_date
- checkout_date
- amount
- status
- created_at

**booking_events**
- id
- booking_id
- event_type
- payload (JSONB)
- created_at

### Seed Data

The seed script creates:
- 120 hotel bookings.
- Five cities.
- Five organizations.
- Multiple booking statuses.
- 80 booking event records.

Apply migrations and seed data:

```powershell
Get-Content .\database\migrations\001_create_tables.sql -Raw | docker exec -i devops-postgres psql -U admin -d hotel_booking

Get-Content .\database\seed\001_seed_data.sql -Raw | docker exec -i devops-postgres psql -U admin -d hotel_booking

Get-Content .\database\migrations\002_add_indexes.sql -Raw | docker exec -i devops-postgres psql -U admin -d hotel_booking
```

## 5. Database Indexing and Query Optimization

The following indexes are created:

```sql
CREATE INDEX IF NOT EXISTS idx_hotel_bookings_city_created_at
ON hotel_bookings (city, created_at);

CREATE INDEX IF NOT EXISTS idx_hotel_bookings_org_status
ON hotel_bookings (org_id, status);

CREATE INDEX IF NOT EXISTS idx_booking_events_booking_id
ON booking_events (booking_id);
```

### Business Query

```sql
SELECT
    org_id,
    status,
    COUNT(*),
    SUM(amount)
FROM hotel_bookings
WHERE city = 'delhi'
  AND created_at >= NOW() - INTERVAL '30 days'
GROUP BY org_id, status;
```

### Performance Analysis

The query was tested using:

```sql
EXPLAIN ANALYZE
SELECT
    org_id,
    status,
    COUNT(*),
    SUM(amount)
FROM hotel_bookings
WHERE city = 'delhi'
  AND created_at >= NOW() - INTERVAL '30 days'
GROUP BY org_id, status;
```

Observed execution time was approximately 0.237 ms on the local test dataset.

PostgreSQL selected a sequential scan because the dataset contained only 120 rows. This is reasonable for a small dataset; the composite index is intended to support filtering as the table grows.

## 6. Database Backup and Restore

Backup script:

```bash
./scripts/backup.sh
```

The backup script:
- Creates a backups directory.
- Generates a timestamped SQL dump.
- Uses `pg_dump` to export the database.

Restore script:

```bash
./scripts/restore.sh ./backups/hotel_booking_YYYYMMDD_HHMMSS.sql
```

The restore script:
- Checks that the backup file exists.
- Creates a fresh restore database.
- Restores the SQL dump into `hotel_booking_restore`.

Both scripts were tested successfully. The restored database contained 120 bookings and 80 events.

On Windows, the scripts can be executed using Git Bash:

```powershell
& "C:\Program Files\Git\bin\bash.exe" ./scripts/backup.sh

& "C:\Program Files\Git\bin\bash.exe" ./scripts/restore.sh ./backups/hotel_booking_YYYYMMDD_HHMMSS.sql
```

## 7. Terraform Validation

Terraform version used: 1.12.1

AWS provider version used: 5.100.0

Commands:

```powershell
terraform fmt -recursive
terraform init
terraform validate
terraform plan -refresh=false
```

Both Dev and Prod plans completed successfully.

Expected plan summary for each environment:

```text
Plan: 31 to add, 0 to change, 0 to destroy.
```

Provider credential-check skipping is configured for assessment-only planning. This does not grant AWS access or permit deployment. Real deployment requires valid AWS credentials and production-ready provider configuration.

**Do not run terraform apply as part of this assessment validation.**

## 8. Project Structure

```text
devops-assessment/
├── infra/
│   ├── modules/
│   │   ├── network/
│   │   ├── ecs/
│   │   └── rds/
│   └── envs/
│       ├── dev/
│       └── prod/
├── database/
│   ├── migrations/
│   └── seed/
├── scripts/
│   ├── backup.sh
│   └── restore.sh
├── docker-compose.yml
├── .gitignore
└── README.md
```

## 9. Conclusion

This assessment demonstrates reusable Terraform modules, environment separation, AWS infrastructure design, database schema management, indexing, query analysis, and tested backup and restore procedures.

The infrastructure was formatted, initialized, validated, and planned without deploying resources to AWS.