#!/bin/bash

#
# Copyright 2023 MicroEJ Corp. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be found with this software.
#

set -e

if [ "$ACCEPT_MICROEJ_SDK_EULA_V3_1B" != "yes" ] && [ "$ACCEPT_MICROEJ_SDK_EULA_V3_1B" != "YES" ]
then
    echo  ""
    echo "##############################################################"
    echo "##### The MICROEJ SDK End-User License Agreement (EULA) must be accepted before it can start."
    echo "##### The license terms for this product can be downloaded from "
    echo "##### https://repository.microej.com/licenses/sdk/LAW-0011-LCS-MicroEJ_SDK-EULA-v3.1B.txt"
    echo "##### You can accept the EULA by setting the ACCEPT_MICROEJ_SDK_EULA_V3_1B=YES environment variable"
    echo "##############################################################"
    echo ""
    exit -1
fi

exec "$@"