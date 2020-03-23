# OpenMRS Reference Application Production Docker Images

Docker images for the OpenMRS Reference Application intended for production use.

## Example Docker Compose

Create the following `docker-compose.yml`:

```
version: '2'

services:
  db:
    image: mysql:5.6
    command:
      - --character-set-server=utf8
      - --collation-server=utf8_general_ci
    environment:
      MYSQL_ROOT_PASSWORD: "password"
      MYSQL_DATABASE: "openmrs"

  refapp:
    depends_on:
      - db
    image: isears/openmrs-referenceapplication-docker:latest
    links:
      - db:database
    ports:
      - 8080:8080
    environment:
      DB_HOST: database
      DB_DATABASE: "openmrs"
      DB_USERNAME: "root"
      DB_PASSWORD: "password"
      DB_CREATE_TABLES: "true"
      DB_AUTO_UPDATE: "false"
      MODULE_WEB_ADMIN: "false"
      OPENMRS_ADMIN_PASSWORD: "MyCustomPassword123"
      TZ: "America/New_York"
```

Then run `docker-compose up` in the same directory.

Downloaed assets from:https://ci.openmrs.org/browse/REFAPP-OMODDISTRO-9694

## Differences Between Production Images and SDK Images

OpenMRS already provides non-production docker images here: https://hub.docker.com/r/openmrs/openmrs-reference-application-distro

The images provided here are different in that they are intended for production use. Specifically:
- Users can set the OpenMRS Admin password using the OPENMRS_ADMIN_PASSWORD variable
- The tomcat server does not run in debug mode

## Acknowledgements

Most of this code is shamelessly stolen from @cintiadr and her work on the OpenMRS SDK docker images: https://github.com/openmrs/openmrs-sdk
