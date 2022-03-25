.. _docs_mezzio-messenger_how-to:

How to use the bridge
=====================

The main usage for a message bus is the asynchronous handling of tasks from so called 'workers' or 'handlers' (Symfony).
Therefore a value object (message) is dispatched on a bus. A worker is specified to handle this message (asynchronously
or syncronously). This prevents long running jobs from blocking a response for the user, if we stick to the http
context.

A message could be as simple as this:

.. code-block:: php

   namespace App\Worker;

   class UnimportantAsyncMessage
   {
       private string $title;
       private ?string $message;


       public function __construct(string $title, ?string $message = null)
       {
           $this->title = $title;
           $this->message = $message;
       }

       public function getTitle(): string
       {
           return $this->title;
       }

       public function getMessage(): ?string
       {
           return $this->message;
       }
   }

To handle that message, we also define a worker, that is specific to this message. It uses the ``__invoke()`` method
and has to be configured correctly. See the ":ref:`docs_mezzio-messenger_config`" section for details.

.. code-block:: php

   namespace App\Worker;

   use Psr\Container\ContainerExceptionInterface;
   use Psr\Container\ContainerInterface;
   use Psr\Container\NotFoundExceptionInterface;
   use Psr\Log\LoggerInterface;

   final class UnimportantWorker
   {
       private LoggerInterface $logger;


       public function __construct(ContainerInterface $container)
       {
           $this->logger = $container->get('MessageBusLogger');
       }

       public function __invoke(UnimportantAsyncMessage $message): void
       {
           $this->logger->info(sprintf('Working on message with title "%s"', $message->getTitle()));

           // handle the message, e.g. updating the database or send an e-mail
       }
   }

The following example represents a handler that uses a form to gather info, which will be stuffed into an asynchronous
message. We can directly answer the user after submitting and later display calculated results. The ``SentStamp`` will
be added by Symfony's middleware and indicates the successful delegation to a transport. Don't forget to pass the
``MessageBusInterface`` service in the handlers factory!

.. code-block:: php

   namespace App\Handler;

   use App\Worker\ImportantSyncMessage;
   use App\Worker\UnimportantAsyncMessage;
   use Laminas\Diactoros\Response\HtmlResponse;
   use Mezzio\Template\TemplateRendererInterface;
   use Psr\Http\Message\ResponseInterface;
   use Psr\Http\Message\ServerRequestInterface;
   use Psr\Http\Server\RequestHandlerInterface;
   use Symfony\Component\Messenger\MessageBusInterface;
   use Symfony\Component\Messenger\Stamp\HandledStamp;
   use Symfony\Component\Messenger\Stamp\SentStamp;

   final class MessageHandler implements RequestHandlerInterface
   {
       private TemplateRendererInterface $template;
       private MessageBusInterface $bus;


       public function __construct(TemplateRendererInterface $template, MessageBusInterface $bus)
       {
           $this->template = $template;
           $this->bus = $bus;
       }

       public function handle(ServerRequestInterface $request): ResponseInterface
       {
           $params = $request->getParsedBody();

           if ('POST' === $request->getMethod() && is_array($params)) {
               $title = $params['title'] ?? null;
               $description = $params['message'] ?? null;

               if (!empty($title)) {
                   $message = new UnimportantAsyncMessage($title, $description);
                   $envelope = $this->bus->dispatch($amqpMessage);

                   if (null !== $envelope->last(SentStamp::class)) {
                       // success
                   } else {
                       // failure
                   }
               } else {
                   // required params missing
               }
           }

           return new HtmlResponse($this->template->render('...'));
       }
   }


Asynchronous message consuming
------------------------------

Taking the example above as granted, we now have at least one un-handled message in our broker (RabbitMQ, Database or
Redis) that needs to be "consumed". To handle this asynchronously, the package provides a ``vendor/bin/message-bus``
binary that is based on the ``Symfony/Console`` component. Try ``php vendor/bin/message-bus`` to list possible commands
for the consumers.

With ``php vendor/bin/message-bus messenger:consume Transport::$name`` you can start a consumer that will take and
handle all messages from the given transport one by one. You should also take a look at the `supervisor configuration
from Symfony Docs <https://symfony.com/doc/current/messenger.html#supervisor-configuration>`_ for making the consumer
sustainable.


Using the Logger
----------------

With this package there is a Monolog service registered as 'MessageBusLogger' in the ``Psr\Container`` (Laminas Service
Manager). You can use the service to write into the same log files, as the Symfony services do. Take a look on the
'UnimportantWorker' above for an example.
