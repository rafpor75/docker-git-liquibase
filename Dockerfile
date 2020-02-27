FROM openjdk:8-jre
LABEL maintainer Raffaele Porzio <r.porzio75@gmail.com>


# DB Drivers
# Install MariaDB (MySQL) and PostgreSQL JDBC Drivers for users that would like have them in the container

RUN apt-get update \
  && apt-get install -yq --no-install-recommends \
      libmariadb-java \
      libpostgresql-jdbc-java \
  && apt-get autoclean \
  && apt-get clean \
  && rm -rf /var/*/apt/*
RUN apt-get install bash 
RUN apt-get update && apt-get install -y git
RUN apt-get install curl
# /usr/share/java/mariadb-java-client.jar
# /usr/share/java/postgresql.jar


# Add the liquibase user and step in the directory
RUN adduser --system --home /liquibase --disabled-password --group liquibase
WORKDIR /liquibase

# Change to the liquibase user
USER liquibase

# Latest Liquibase Release Version
ARG LIQUIBASE_VERSION=3.8.7

# Download, install, clean up
RUN set -x \
  && curl -L https://github.com/liquibase/liquibase/releases/download/v${LIQUIBASE_VERSION}/liquibase-${LIQUIBASE_VERSION}.tar.gz | tar -xzf -

# Set liquibase to executable
RUN chmod 755 /liquibase

ENTRYPOINT ["/liquibase/liquibase"]
CMD ["--help"]

