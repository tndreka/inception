#!/bin/bash

set -e

echo "Starting Maria_db initialization . . ."

for i in {30..0}; do
    if mysqladmin ping &>/dev/null; then
        break
    fi
    sleep 1
done

if ["$i" = 0]; then
    echo "Maria_db failed to start ! ! ! "
    exit 1
fi
    echo "Maria_db READYY ! ! ! "