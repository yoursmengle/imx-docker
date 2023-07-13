#!/bin/bash
# This script will run into container

# source the common variables

. imx-6.1.22-2.0.0/env.sh
cat  imx-6.1.22-2.0.0/env.sh
#

mkdir -p ${YOCTO_DIR}
cd ${YOCTO_DIR}

# Init

repo init \
    -u ${REMOTE} \
    -b ${BRANCH} \
    -m ${MANIFEST}

repo sync -j`nproc`

# source the yocto env

EULA=1 MACHINE="${MACHINE}" DISTRO="${DISTRO}" source imx-setup-release.sh -b build_${DISTRO}

echo "MACHINE=${MACHINE}"

# Build

bitbake ${IMAGES}

