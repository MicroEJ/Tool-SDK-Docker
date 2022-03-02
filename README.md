![SDK 5.4 Compatible](https://shields.microej.com/endpoint?url=https://repository.microej.com/packages/badges/sdk_5.4.json)

![SDK 4.1 Compatible](https://shields.microej.com/endpoint?url=https://repository.microej.com/packages/badges/sdk_4.1.json)

# Docker for MicroEJ BuildKit SDK

## Overview

This is the git repository to build the MicroEJ BuildKit Docker Image
for various MicroEJ SDK versions.

## Documentation

All images referenced in this document are available in our [Docker Hub repository](https://hub.docker.com/u/microej/).
You can also build them yourself following build instruction bellow and our [Github repository](https://github.com/MicroEJ/Tool-SDK-Docker).

### MicroEJ SDK version `5.4.1` and above

For MicroEJ SDK version `5.4.1` and above, please refer to
<https://docs.microej.com/en/latest/ApplicationDeveloperGuide/mmm.html#command-line-interface>.

Start the image for interactive usage:

``` console
$ docker run --rm -it microej/sdk:5.4.1 bash
```

Build a project from a local folder:

``` console
$ docker run --rm -v PATH/TO/PROJECT:/project -w /project microej/sdk:5.4.1 mmm build
```

You can also build the image yourself from `Dockerfile`:

``` console
$ docker build -t microej/sdk:5.4.1 5.4.1
```

### MicroEJ SDK version `4.1.5` to `5.3.1`

For MicroEJ SDK version `4.1.5` to `5.3.1`, please refer to
<https://github.com/MicroEJ/Tool-CommandLineBuild>.

Start the image for interactive usage:

``` console
$ docker run --rm -it microej/sdk:4.1.5 bash
```

Build a project from a local folder:

``` console
$ docker run --rm -v PATH/TO/PROJECT:/project -w /project microej/sdk:4.1.5 build_module_local.sh ./
```

You can also build the image yourself from `Dockerfile`:

``` console
$ docker build -t microej/sdk:4.1.5 4.1.5
```

### Automated tests

A Jenkinsfile is at the root of this project to automatically test  project Dockerfiles. You can launch it using Jenkins CI. \
We followed the Jenkins recommendations to write this Jenkinsfile : [Using Docker with Pipeline](https://www.jenkins.io/doc/book/pipeline/docker/). \
If you want to run it, you need to have at least one node labelled `docker`.

## F.A.Q

### How can I add my custom certificate to fetch my company dependencies using mmm ?

You can either :

#### Update existing keystore

Add your custom CA certificate to the docker image by adding these lines
to the `Dockerfile` you want to build :

``` console
USER root
COPY company.cer $JAVA_HOME/jre/lib/security
RUN \
    cd $JAVA_HOME/jre/lib/security \
    && keytool -keystore cacerts -storepass changeit -noprompt -trustcacerts -importcert -alias companycert -file company.cer
```

#### Use custom keystore

Mount your keystore using -v in the docker container and use it with mmm
by adding `-Djavax.net.ssl.trustStore=keystore_path_in_container` to
your build

### How can I use my custom ivysettings to use my company maven repository ?

The recommended way to do that is to mount your ivysettings into your
docker container and use MMM-CLI with parameter `-r` to specify the
module repository settings file location.

Please refer to [MicroEJ Module Manager
documentation](https://docs.microej.com/en/latest/SDKUserGuide/mmm.html)
for more information.

## Where to get help?

-   [MicroEJ Forum](https://forum.microej.com)
-   [MicroEJ Documentation Center](https://docs.microej.com)
-   [MicroEJ Technical Hot-line](https://www.microej.com/contact/#form_2)

---
_Markdown_  
_Copyright 2021-2022 MicroEJ Corp. All rights reserved._
_Use of this source code is governed by a BSD-style license that can be found with this software._