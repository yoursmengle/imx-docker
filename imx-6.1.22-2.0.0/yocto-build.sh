#!/bin/bash
# This script will run into container

# source the common variables

. imx-6.1.22-2.0.0/env.sh
#

mkdir -p ${YOCTO_DIR}
cd ${YOCTO_DIR}

# get repo
if [ ! -d git-repo ]; then
    git clone https://gerrit-googlesource.proxy.ustclug.org/git-repo
fi
export PATH=${YOCTO_DIR}/git-repo:${PATH}

# Init

repo init \
    -u ${REMOTE} \
    -b ${BRANCH} \
    -m ${MANIFEST}

repo sync -j`nproc`

# source the yocto env

EULA=1 MACHINE="${MACHINE}" DISTRO="${DISTRO}" source imx-setup-release.sh -b build_${DISTRO}

# Build

bitbake ${IMAGES}

