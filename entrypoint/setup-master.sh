#!/bin/sh
#ENVIRONMENT VARIABLES:
# $DB_MAXSCALE_USER
# $DB_MAXSCALE_PASS
# $DB_HOSTNAME
# $DB_PORT
# $DB_ROOT_USER
# $DB_ROOT_PASS
# $DB_SLAVE_USER
# $DB_SLAVE_PASS
#Default values:
DB_ROOT_USER=${DB_ROOT_USER:-root}
DB_PORT=${DB_PORT:-3306}
DB_SLAVE_USER=${DB_SLAVE_USER:-repl}
DB_SLAVE_PASS=${DB_SLAVE_PASS:-slavepass}

if [ ! -z ${DB_MAXSCALE_USER+x} ] && [ ! -z ${DB_MAXSCALE_PASS+x} ]; then
wait-for-it.sh $DB_HOSTNAME:${DB_PORT} -s -- mysql\
     -h$DB_HOSTNAME\
     -u$DB_ROOT_USER\
     -p$DB_ROOT_PASS\
     -vvv\
     -e"CREATE USER '$DB_MAXSCALE_USER'@'%' IDENTIFIED BY '${DB_MAXSCALE_PASS}'; "

wait-for-it.sh $DB_HOSTNAME:${DB_PORT} -s -- mysql
     -h$DB_HOSTNAME\
     -u$DB_ROOT_USER\
     -p$DB_ROOT_PASS\
     -vvv\
     -e"GRANT SELECT ON mysql.user TO '$DB_MAXSCALE_USER'@'%';"
    
wait-for-it.sh $DB_HOSTNAME:${DB_PORT} -s -- mysql\
     -h$DB_HOSTNAME\
     -u$DB_ROOT_USER\
     -p$DB_ROOT_PASS\
     -vvv\
     -e"GRANT SELECT ON mysql.db TO '$DB_MAXSCALE_USER'@'%';"

wait-for-it.sh $DB_HOSTNAME:${DB_PORT} -s -- mysql\
     -h$DB_HOSTNAME\
     -u$DB_ROOT_USER\
     -p$DB_ROOT_PASS\
     -vvv\
     -e"GRANT SELECT ON mysql.tables_priv to '$DB_MAXSCALE_USER'@'%';"

wait-for-it.sh $DB_HOSTNAME:${DB_PORT} -s -- mysql\
     -h$DB_HOSTNAME\
     -u$DB_ROOT_USER\
     -p$DB_ROOT_PASS\
     -vvv\
     -e"GRANT SHOW databases ON *.* to '$DB_MAXSCALE_USER'@'%';"
fi

wait-for-it.sh $DB_HOSTNAME:${DB_PORT} -s -- mysql\
     -h$DB_HOSTNAME\
     -u$DB_ROOT_USER\
     -p$DB_ROOT_PASS\
     -vvv\
     -e"GRANT REPLICATION SLAVE ON *.* TO $DB_SLAVE_USER'@'%' IDENTIFIED BY '${DB_SLAVE_PASS}'"

wait-for-it.sh $DB_HOSTNAME:${DB_PORT} -s -- mysql\
     -h$DB_HOSTNAME\
     -u$DB_ROOT_USER\
     -p$DB_ROOT_PASS\
     -vvv\
     -e"SHOW MASTER STATUS\G"

