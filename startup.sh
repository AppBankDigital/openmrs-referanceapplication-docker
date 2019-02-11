#!/bin/bash -eux
# Modified from https://github.com/openmrs/openmrs-sdk/

# For runtime-setup actions only (i.e. actions that require access to runtime environment variables). 
# Buildtime actions should go in the dockerfile.

DB_CREATE_TABLES=${DB_CREATE_TABLES:-false}
DB_AUTO_UPDATE=${DB_AUTO_UPDATE:-false}
MODULE_WEB_ADMIN=${MODULE_WEB_ADMIN:-true}
DEBUG=${DEBUG:-false}

cat > /usr/local/tomcat/openmrs-runtime.properties << EOF
install_method=auto
connection.url=jdbc\:mysql\://${DB_HOST}\:3306/${DB_DATABASE}?autoReconnect\=true&sessionVariables\=default_storage_engine\=InnoDB&useUnicode\=true&characterEncoding\=UTF-8
connection.username=${DB_USERNAME}
connection.password=${DB_PASSWORD}
has_current_openmrs_database=true
create_database_user=false
module_web_admin=${MODULE_WEB_ADMIN}
create_tables=${DB_CREATE_TABLES}
auto_update_database=${DB_AUTO_UPDATE}
admin_user_password=${OPENMRS_ADMIN_PASSWORD}
EOF

# Stall until DB becomes available

echo "[STARTUP.sh] Waiting for DB to become available..."
while :
    do
        (echo > /dev/tcp/${DB_HOST}/3306) >/dev/null 2>&1
        result=$?
        if [[ $result -eq 0 ]]; then
            echo "[STARTUP.sh] Verified DB availability"
            break
        fi
        sleep 1
    done

# Start tomcat in background
/usr/local/tomcat/bin/catalina.sh run

# # trigger first filter to start data importation
# sleep 15
# curl -L http://localhost:8080/openmrs/ > /dev/null
# sleep 15

# # bring tomcat process to foreground again
# wait ${!}
