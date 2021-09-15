# Dockerfile
#
# Copyright 2021 MicroEJ Corp. All rights reserved.
# This library is provided in source code for use, modification and test, subject to license terms.
# Any modification of the source code will break MicroEJ Corp. warranties on the whole library.
FROM adoptopenjdk:8

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y git unzip udev
RUN echo 'ACTION!="add", GOTO="usbdongle_end"\n' \
    'SUBSYSTEM=="usb", GOTO="usbdongle_start"\n' \
    'SUBSYSTEMS=="usb", GOTO="usbdongle_start"\n' \
    'GOTO="usbdongle_end"\n' \
    'LABEL="usbdongle_start"\n' \
    'ATTRS{idVendor}=="096e" , ATTRS{idProduct}=="0006" , MODE="0666"\n' \
    'LABEL="usbdongle_end"' > /etc/udev/rules.d/91-usbdongle.rules

# Required for Eclipse-based SDK to run
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y libwebkit2gtk-4.0-37

# Set the new user parameter.
ARG user=jenkins
ARG group=jenkins
ARG uid=1000
ARG gid=1000
RUN addgroup --gid ${gid} ${group}
RUN adduser --home /home/${user} --uid ${uid} --ingroup ${group} --disabled-password ${user}

# Good practice, switch back to user.
USER ${user}

# Set HOME env variable
ENV HOME /home/${user}

# Set workdir
WORKDIR ${HOME}

ENV BUILD_KIT_HOME=$HOME/buildKit
RUN mkdir -p $BUILD_KIT_HOME

RUN curl -O https://repository.microej.com/p2/sdk/5.4.1/plugins/com.is2t.eclipse.plugin.easyant4e.offlinerepo_1.6.1.202104161741.jar && \
    unzip com.is2t.eclipse.plugin.easyant4e.offlinerepo_1.6.1.202104161741.jar repositories/microej-build-repository.zip && \
    unzip repositories/microej-build-repository.zip -d $BUILD_KIT_HOME/microej-build-repository && \
    rm -rf repositories/ && \
    rm -f com.is2t.eclipse.plugin.easyant4e.offlinerepo_1.6.1.202104161741.jar

RUN curl -O https://repository.microej.com/p2/sdk/5.4.1/plugins/com.is2t.eclipse.plugin.easyant4e_2.4.0.202104161741.jar && \
    unzip com.is2t.eclipse.plugin.easyant4e_2.4.0.202104161741.jar cli/mmm-cli.zip && \
    unzip cli/mmm-cli.zip -d $BUILD_KIT_HOME/ && \
    rm -rf cli && \
    unzip com.is2t.eclipse.plugin.easyant4e_2.4.0.202104161741.jar resources/microej-ivysettings-5.4.xml && \
    mkdir -p $BUILD_KIT_HOME/microej-module-repository/ && \
    mv resources/microej-ivysettings-5.4.xml $BUILD_KIT_HOME/microej-module-repository/ivysettings.xml && \
    rm -rf resources/ && \
    rm -f com.is2t.eclipse.plugin.easyant4e_2.4.0.202104161741.jar

RUN echo 'sdk.version=5.4.1' > $BUILD_KIT_HOME/release.properties

ENV PATH=$BUILD_KIT_HOME/bin:$PATH

# Install SDK
ENV ECLIPSE_HOME=$HOME/ECLIPSE
RUN curl -O https://repository.microej.com/packages/SDK/21.03/zip/microej-sdk-21.03-linux_x86_64.zip && \
    mkdir -p $ECLIPSE_HOME && \
    unzip microej-sdk-21.03-linux_x86_64.zip -d $ECLIPSE_HOME && \
    rm -f microej-sdk-21.03-linux_x86_64.zip

# Configure SDK location
RUN mkdir -p $HOME/.microej && \
    echo "[options]\neclipse.home=\"${ECLIPSE_HOME}\"" > $HOME/.microej/.mmmconfig

