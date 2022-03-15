.. _docs_docker-proxy_mailcatching:

E-Mail Catching
===============

This service was created to catch e-mails on the SMTP ports from any local source and display them in a simple viewer
within a browser. You can read more about it `here <https://github.com/Sengorius/proxy-mailcatcher>`_.

To make this service part of the Proxy-Stack, use the ``DockerExec spawn mailcatcher`` command and follow the
instructions. Don't forget to restart the Proxy-Network, if done.

Then configure the service in your projects. Current use-cases include mails sent by **Symfony** and **WordPress**.


Symfony
-------

In your projects ``.env`` file set ``MAILER_DSN=smtp://mailcatcher:25``. That's it.


WordPress
---------

Two options:

#. Install the Plugin **WP Mail SMTP**, use the option "Other SMTP" and set the variable "SMTP HOST" to ``proxy-smtp``
   and "SMTP Port" to ``25``. Then deactivate "Auto TLS" and "Authentication".

#. Create your own plugin with this code snippet:

   .. code-block:: php

      <?php
      /**
       * Proxy SMTP Adapter
       *
       * @package nginx-proxy
       * @license GPLv3
       *
       * @wordpress-plugin
       * Plugin Name: Proxy SMTP Adapter
       * Description: Configure WordPress to send emails to the Mailcatcher available at the host name "proxy-smtp"
       * Version: 1.0.0
       * Text Domain: nginx-proxy
       * License: GPLv3
       * License URI: http://www.gnu.org/licenses/gpl-3.0.txt
       */

      /**
       * Configure WordPress to send emails to the Mailcatcher available at the host name "proxy-smtp".
       *
       * @param PHPMailer $phpmailer The PHPMailer instance.
       */
      function proxy_smtp_config( $phpmailer ) {
          $phpmailer->isSMTP();
          $phpmailer->Host     = 'proxy-smtp';
          $phpmailer->SMTPAuth = false;
          $phpmailer->Port     = 25;
      }
      add_action( 'phpmailer_init', 'proxy_smtp_config' );
