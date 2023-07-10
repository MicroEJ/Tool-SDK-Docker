# Dockerfile
#
# Copyright 2023 MicroEJ Corp. All rights reserved.
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
    libwebkit2gtk-4.0-37 && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean

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
ENV BUILD_KIT_HOME=/opt/buildKit
ENV PATH=$BUILD_KIT_HOME/bin:$PATH

# Set workdir
WORKDIR ${HOME}

# I) Install SDK
RUN curl -O https://repository.microej.com/packages/SDK/23.07/zip/microej-sdk-23.07-linux_x86_64.zip && \
    mkdir -p $ECLIPSE_HOME && \
    unzip microej-sdk-23.07-linux_x86_64.zip -d $ECLIPSE_HOME && \
    rm -f microej-sdk-23.07-linux_x86_64.zip && \
# II) Configure SDK location
    mkdir -p $HOME/.microej && \
    chown $user:$group $HOME/.microej && \
    echo "[options]\neclipse.home=\"${ECLIPSE_HOME}\"" > $HOME/.microej/.mmmconfig && \
# III) Extract Build Kit from SDK
	mkdir -p $BUILD_KIT_HOME && \
#     1. Extract build repository
    unzip $ECLIPSE_HOME/plugins/com.is2t.eclipse.plugin.easyant4e.offlinerepo_1.6.1.202307031455.jar repositories/microej-build-repository.zip && \
    unzip repositories/microej-build-repository.zip -d $BUILD_KIT_HOME/microej-build-repository && \
    rm -rf repositories/ && \
#     2. Extract mmm-cli
    unzip $ECLIPSE_HOME/plugins/com.is2t.eclipse.plugin.easyant4e_2.7.1.202307031455.jar cli/mmm-cli.zip && \
    unzip cli/mmm-cli.zip -d $BUILD_KIT_HOME/ && \
    rm -rf cli && \
#     3. Extract ivysettings
    unzip $ECLIPSE_HOME/plugins/com.is2t.eclipse.plugin.easyant4e_2.7.1.202307031455.jar resources/microej-ivysettings-5.4.xml && \
    mkdir -p $BUILD_KIT_HOME/microej-module-repository/ && \
    mv resources/microej-ivysettings-5.4.xml $BUILD_KIT_HOME/microej-module-repository/ivysettings.xml && \
    rm -rf resources/ && \
#     4. Set SDK version
    echo 'sdk.version=5.8.0' > $BUILD_KIT_HOME/release.properties && \
    mkdir -p $HOME/.microej/build-repository-cache && \
    ln -s $HOME/.microej/build-repository-cache $BUILD_KIT_HOME/microej-build-repository/cache && \
    chown $user:$group $BUILD_KIT_HOME/microej-build-repository/cache

# Good practice, switch back to user.
USER ${user}
