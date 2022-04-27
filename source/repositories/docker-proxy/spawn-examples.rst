.. _docs_docker-proxy_examples:

Spawn Container Examples
========================

A list of copy & paste examples for the available spawns in Docker-Proxy-Stack.


MySQL, MariaDB & PhpMyAdmin
---------------------------

https://hub.docker.com/_/mysql

.. code-block:: shell
   :linenos:

   #!/usr/bin/env bash

   CONTAINER_NAME="proxy-mysql5"

   docker run --tty --detach \
       --name "${CONTAINER_NAME}" \
       --volume "proxy-data-db5:/var/lib/mysql" \
       --volume "${DATA_PATH}:/var/data" \
       --network "${NETWORK_NAME}" \
       --restart unless-stopped \
       --env TZ=Europe/Amsterdam \
       --env MYSQL_ROOT_PASSWORD=root \
       --env MYSQL_PORT=3306 \
       mysql:5.7 --character-set-server=utf8mb4 \
                 --collation-server=utf8mb4_unicode_ci \
                 --sql_mode="STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION"


.. code-block:: shell
   :linenos:

   #!/usr/bin/env bash

   CONTAINER_NAME="proxy-mysql8"

   docker run --tty --detach \
       --name "${CONTAINER_NAME}" \
       --volume "proxy-data-db8:/var/lib/mysql" \
       --volume "${DATA_PATH}:/var/data" \
       --network "${NETWORK_NAME}" \
       --restart unless-stopped \
       --env TZ=Europe/Amsterdam \
       --env MYSQL_ROOT_PASSWORD=root \
       --env MYSQL_PORT=3306 \
       mysql:8 --character-set-server=utf8mb4 \
               --collation-server=utf8mb4_unicode_ci


https://hub.docker.com/_/mariadb

.. code-block:: shell
   :linenos:

   #!/usr/bin/env bash

   CONTAINER_NAME="proxy-mariadb10"

   docker run --tty --detach \
       --name "${CONTAINER_NAME}" \
       --volume "proxy-data-mdb10:/var/lib/mysql" \
       --volume "${DATA_PATH}:/var/data" \
       --network "${NETWORK_NAME}" \
       --restart unless-stopped \
       --env TZ=Europe/Amsterdam \
       --env MYSQL_ROOT_PASSWORD=root \
       --env MYSQL_PORT=3306 \
       mariadb:10


https://hub.docker.com/_/phpmyadmin

.. code-block:: shell
   :linenos:

   #!/usr/bin/env bash

   CONTAINER_NAME="proxy-pma"

   docker run --tty --detach \
       --name "${CONTAINER_NAME}" \
       --volume "${DATA_PATH}:/var/data" \
       --network "${NETWORK_NAME}" \
       --restart unless-stopped \
       --env TZ=Europe/Amsterdam \
       --env VIRTUAL_HOST=pma.docker.test \
       --env VIRTUAL_PORT=80 \
       --env PMA_ARBITRARY=1 \
       --env PMA_HOST=proxy-mariadb10 \
       --env PMA_USER=root \
       --env PMA_PASSWORD=root \
       phpmyadmin:latest


PostgreSQL & Adminer
--------------------

https://hub.docker.com/_/postgres

.. code-block:: shell
   :linenos:

   #!/usr/bin/env bash

   CONTAINER_NAME="proxy-postgres13"

   docker run --tty --detach \
       --name "${CONTAINER_NAME}" \
       --volume "proxy-data-pg13:/var/lib/postgresql/data" \
       --volume "${DATA_PATH}:/var/data" \
       --network "${NETWORK_NAME}" \
       --restart unless-stopped \
       --env TZ=Europe/Amsterdam \
       --env POSTGRES_USER=root \
       --env POSTGRES_PASSWORD=root \
       --env POSTGRES_PORT=5432 \
       postgres:13


https://hub.docker.com/_/adminer

.. code-block:: shell
   :linenos:

   #!/usr/bin/env bash

   CONTAINER_NAME="proxy-adminer"

   docker run --tty --detach \
       --name "${CONTAINER_NAME}" \
       --volume "${DATA_PATH}:/var/data" \
       --network "${NETWORK_NAME}" \
       --restart unless-stopped \
       --env VIRTUAL_HOST=adminer.docker.test \
       --env VIRTUAL_PORT=8080 \
       --env ADMINER_DEFAULT_SERVER=proxy-postgres13 \
       --env ADMINER_PLUGINS="tables-filter tinymce edit-calendar" \
       --env ADMINER_DESIGN=rmsoft \
       adminer:latest


MongoDB & Commander
-------------------

https://hub.docker.com/_/mongo

.. code-block:: shell
   :linenos:

   #!/usr/bin/env bash

   CONTAINER_NAME="proxy-mongo5"

   docker run --tty --detach \
       --name "${CONTAINER_NAME}" \
       --volume "proxy-data-mongo5:/data/db" \
       --volume "${DATA_PATH}:/var/data" \
       --network "${NETWORK_NAME}" \
       --restart unless-stopped \
       --env TZ=Europe/Amsterdam \
       --env MONGO_INITDB_ROOT_USERNAME=root \
       --env MONGO_INITDB_ROOT_PASSWORD=root \
       mongo:5


https://hub.docker.com/_/mongo-express

.. code-block:: shell
   :linenos:

   #!/usr/bin/env bash

   CONTAINER_NAME="proxy-mongo-express"

   docker run --tty --detach \
       --name "${CONTAINER_NAME}" \
       --volume "${DATA_PATH}:/var/data" \
       --network "${NETWORK_NAME}" \
       --restart unless-stopped \
       --env VIRTUAL_HOST=mongo-express.docker.test \
       --env VIRTUAL_PORT=8081 \
       --env ME_CONFIG_MONGODB_ENABLE_ADMIN=true \
       --env ME_CONFIG_MONGODB_SERVER=proxy-mongo5 \
       --env ME_CONFIG_MONGODB_PORT=27017 \
       --env ME_CONFIG_BASICAUTH_USERNAME=root \
       --env ME_CONFIG_BASICAUTH_PASSWORD=root \
       --env ME_CONFIG_MONGODB_ADMINUSERNAME=root \
       --env ME_CONFIG_MONGODB_ADMINPASSWORD=root \
       mongo-express:latest


Redis & Commander
-----------------

https://hub.docker.com/_/redis

.. code-block:: shell
   :linenos:

   #!/usr/bin/env bash

   CONTAINER_NAME="proxy-redis5"

   docker run --tty --detach \
       --name "${CONTAINER_NAME}" \
       --volume "proxy-data-redis5:/data" \
       --volume "${DATA_PATH}:/var/data" \
       --network "${NETWORK_NAME}" \
       --restart unless-stopped \
       --env TZ=Europe/Amsterdam \
       --env REDIS_PASSWORD=root \
       --env REDIS_PORT=6379 \
       redis:5 --appendonly yes


https://hub.docker.com/r/rediscommander/redis-commander

.. code-block:: shell
   :linenos:

   #!/usr/bin/env bash

   CONTAINER_NAME="proxy-rediscommander"

   docker run --tty --detach \
       --name "${CONTAINER_NAME}" \
       --volume "${DATA_PATH}:/var/data" \
       --network "${NETWORK_NAME}" \
       --restart unless-stopped \
       --env VIRTUAL_HOST=redis-commander.docker.test \
       --env VIRTUAL_PORT=8081 \
       --env REDIS_HOST=proxy-redis5 \
       --env REDIS_PORT=6379 \
       --env REDIS_PASSWORD=root \
       rediscommander/redis-commander:latest


RabbitMQ
--------

https://hub.docker.com/_/rabbitmq

.. code-block:: shell
   :linenos:

   #!/usr/bin/env bash

   CONTAINER_NAME="proxy-rabbitmq"

   docker run --tty --detach \
       --name "${CONTAINER_NAME}" \
       --hostname "rabbitmq.docker.test" \
       --volume "proxy-data-rabbitmq:/var/lib/rabbitmq" \
       --network "${NETWORK_NAME}" \
       --restart unless-stopped \
       --env TZ=Europe/Amsterdam \
       --env VIRTUAL_HOST=rabbitmq.docker.test \
       --env VIRTUAL_PORT=15672 \
       --env RABBITMQ_DEFAULT_USER=root \
       --env RABBITMQ_DEFAULT_PASS=root \
       rabbitmq:3.9-management
