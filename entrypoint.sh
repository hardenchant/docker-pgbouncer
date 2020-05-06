#!/bin/bash
set -e

# make sure pgbouncer runs without custom config or with default entrypoint
if [[ "$1" = 'pgbouncer /etc/pgbouncer/pgbouncer.ini' ]]; then
    TEMPLATE_PATH="/pgbouncer_template.ini"

    CONFIG_FOLDER_PATH='/etc/pgbouncer'
    CONFIG_PATH="${CONFIG_FOLDER_PATH}/pgbouncer.ini"
    USERLIST_PATH="${CONFIG_FOLDER_PATH}/userlist.txt"

    # check required environments
    if [[ -z "${DB_HOST}" ]]; then
        echo "DB_HOST env not set"
        error=true
    fi
    if [[ -z "${DB_USER}" ]]; then
        echo "DB_USER env not set"
        error=true
    fi
    if [[ -z "${DB_PASS}" ]]; then
        echo "DB_PASS env not set"
        error=true
    fi
    if [[ ! -z "${error}" ]]; then
        echo "Initialization error"
        exit 1
    fi

    cp ${TEMPLATE_PATH} ${CONFIG_PATH}

    # init template with environments
    sed -i "s/\$DB_HOST/${DB_HOST}/" ${CONFIG_PATH}
    sed -i "s/\$DB_PORT/${DB_PORT:=5432}/" ${CONFIG_PATH}

    sed -i "s/\$DB_USER/${DB_USER}/" ${CONFIG_PATH}
    sed -i "s/\$DB_PASS/${DB_PASS}/" ${CONFIG_PATH}

    sed -i "s/\$PGBOUNCER_HOST/${PGBOUNCER_HOST:=0.0.0.0}/" ${CONFIG_PATH}
    sed -i "s/\$PGBOUNCER_PORT/${PGBOUNCER_PORT:=5432}/" ${CONFIG_PATH}

    sed -i "s/\$MAX_CLIENT_CONN/${MAX_CLIENT_CONN:=3000}/" ${CONFIG_PATH}
    sed -i "s/\$POOL_SIZE/${POOL_SIZE:=70}/" ${CONFIG_PATH}

    # add untrust user
    echo "\"${DB_USER}\" \"\"" > ${USERLIST_PATH}

    # cleanup sensitive environments
    unset DB_NAME
    unset DB_HOST
    unset DB_USER
    unset DB_PASS
    unset PGBOUNCER_HOST
    unset PGBOUNCER_PORT
    unset MAX_CLIENT_CONN
    unset POOL_SIZE

    exec pgbouncer /etc/pgbouncer/pgbouncer.ini
fi

exec "$@"
