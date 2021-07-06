# Dockerfile
#
# Copyright 2021 MicroEJ Corp. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be found with this software.
#
FROM adoptopenjdk:8

RUN apt-get update
RUN apt-get install -y git unzip udev
RUN echo 'ACTION!="add", GOTO="usbdongle_end"\n' \
    'SUBSYSTEM=="usb", GOTO="usbdongle_start"\n' \
    'SUBSYSTEMS=="usb", GOTO="usbdongle_start"\n' \
    'GOTO="usbdongle_end"\n' \
    'LABEL="usbdongle_start"\n' \
    'ATTRS{idVendor}=="096e" , ATTRS{idProduct}=="0006" , MODE="0666"\n' \
    'LABEL="usbdongle_end"' > /etc/udev/rules.d/91-usbdongle.rules

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

RUN git clone --recursive https://github.com/MicroEJ/Tool-CommandLineBuild.git
RUN mkdir -p Tool-CommandLineBuild/buildKit/

RUN curl -O https://repository.microej.com/packages/SDK/4.1.5/zip/microej-sdk-4.1.5-linux_x86_64.zip && \
    unzip microej-sdk-4.1.5-linux_x86_64.zip \
        plugins/com.is2t.eclipse.plugin.easyant4e_1.7.3.20180621-1638.jar \
        plugins/com.is2t.eclipse.plugin.easyant4e.offlinerepo_1.6.0.20180621-1638.jar && \
    unzip plugins/com.is2t.eclipse.plugin.easyant4e_1.7.3.20180621-1638.jar 'lib/*' -d Tool-CommandLineBuild/buildKit/ant && \
    unzip plugins/com.is2t.eclipse.plugin.easyant4e.offlinerepo_1.6.0.20180621-1638.jar repositories/is2t_repo.zip && \
    unzip repositories/is2t_repo.zip -d Tool-CommandLineBuild/buildKit/microej-build-repository && \
    rm -rf microej-sdk-4.1.5-linux_x86_64.zip plugins repositories

RUN curl -O https://repository.microej.com/packages/SDK/20.12/zip/microej-sdk-20.12-linux_x86_64.zip && \
    unzip microej-sdk-20.12-linux_x86_64.zip 'plugins/com.is2t.eclipse.plugin.easyant4e_2.3.1.202012101611.jar' && \
    unzip plugins/com.is2t.eclipse.plugin.easyant4e_2.3.1.202012101611.jar lib/jdtCompilerAdapter.jar lib/org.eclipse.jdt.compiler.apt.jar lib/org.eclipse.jdt.core.jar -d Tool-CommandLineBuild/buildKit/ant/ && \
    rm -rf microej-sdk-20.12-linux_x86_64.zip plugins

RUN echo "\neasyant.inject.build.compiler=org.eclipse.jdt.core.JDTCompilerAdapter" >> Tool-CommandLineBuild/local-build.properties 
ENV MICROEJ_BUILD_JDK_HOME=$JAVA_HOME
ENV MICROEJ_BUILDKIT_HOME=${HOME}/Tool-CommandLineBuild

RUN echo 'sdk.version=5.4.1' > $MICROEJ_BUILDKIT_HOME/release.properties

ENV PATH=$MICROEJ_BUILDKIT_HOME:$PATH
