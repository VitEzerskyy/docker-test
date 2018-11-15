version: '2'
services:

  pushilka-app:
    restart: always
    image: harbor.asqq.io/dev-images/pushilka-php-nginx:7.2-v1
    container_name: pushilka-app
    environment:
       - NGINX_DIR_INDEX=index.php
       - NGINX_HOST_ADMIN=pushilka.local
       - NGINX_ROOT=/var/www/pushilka/public
       - UID_VAR={{ UID_VALUE }}
       - GID_VAR={{ GID_VALUE }}
    networks:
       - pushilka_net
    working_dir: /var/www/pushilka
    ports:
       - "127.0.0.1:80:80"
    links:
       - db
       - pushilka-redis
    expose:
       - "80"
    volumes:
       - ../pushilka-app:/var/www/pushilka:cached

  pushilka-redis:
    image: redis:3.2
    container_name: pushilka-redis
    networks:
       - pushilka_net
  db:
    image: registry.wikrgroup.com:5001/postgresql/postgresql:10.4
    container_name: pushilka-db
    environment:
      PGDATA: /pgdata
      POSTGRES_DB: pushilka
      POSTGRES_USER: pushilka_usr
      POSTGRES_PASSWORD: 123qwe
    ports:
       - "5432:5432"
    expose:
       - "5432"
    volumes:
       - ../pushilka-pgdata:/pgdata

    networks:
       - pushilka_net

  adminer:
    container_name: pushilka-dbadminer
    image: adminer
    links:
       - db
    networks:
       - pushilka_net
    ports:
       - "8080:8080"

networks:
  pushilka_net:
    external:
      name: pushilka_net

