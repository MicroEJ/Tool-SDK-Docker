#!/bin/bash

#
# Copyright 2023 MicroEJ Corp. All rights reserved.
# This library is provided in source code for use, modification and test, subject to license terms.
# Any modification of the source code will break MicroEJ Corp. warranties on the whole library.
#

set -e

if [ "$ACCEPT_MICROEJ_SDK_EULA" != "yes" ] && [ "$ACCEPT_MICROEJ_SDK_EULA" != "YES" ]
then
    echo  ""
    echo "##############################################################"
    echo "##### The MICROEJ SDK End-User License Agreement (EULA) must be accepted before it can start."
    echo "##### The license terms for this product can be downloaded from "
    echo "##### https://repository.microej.com/licenses/sdk/LAW-0011-LCS-MicroEJ_SDK-EULA-v3.1B.txt"
    echo "##### You can accept the EULA by setting the ACCEPT_MICROEJ_SDK_EULA=YES environment variable"
    echo "##############################################################"
    echo ""
    exit -1
fi

exec "$@"