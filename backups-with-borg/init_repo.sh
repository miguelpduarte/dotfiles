#!/usr/bin/env sh

# Should only need to be done once, but documenting for the future

BACKUP_DRIVE_BORG_PATH="/run/media/miguel/xps-backups/borg"

borg init -e repokey "$BACKUP_DRIVE_BORG_PATH"
