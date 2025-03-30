========
Dotfiles
========

A work in progress.
Forever.

Install
-------

.. code-block:: sh

   $ git clone --recursive https://github.com/Julian/dotfiles ~/.dotfiles
   $ mkdir ~/Development
   $ cd ~/.dotfiles && ./install

   $ brew analytics off


irssi
=====

.. code-block:: sh

   $ mkdir ~/.irssi/certs
   $ openssl req -x509 -new -newkey ed25519 -sha256 -nodes -out libera.pem -keyout libera.pem

``/msg nickserv cert add`` it as per the `Libera instructions <https://libera.chat/guides/certfp#add-your-fingerprint-to-nickserv>`_.
