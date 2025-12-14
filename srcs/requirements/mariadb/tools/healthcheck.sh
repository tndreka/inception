#!/bin/bash
MYSQL_PASSWORD=$(cat /run/secrets/db_password)
mysqladmin ping -h localhost -u${MYSQL_USER} -p${MYSQL_PASSWORD}
