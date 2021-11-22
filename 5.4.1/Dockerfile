# Dockerfile
#
# Copyright 2021 MicroEJ Corp. All rights reserved.
# This library is provided in source code for use, modification and test, subject to license terms.
# Any modification of the source code will break MicroEJ Corp. warranties on the whole library.
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
ENV BUILD_KIT_HOME=/opt/buildKit
ENV PATH=$BUILD_KIT_HOME/bin:$PATH

# Set workdir
WORKDIR ${HOME}

# I) Install SDK
RUN curl -O https://repository.microej.com/packages/SDK/21.03/zip/microej-sdk-21.03-linux_x86_64.zip && \
    mkdir -p $ECLIPSE_HOME && \
    unzip microej-sdk-21.03-linux_x86_64.zip -d $ECLIPSE_HOME && \
    rm -f microej-sdk-21.03-linux_x86_64.zip && \
# II) Configure SDK location
    mkdir -p $HOME/.microej && \
    chown $user:$group $HOME/.microej && \
    echo "[options]\neclipse.home=\"${ECLIPSE_HOME}\"" > $HOME/.microej/.mmmconfig && \
# III) Update SDK to 5.4.1
#    1. Uninstall SDK 5.4.0
    $ECLIPSE_HOME/MicroEJ-SDK \
    -application org.eclipse.equinox.p2.director \
    -noSplash \
    -uninstallIU \
    com.is2t.microej.sdk.feature.feature.group && \
#    2. Install SDK 5.4.1
    $ECLIPSE_HOME/MicroEJ-SDK \
    -application org.eclipse.equinox.p2.director \
    -noSplash \
    -repository \
    https://repository.microej.com/p2/sdk/5.4.1 \
    -installIUs \
    com.is2t.microej.sdk.feature.feature.group && \
# IV) Extract Build Kit from SDK
    mkdir -p $BUILD_KIT_HOME && \
#     1. Extract build repository
    unzip $ECLIPSE_HOME/plugins/com.is2t.eclipse.plugin.easyant4e.offlinerepo_1.6.1.202104161741.jar repositories/microej-build-repository.zip && \
    unzip repositories/microej-build-repository.zip -d $BUILD_KIT_HOME/microej-build-repository && \
    rm -rf repositories/ && \
#     2. Extract mmm-cli
    unzip $ECLIPSE_HOME/plugins/com.is2t.eclipse.plugin.easyant4e_2.4.0.202104161741.jar cli/mmm-cli.zip && \
    unzip cli/mmm-cli.zip -d $BUILD_KIT_HOME/ && \
    rm -rf cli && \
#     3. Extract ivysettings
    unzip $ECLIPSE_HOME/plugins/com.is2t.eclipse.plugin.easyant4e_2.4.0.202104161741.jar resources/microej-ivysettings-5.4.xml && \
    mkdir -p $BUILD_KIT_HOME/microej-module-repository/ && \
    mv resources/microej-ivysettings-5.4.xml $BUILD_KIT_HOME/microej-module-repository/ivysettings.xml && \
    rm -rf resources/ && \
#     4. Set SDK version
    echo 'sdk.version=5.4.1' > $BUILD_KIT_HOME/release.properties && \
    mkdir -p $HOME/.microej/build-repository-cache && \
    ln -s $HOME/.microej/build-repository-cache $BUILD_KIT_HOME/microej-build-repository/cache && \
    chown $user:$group $BUILD_KIT_HOME/microej-build-repository/cache

# Good practice, switch back to user.
USER ${user}