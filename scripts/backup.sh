
#!/bin/bash
set -euo pipefail

# Create backup directory
BACKUP_DIR="./backups"
mkdir -p "$BACKUP_DIR"

# Generate timestamp
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

# Backup PostgreSQL database from Docker container
BACKUP_FILE="$BACKUP_DIR/hotel_booking_$TIMESTAMP.sql"

docker exec devops-postgres pg_dump -U admin -d hotel_booking > "$BACKUP_FILE"

echo "Database backup completed successfully!"
echo "Backup file: $BACKUP_FILE"
