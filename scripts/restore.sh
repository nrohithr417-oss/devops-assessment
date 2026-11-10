
#!/bin/bash
set -euo pipefail

if [ "$#" -ne 1 ]; then
    echo "Usage: ./scripts/restore.sh <backup-file>"
    exit 1
fi

BACKUP_FILE="$1"
RESTORE_DB="hotel_booking_restore"

if [ ! -f "$BACKUP_FILE" ]; then
    echo "Backup file not found: $BACKUP_FILE"
    exit 1
fi

# Recreate a fresh restore database
docker exec devops-postgres psql -U admin -d postgres \
    -c "DROP DATABASE IF EXISTS $RESTORE_DB WITH (FORCE);"

docker exec devops-postgres psql -U admin -d postgres \
    -c "CREATE DATABASE $RESTORE_DB;"

# Restore backup into the fresh database
docker exec -i devops-postgres psql -U admin -d "$RESTORE_DB" \
    < "$BACKUP_FILE"

echo "Database restored successfully into $RESTORE_DB"
