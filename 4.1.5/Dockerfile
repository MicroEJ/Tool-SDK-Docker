# Dockerfile
#
# Copyright 2021-2022 MicroEJ Corp. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be found with this software.
FROM eclipse-temurin:8

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    git \
    unzip \
    udev \
    docker-ce-cli \
    ssh \
    sshpass \
    # Required for Eclipse-based SDK to run
    libxtst6 \
    libgtk2.0-0 && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean

RUN echo 'ACTION!="add", GOTO="usbdongle_end"\n' \
    'SUBSYSTEM=="usb", GOTO="usbdongle_start"\n' \
    'SUBSYSTEMS=="usb", GOTO="usbdongle_start"\n' \
    'GOTO="usbdongle_end"\n' \
    'LABEL="usbdongle_start"\n' \
    'ATTRS{idVendor}=="096e" , ATTRS{idProduct}=="0006" , MODE="0666"\n' \
    'LABEL="usbdongle_end"' > /etc/udev/rules.d/91-usbdongle.rules

# Set the new user parameter.
ARG user=microej
ARG group=microej
ARG uid=1000
ARG gid=1000
RUN addgroup --gid ${gid} ${group} && \
    adduser --home /home/${user} --uid ${uid} --ingroup ${group} --disabled-password ${user}

# Set env
ENV HOME /home/${user}
ENV ECLIPSE_HOME=/opt/eclipse
ENV MICROEJ_BUILD_JDK_HOME=$JAVA_HOME
ENV MICROEJ_BUILDKIT_HOME=/opt/tool-cli-build
ENV PATH=$MICROEJ_BUILDKIT_HOME:$PATH

# Set workdir
WORKDIR $HOME

# I) Install SDK
RUN curl -O https://repository.microej.com/packages/SDK/4.1.5/zip/microej-sdk-4.1.5-linux_x86_64.zip && \
    mkdir -p $ECLIPSE_HOME && \
    unzip microej-sdk-4.1.5-linux_x86_64.zip -d $ECLIPSE_HOME && \
    rm -f microej-sdk-4.1.5-linux_x86_64.zip && \
# II) Install Tool-CommandLineBuild
    git clone --recursive https://github.com/MicroEJ/Tool-CommandLineBuild.git $MICROEJ_BUILDKIT_HOME && \
# III) Extract BuildKit from SDK
    mkdir -p $MICROEJ_BUILDKIT_HOME/buildKit/ && \
    unzip ${ECLIPSE_HOME}/plugins/com.is2t.eclipse.plugin.easyant4e_1.7.3.20180621-1638.jar 'lib/*' -d $MICROEJ_BUILDKIT_HOME/buildKit/ant && \
    unzip ${ECLIPSE_HOME}/plugins/com.is2t.eclipse.plugin.easyant4e.offlinerepo_1.6.0.20180621-1638.jar repositories/is2t_repo.zip && \
    unzip repositories/is2t_repo.zip -d $MICROEJ_BUILDKIT_HOME/buildKit/microej-build-repository && \
    rm -rf repositories && \
# IV) Install jdtCompiler from SDK 20.12
    curl -O https://repository.microej.com/packages/SDK/20.12/zip/microej-sdk-20.12-linux_x86_64.zip && \
    unzip microej-sdk-20.12-linux_x86_64.zip 'plugins/com.is2t.eclipse.plugin.easyant4e_2.3.1.202012101611.jar' && \
    unzip plugins/com.is2t.eclipse.plugin.easyant4e_2.3.1.202012101611.jar lib/jdtCompilerAdapter.jar lib/org.eclipse.jdt.compiler.apt.jar lib/org.eclipse.jdt.core.jar -d $MICROEJ_BUILDKIT_HOME/buildKit/ant/ && \
    rm -rf microej-sdk-20.12-linux_x86_64.zip plugins && \
# V) Configure BuildKit
    echo "\neasyant.inject.build.compiler=org.eclipse.jdt.core.JDTCompilerAdapter" >> $MICROEJ_BUILDKIT_HOME/local-build.properties && \
    echo "\neasyant.inject.eclipse.home=${ECLIPSE_HOME}" >> $MICROEJ_BUILDKIT_HOME/local-build.properties && \
    echo 'sdk.version=4.1.5' > $MICROEJ_BUILDKIT_HOME/release.properties && \
    chown $user:$group $MICROEJ_BUILDKIT_HOME/local-build.properties && \
    chown -R $user:$group $MICROEJ_BUILDKIT_HOME/ivy && \
    mkdir $MICROEJ_BUILDKIT_HOME/cache && chown $user:$group $MICROEJ_BUILDKIT_HOME/cache

# Good practice, switch back to user.
USER ${user}