.. _docs_docker-proxy_upgrade-v2:

Docker-Proxy-Stack Upgrade instructions
=======================================

.. note::

   Important notice: There is a huge gap between the Docker-Proxy-Stack in version 1 vs. version 2. This relates to the
   tag v2.0.0 and above, which you will get by using the ``DockerExec self-update`` command. In case you have just
   installed the latest version, your are fine.

To make the upgrade as easy is possible, follow these steps to reproduce the setup from Proxy-Stack v1.


Upgrade
-------

You probably got here by reading and understanding following lines, after executing a command with the ``DockerExec``
script.

.. code-block::

   You have currently checked out the tag 'v1.*.*', which is outdated!
   Please use 'DockerExec self-update' to switch to the latest version.

If your current version is now v2.*.*, the biggest part of the update is already done. Keep an eye on the ``.env`` file
in your Proxy-Stack directory and compare it with the ``.env.template`` again. It has simplified a lot! Lastly you are
missing the proxy containers.

#. Check the ``.env`` file in Docker-Proxy-Stack directory and compare with current ``.env.template`` file.
#. Make sure, you saved all progress of your current projects and docker files.
#. Run ``DockerExec finish``, to stop and remove any running docker container.
#. As of installation in v1, you will probably have some lines added to your ``.bashrc`` file. Those lines can now be
   removed securely.
#. Instead you should create a soft link to the DockerExec within your ``/home/$USER/.local/bin`` directory.


Rebuild containers
------------------

The new Proxy configuration does not work with ``docker-compose`` anymore (at least not the proxy itself), but with
single shell files. For more information please read the ":ref:`docs_docker-proxy_how-it-works`" chapter.

The ``DockerExec`` offers a new environment "spawn", which is used to configure and enable any global network service
to be started with the Proxy-Network. The "how to" is explained in chapter :ref:`docs_docker-proxy_spawn-instructions`.

You can now either spawn all of you necessary docker containers with the ``DockerExec spawn`` commands or just use
``DockerExec spawn legacy`` and follow the instructions, to prepare a Docker-Proxy-Stack as it lived in v1.
