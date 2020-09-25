#!/bin/bash
# Modified from https://github.com/openmrs/openmrs-sdk/

# For runtime-setup actions only (i.e. actions that require access to runtime environment variables). 
# Buildtime actions should go in the dockerfile.

DB_CREATE_TABLES=${DB_CREATE_TABLES:-false}
DB_AUTO_UPDATE=${DB_AUTO_UPDATE:-false}
MODULE_WEB_ADMIN=${MODULE_WEB_ADMIN:-true}
DEBUG=${DEBUG:-false}

cat > /usr/local/tomcat/openmrs-server.properties << EOF
install_method=auto
connection.url=jdbc\:mysql\://database\:3306/openmrs?autoReconnect\=true&sessionVariables\=default_storage_engine\=InnoDB&useUnicode\=true&characterEncoding\=UTF-8
connection.username=${DB_USERNAME}
connection.password=${DB_PASSWORD}
has_current_openmrs_database=true
create_database_user=false
module.allow_web_admin=${MODULE_WEB_ADMIN}
create_tables=${DB_CREATE_TABLES}
auto_update_database=false
admin_user_password=${OPENMRS_ADMIN_PASSWORD}
EOF

# Stall until DB becomes available
while true
do
    (echo > /dev/tcp/${DB_HOST}/3306) >/dev/null 2>&1
    result=$?
    if [[ $result -eq 0 ]]; then
        break
    fi
    sleep 1
done

#report module fix for 2.11
echo "SET GLOBAL sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''))" | docker exec -i safehandsdb /usr/bin/mysql -u root --password=password openmrs

# Start tomcat in background
/usr/local/tomcat/bin/catalina.sh run &

# trigger first filter to start data importation
sleep 15
curl -L http://localhost:8080/openmrs/ > /dev/null
sleep 15

# bring tomcat process to foreground again
wait ${!}
