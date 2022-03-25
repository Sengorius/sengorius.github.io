.. _docs_mezzio-messenger_config:

Configuration
=============

The configuration for this bridge is defined under the ``messageBus`` namespace for the ``Laminas\ConfigAggregator``.
It holds multiple path variables, mapping arrays and a failure transport definition.

Any message that is apssed through a messenger middleware or through a command (working asynchronously) will be logged
with the `Monolog <https://packagist.org/packages/monolog/monolog>`_ library. Some of the Symfony commands to handle
the worker need a cache. Both of these paths can be defined with following configuration. The default configuration
will store files in the ``data/cache/message-bus`` and ``data/logs/message-bus`` directories.

.. code-block:: php

   'messageBus' => [
       'logPath' => dirname(__DIR__, 2).'/data/logs/message-bus',
       'cachePath' => dirname(__DIR__, 2).'/data/cache',

       // ...
   ],


Transports
----------

A 'transport' defines the channels, where asynchronous messages can be send to. This can be a database and delegated
via Doctrine, a Redis instance or a RabbitMQ. Maybe more to come. To define multiple channels, simply create multiple
DSNs within this configuration.

.. code-block:: php

   'messageBus' => [
       'transportDSNs' => [
           // name     => DSN,
           'default'   => 'amqp://guest:password@rabbitmq.tld:5672/%2f/default',
           'failure'   => 'amqp://guest:password@rabbitmq.tld:5672/%2f/failure',
           'doctrine'  => 'doctrine://guest:password@mariadb10:3306/default',
           'redis'     => 'redis://redis5:6379/default',
       ],

       // ...
   ],

For each configured transport DSN, a service named ``Transport::$name`` will be added to the service container, holding
an instance of ``Symfony\Component\Messenger\Transport\TransportInterface`` with the necessary connection to the broker.
To get a transport from the container, you can either pass the string - e.g. ``Transport::default`` - or use the helper
``MessageBus\Factory\Transporthelper::createTransportName($name)`` for the ``$container->get(...)`` instruction.

One of those transports should be defined as the 'failure transport'. Symfony messenger will put any message that has
failed 3 times onto this transport. It also offers commands to display and retry failed messages or remove them savely.
This transport does not have to be named 'failure'.

.. code-block:: php

   'messageBus' => [
       'failureTransport' => MessageBus\Factory\TransportHelper::createTransportName('failure'),

       // ...
   ],


Delegating the messages
-----------------------

Each message needs a 'Worker' to handle it. You can find out more in the ":ref:`docs_mezzio-messenger_how-to`" section
or in the `Symfony documentation <https://symfony.com/doc/current/messenger.html>`_. The bridge handles the associations
via array maps, defining message to worker(s) and message to transport(s). You can pass a string or array as value.

.. code-block:: php

   'messageBus' => [
       // ...

       'handlersLocatorMap' => [
           App\Worker\ImportantSyncMessage::class => [App\Worker\ImportantWorker::class],
           App\Worker\UnimportantAsyncMessage::class => App\Worker\UnimportantWorker::class,
       ],

       'sendersLocatorMap' => [
           App\Worker\UnimportantAsyncMessage::class => 'Transport::default',
       ],
   ],

A message not listed in the 'sendersLocatorMap' will be handle synchronously on request.
