..
    Copyright 2021 MicroEJ Corp. All rights reserved.
	This library is provided in source code for use, modification and test, subject to license terms.
	Any modification of the source code will break MicroEJ Corp. warranties on the whole library.

=================================
 Docker for MicroEJ BuildKit SDK
=================================

Overview
========

This is the git repository to build the MicroEJ BuildKit Docker Image for various MicroEJ SDK versions.

Documentation
=============

MicroEJ SDK version ``5.4.0`` and above
---------------------------------------

For MicroEJ SDK version ``5.4.0`` and above, please refer to `https://docs.microej.com/en/latest/ApplicationDeveloperGuide/mmm.html#command-line-interface`_.

Build the image from ``Dockerfile``:

.. code-block:: console

   $ docker build -t microej_buildkit_5.4.1 5.4.1

Start the image for interactive usage:

.. code-block:: console

   $ docker run --rm -it microej_buildkit_5.4.1:latest bash

Build a project from a local folder:

.. code-block:: console

   $ docker run --rm -v PATH/TO/PROJECT:/project -w /project microej_buildkit_5.4.1:latest mmm build

MicroEJ SDK version ``4.1.5`` to ``5.3.1``
------------------------------------------

For MicroEJ SDK version ``4.1.5`` to ``5.3.1``, please refer to `https://github.com/MicroEJ/Tool-CommandLineBuild`_.

Build the image from ``Dockerfile``:

.. code-block:: console

   $ docker build -t microej_buildkit_4.1.5 4.1.5

Start the image for interactive usage:

.. code-block:: console

   $ docker run --rm -it microej_buildkit_4.1.5:latest bash

Build a project from a local folder:

.. code-block:: console

   $ docker run --rm -v PATH/TO/PROJECT:/project -w /project microej_buildkit_5.4.0:latest build_module_local.sh ./

Where to get help?
==================

- `MicroEJ Forum <https://forum.microej.com>`_
- `MicroEJ Documentation Center <https://docs.microej.com>`_
- `MicroEJ Technical Hot-line <https://www.microej.com/contact/#form_2>`_
