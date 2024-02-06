.. _docs_docker-proxy_dockerexec:

DockerExec
==========

To simplify most of the aforementioned tasks and add additional functionality for usual interactions with the
Docker-Proxy-Stack, we provice the Bash script ``DockerExec``.


Advantages
----------

#. Concise commands for Docker and Docker-Compose.
#. Perform additional tasks like stopping all local Docker containers or remove old image layers.
#. Update local ``/etc/hosts`` automatically.
#. Synchronize the containers ``/etc/hosts`` files automatically.
#. Starting up a project will print the projects domain to your command line.
#. Helps with "spawning" new global containers for the network.
#. Helps with the import of database files into running MySQL/PostgreSQL containers.


How to use DockerExec?
----------------------

#. Install and configure this project.
#. Try and follow ``DockerExec help`` for a list of commands.


Limitations of DockerExec
-------------------------

At this point some variables and configuration are hard coded and have to be set manually for a new project.
You also need Bash. ``/bin/sh`` will not suffice.

#. Your projects Docker-Compose file has to have the name ``docker-compose.proxy.y(a)ml``.

   - Depending on your environment there can also be a ``docker-compose.prod.y(a)ml`` or for a single Compose file
     ``docker-compose.y(a)ml``. These are not suited for local dev environments.

#. You have to provide a ``.env`` file in your project root to set necessary variables. A best practice would be to
   have a version-controlled ``.env.template`` which you copy over to ``.env`` and customize on deployment.

   - As of v2.1.0 the projects default ``.env`` file name can be configured in the Proxy's ``.env`` configuration file


.. _docs_docker-proxy_spawn-instructions:

Spawn global network containers
-------------------------------

Having the Docker-Proxy-Stack installed, you are still missing services. With its new configuration in v2, the only
container that is ensured on every init is the NGINX proxy, which will allow the basics. If you like to start a MySQL
database with your stack, you have to "spawn" and enable this container first. To do that, the
``DockerExec spawn create`` should be prefered.

This command will ask you the mandatory question for any container that will be started on init. Just pass a name and
the docker image to do so, e.g. "mysql5" and "mysql:5.7". By telling the process to enable the container, a soft link
will be created for you. Then hit ``DockerExec proxy init`` to see the result.

As the example above, any service container can be added to the stack. Try more databases like PostgreSQL, add a Redis
or dev tools like the Adminer. You could also add `Ofelia <https://github.com/mcuadros/ofelia>`_ for cron jobs or
`Collabora <https://hub.docker.com/r/collabora/code>`_ for editing office files. Whatever fits your needs.

If you need to configured the basic start of a container, e.g. with command parameters, volumes or environment
variables, just head to the Docker-Proxy-Stack installation directory, open the spawned container behind
``spawns-available/{container-name}`` with an editor and change the file until it matches your setup. Don't forget to
restart the stack.

As the ``DockerExec proxy init`` will only start the containers within the ``path/to/Docker-Proxy/spawns-enabled``
directory, you can use the ``DockerExec spawn enabled/disable {filename}`` command, to link those necessary files. Keep
in mind to restart the Proxy-Stack, so the changes can take effect.


.. _docs_docker-proxy_minimal-config-php:

A Minimal Configuration for PHP
-------------------------------

Some environment variables cannot be read from the ``.env`` file and have to be manually added to the container under
``environment``. E.g. the domain name.

.. code-block:: yaml

   # docker-compose.proxy.yml
   services:
       web:
           image: ${WEB_IMAGE}
           container_name: ${CON_PREFIX}-web
           env_file: .env
           volumes:
               - .:/var/www/html
           environment:
               VIRTUAL_HOST: my-project.docker.test
               VIRTUAL_PORT: 443
           depends_on:
               - php
           networks:
               - proxy
               - local

       php:
           image: ${PHP_IMAGE}
           container_name: ${CON_PREFIX}-app
           env_file: .env
           volumes:
               - .:/var/www/html
           networks:
               - local

   networks:
       proxy:
           name: ${NETWORK}
           external: true

       local:
           driver: bridge

.. code-block::

   # .env

   # on a Windows machine
   # convert windows path to linux in docker-compose
   COMPOSE_CONVERT_WINDOWS_PATHS=1

   # docker-compose configuration
   CON_PREFIX=project # prefix name for the running docker container
   PHP_IMAGE={$CONTAINER_REGISTRY}/php-fpm:8.3
   WEB_IMAGE={$CONTAINER_REGISTRY}/nginx:latest
   NETWORK=nginx-proxy
   START_CONTAINER=project-app

   ### specific to your project
   # MySQL configuration
   MYSQL_HOST=proxy-db
   MYSQL_PORT=3306
   MYSQL_USER=root
   MYSQL_DATABASE=my_project_db
   MYSQL_ROOT_PASSWORD=root

   # or PostgreSQL configuration
   POSTGRES_HOST=proxy-pg
   POSTGRES_PORT=5432
   POSTGRES_USER=root
   POSTGRES_DB=my_project_db
   POSTGRES_PASSWORD=root

These files can be created within any current directory using the ``DockerExec proxy generate ${project-name}`` command.
See ``DockerExec help`` for better usage info.


.. _docs_docker-proxy_headstarting-containers:

Headstarting the Docker Containers
----------------------------------

Use the ``START_CONTAINER`` variable to define the container, that will be allocated with ``docker exec -it`` at the
end of a ``DockerExec (dev|prod|proxy) start`` command. If ``START_CONTAINER=none`` is set, the ``docker exec`` will be
omitted. If not defined, it falls back to search for the first container with ``-app`` suffix.

If you like to use DockerExec commands within other shell scripts, e.g. starting multiple project with a single
execution, the start container would be blocking further commands, if the current shell is adopted by the container tty.
In this case, the variable ``INTERRUPT_START_CONTAINER`` will override the start container. Add an
``export INTERRUPT_START_CONTAINER=yes`` to the top of your shell script, to prevent the ``docker exec`` like this.

.. code-block:: shell

   #!/usr/bin/env bash

   ALL_PATHS=("/path/to/project1" "/path/to/project2" "/path/to/project3")
   export INTERRUPT_START_CONTAINER=yes

   for project in "${ALL_PATHS[@]}"; do
       if [[ ! -d "$project" ]]; then
           echo "No project found on $project!"
           exit 1
       fi

       if [[ ! -f "$project/.env" ]] || [[ ! -f "$project/docker-compose.proxy.yaml" ]]; then
           echo "Project on $project is not prepared for Docker-Proxy-Stack!"
           exit 1
       fi

       cd "$project"
       DockerExec proxy start
   done
