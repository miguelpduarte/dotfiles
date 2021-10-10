#!/usr/bin/env sh

# !! Should be run as root otherwise we will be unable to backup /etc/ and /var/lib fully

# Based on https://www.reddit.com/r/linux4noobs/comments/7t3au8/what_do_you_use_as_a_backup_solution_for_linux/dta6ebv/
# And https://borgbackup.readthedocs.io/en/stable/quickstart.html#automating-backups

BACKUP_DRIVE_BORG_PATH="/run/media/miguel/xps-backups/borg"
BORG_REPOSITORY="$BACKUP_DRIVE_BORG_PATH"
TAG="miguel-xps" # This is also the hostname actually hmm

# some helpers and error handling:
info() { printf "\n%s %s\n\n" "[$(date)]" "$*" >&2; }
trap 'echo $( date ) Backup interrupted >&2; exit 2' INT TERM

info "Starting backup"

#    --list \ # A bit too verbose I think...
# Instead using --progress since we've now seen that the data is being backed up correctly
borg create -v --stats \
    --filter=AME \
    --progress \
    --show-rc \
    --exclude-caches \
    --exclude '/home/lost+found' \
    --exclude '/home/*/.cache/*' \
    --exclude '/home/*/.local/share/Steam/*' \
    --exclude '/home/*/.local/share/lutris/*' \
    --exclude '/home/*/.config/Slack/cache/*' \
    --exclude '/home/*/.gvfs' \
    --exclude '/home/*/.thumbnails' \
    \
    "$BORG_REPOSITORY::$TAG-{now}" \
    /home/ \
    /etc/ \
    /opt/ \
    /var/lib/ \
    /root/
    # --compression lz4 \ # this is the default

backup_exit=$?


info "Starting repository pruning"

# Prune to maintain 7 daily, 4 weekly and 12 monthly archives of this machine.
# The "$TAG-" prefix is very important to limit prune's operation to this 
# machine's archives and not apply to other machine's archives also.
# (This means not that the last 7 archives in a day will be kept, but that daily archives will be kept for up to 7 days, which is not obvious at first. Check the docs for more details and an example: https://borgbackup.readthedocs.io/en/stable/usage/prune.html )
borg prune -v --list --stats --prefix "$TAG-" --show-rc \
    --keep-hourly 2 \
    --keep-daily 7 \
    --keep-weekly 4 \
    --keep-monthly 12 \
    "$BORG_REPOSITORY" 

prune_exit=$?

# use highest exit code as global exit code
global_exit=$(( backup_exit > prune_exit ? backup_exit : prune_exit ))

if [ ${global_exit} -eq 0 ]; then
    info "Backup and Prune finished successfully"
elif [ ${global_exit} -eq 1 ]; then
    info "Backup and/or Prune finished with warnings"
else
    info "Backup and/or Prune finished with errors"
fi

exit ${global_exit}

