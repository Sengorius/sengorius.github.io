.. _docs_docker-proxy_index:

Docker-Proxy-Stack
==================

.. toctree::
   :name: docs_docker-proxy_toc
   :maxdepth: 1
   :hidden:

   GitHub Repository <https://github.com/Sengorius/docker-proxy-stack>
   install
   docker-exec
   mailcatching
   upgrade-v2
   spawn-examples


What is the Docker-Proxy-Stack?
-------------------------------

The docker proxy stack is primarily a toolkit for local web development that supports

#. SSL (``https://``) for all local projects.
#. descriptive names instead of ``localhost``.
#. running multiple projects at the same time

   - sharing database containers (MySQL, PostgreSQL & Redis)
   - sharing certificates
   - sharing a reverse proxy (thus not blocking port 80/443)

#. easy initial setup
#. adding as much "global service" docker containers as you like
#. optional catching E-Mails via SMTP with mailcatcher

Its tools are based on the `nginx-proxy <https://github.com/nginx-proxy/nginx-proxy>`_ from Jason Wilder and
contributors.

:ref:`» Take me to the installation part <docs_docker-proxy_installation>`


So why do we do all this?
^^^^^^^^^^^^^^^^^^^^^^^^^

If you are running multiple web applications on one machine at the same time you are running into a couple of issues.
If your projects are already dockerized, every ``docker-compose`` file will

- run their own webserver
- run their own database
- use probaby the same port for each of those.

You also have to manage SSL certificates for each project.

**The solution the Docker proxy stack provides is taking care of all shared ressources.** So

- run a reverse proxy to manage all projects web-servers
- run one database server
- provide a custom certificate
- run DBA tools like PMA or Adminer
- run a mailcatcher
- and set all of it up in a conveniant way with ``DockerExec`` shell script.

.. note::

   The only requirement is to use the DockerExec shell script and have ``git``, ``docker`` and ``docker-compose``
   installed.

   As of v2.1.0 the "docker compose" extension can also be used and the "docker-compose" binary is not necessary
   anymore.


.. _docs_docker-proxy_how-it-works:

How does the Proxy-Stack work?
------------------------------

We first started with a basic ``docker-compose`` setup of MySQL, PostgreSQL, Redis, Adminer and PhpMyAdmin. This setup
was pretty static and not really extensible, as the compose file was comitted to the repository. This also limited the
possibility to configure those five containers or even swap versions. If you wanted to change ``mysql:5.7`` image to a
``mysql:8``, you probably lost those changes after a ``DockerExec self-update`` command.

The new Proxy configuration does not work with ``docker-compose`` anymore (at least not the proxy itself), but with
single shell files. Each one of those files will start a single container into the proxy network. Like the Apache2, we
now have ``spawns-available`` and ``spawns-enabled`` folders withing the repository directory, to tell the proxy, which
containers will be started on init command.

This allows to have a ``mysql:5.7`` and ``mysql:8`` container configured for the Proxy-Stack. You can even start and run
both at the same time without conflicts, or just start the one you need and disable the other. The way to add projects
from (multiple) ``docker-compose.proxy.yaml`` files (see below) did not change at all.

.. note::

   If you missed the v2.*.* update or like to read more about "spawning" service containers, please read the
   :ref:`docs_docker-proxy_upgrade-v2`.


How to add Projects to the Docker Proxy Network
-----------------------------------------------

The main goal here is to add multiple projects, that are dockerized, to the same proxy network. For a documentation on
how to resolve URLs to a specific docker container, please read
`the nginx-proxy documentation <https://github.com/nginx-proxy/nginx-proxy>`_.

#. ``DockerExec`` expects a ``docker-compose.proxy.y(a)ml`` file that contains services you might need for your project.
   You may configure some NGINX like this:

   .. code-block:: yaml

      nginx:
          image: nginx:latest
          container_name: ${CON_PREFIX}-web
          volumes:
              - .:/var/www/html
          environment:
              # choose a docker.test subdomain
              VIRTUAL_HOST: my-project.docker.test
              VIRTUAL_PORT: 443
              VIRTUAL_PROTO: https

   ``my-project`` should be your project name.

#. Specify the Docker network you created above in ``docker-compose.proxy.y(a)ml``:

   .. code-block:: yaml

      services:
         # ...

      networks:
          default:
              external: true
              name: ${NETWORK_NAME}

#. You also need a ``.env`` file to specify at least ``CON_PREFIX`` or ``CON_NAME``

.. note::

   Both of these files can be automatically generated with ``DockerExec proxy generate {project-name}``!
