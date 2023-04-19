.. _docs_docker-proxy_installation:

Installation & Update
=====================

To make sure, anything will run fine, a unix based system is necessary. Things might work on Windows, too, but it was
never tested to do so.

You will also need ``docker``, ``docker-compose``, ``openssl``, ``git`` and a bash on your local machine. As all tasks
are made for bash, a zsh or similar shells will work, too.


First setup
-----------

Clone the repository somewhere to your machine. Make a copy of the ``.env.template`` and save it as ``.env`` into the
same folder. (Windows uses a different ``SOCKET_PATH``, all other variables should be fine.)

.. note::

   The ``${BASE_DIR}`` variable references the installation directory for the proxy and can be used anywhere within the
   configuration.

Use a shell within the project directory and make sure to have execution rights on the ``DockerExec`` file with
``chmod +x DockerExec``. You should also create a softlink or alias for ``DockerExec``, e.g.
``ln -s /path/to/this/docker-proxy/DockerExec /home/$USER/.local/bin/DockerExec``.

If the shell script was installed correctly, type ``DockerExec help`` to get a list of tasks, the script can do for you.

.. note::

   You need to belong to the ``sudo`` group, as ``DockerExec`` has to update your ``/etc/hosts`` file, in order to
   match the network for your projects.

Run ``DockerExec init-certs`` and follow the prompts. This should create multiple certificates in the ``certs`` folder,
containing a ``rootCA.crt``. Any info you type into the prompts is optional. In the next step, you have to register
this self-signed certificate to your default browser(s).


Using the Proxy-Stack on MacOS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The library ``realpath`` is mandatory for ``DockerExec`` to work with local files. You have to install the ``coreutils``
to get that library. With Homebrew installed, use ``brew install coreutils``.

Read further on `how to install Homebrew <https://brew.sh/>`_.


Install the rootCA to Firefox
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Go to ``Settings -> Security`` and scroll to the bottom, then click ``Show Certificates``. In the tab
``certificate authorities`` click ``import``, navigate to the aforementioned ``/certs`` folder and select ``rootCA.crt``
to import. Select both checkboxes and confirm.


Install the rootCA to Chrome or Chromium
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

In ``Settings -> Manage certificates -> Authorities``. Navigate to the aforementioned ``/certs`` folder and select
``rootCA.crt`` to import.

This also works for Opera or Vivaldi browsers.


Docker-Proxy-Stack Update
-------------------------

Once your Docker Proxy setup is finished, you can update the script with following steps:

#. Simply use ``DockerExec self-update``.
#. Read new release notes


Manual update
-------------

In case the automated update did not work, try this:

In the root directory of this repository

#. Run ``git fetch --tags && REVLIST=$(git rev-list --tags --max-count=1) && git checkout $(git describe --tags $REVLIST)``
#. Read new release notes
