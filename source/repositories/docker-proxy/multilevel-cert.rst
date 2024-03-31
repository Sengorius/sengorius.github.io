.. _docs_docker-proxy_multilevel-cert:

Creating multilevel subdomain certificates
==========================================

When generating the local docker.test certificate (using the ``DockerExec do init-certs``) command, the local domains
for development will be encrypted. The certificate is valid for any subdomain with the schema
https://subdomain.docker.test or even https://docker.test itself. However, for some projects you might need to have
a mutilevel subdomain setup, like https://first.second.docker.test, which should also be secured with SSL.

As it is not possible to create such mutilevel subdomain certificates directly, the solution is to create another
subdomain certificate for second.docker.test and register it like the other one. Use the ``DockerExec do add-cert``
command to start the setup, answer the questions to create a self-signed certificate and enter the subdomain name
(the "second" part as seen above) in the last question. You may also skip the most question by pressing enter.

.. code-block::

   > $ DockerExec do add-cert

   You are about to create a multilevel wildcard cert. Please answer following questions:
   Define a key size [4096]:
   How long shall this certificate be valid (in days) [3650]:
   Country Name (2 letter code) [PS]:
   State or Province Name (full name) [Proxy Environment]:
   Locality Name (some city) [Proxy]:
   Organization Name (some company) [Docker Proxy Stack]:
   Organizational Unit Name (a section) [Docker Proxy Stack]:
   E-Mail Address []:
   Additional subdomain, e.g. 'example' to create '*.example.docker.test' []: second

Outputs:

.. code-block::

   /usr/bin/openssl
   req: No value provided for subject name attribute "emailAddress", skipped
   Certificate request self-signature ok
   subject=C = PS, ST = Proxy Environment, L = Proxy, O = Docker Proxy Stack, OU = Docker Proxy Stack, CN = second.docker.test
   Done creating rootCA and certificates in /home/patrick/Dokumente/docker-proxy-stack/certs.
   Now register the rootCA.crt in your browser.

Don't forget to check :ref:`docs_docker-proxy_chromium-install` or :ref:`docs_docker-proxy_firefox-install`
for instructions on how to install the new certificate.
