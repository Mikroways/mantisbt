# Mantis bug tracker on docker

Simple run docker-compose up with the following yml definition:

```yml
version: '2'
volumes: 
  mantis-db:
services:
  mantis:
    image: mikroways/mantis
    environment:
      MANTIS_ENABLE_ADMIN: 1
      MANTIS_CONFIG: |
        $$g_hostname = 'db';
        $$g_db_type = 'mysqli';
        $$g_database_name = 'mantis';
        $$g_db_username = 'root';
        $$g_db_password = 'mantis';
        $$g_crypto_master_salt='xxxx';
        $$g_log_level = LOG_EMAIL | LOG_EMAIL_RECIPIENT;
        $$g_log_destination = '';
        $$g_show_detailed_errors = ON;
    ports:
      - "8080:80"
  db:
    image: mysql:5.7
    volumes:
    - mantis-db:/var/lib/mysql
    environment:
      MYSQL_ROOT_PASSWORD: mantis
      MYSQL_DATABASE: mantis
```

Please set `g_crypto_master_salt` to a value obtained by running:

```bash
cat /dev/urandom | head -c 64 | base64
```

And after creating this file, you are done to begin installation:

## Installation

Run with the above configuration:

```bash
docker-compose up 
```

And point your browser at http://localhost:8080/admin/install.php

Follow installation instructions, and you are done!

The default administrator user is **administrator** / **root**

## Using the installed image

Edit the configuration file provided above removing the following values:

* Delete `MANTIS_ENABLE_ADMIN` environment variable
* Remove `g_show_detailed_errors` from `MANTIS_CONFIG` environment variable

Test your installatio` environment variable
* Remove `g_show_detailed_errors` from `MANTIS_CONFIG` environment variable

Test your installation. Enjoy!

