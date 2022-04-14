.. _docs_mezzio-messenger_index:

Mezzio: Symfony-Messenger-Bridge
================================

.. toctree::
   :name: docs_mezzio-messenger_toc
   :maxdepth: 1
   :hidden:

   GitHub Repository <https://github.com/Sengorius/mezzio-messenger-bridge>
   configuration
   how-to-use


This package is a plugin for the `Mezzio framework <https://docs.mezzio.dev/mezzio/>`_ and injects the
`Symfony/Messenger <https://symfony.com/doc/current/messenger.html>`_ as good as possible into it.

Take a look in the ":ref:`docs_mezzio-messenger_how-to`" section for examples.


Installation
------------

With `composer <https://getcomposer.org/>`_ run the following statement:

.. code-block:: shell

   $ composer require skript-manufaktur/mezzio-messenger-bridge

Open the ``config/config.php`` and add following line before the ``App\ConfigProvider::class``:

.. code-block:: php

   MessageBus\ConfigProvider::class,

Copy the configuration example in ``vendor/skript-manufaktur/mezzio-messenger-bridge/messagebus.global.php.dist`` to
``config/autoload/messagebus.global.php`` or insert its content into your ``config/autoload/local.php``. Then update it
to your needs.

You may also copy or link the binary console to ``bin/message-bus`` or just use it from the ``vendor/bin`` directory.
