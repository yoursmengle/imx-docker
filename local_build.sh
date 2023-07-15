#!/bin/bash

export IMX_RELEASE="imx-6.1.22-2.0.0"

rm env.sh
ln -s ${IMX_RELEASE}/env.sh env.sh

rm yocto-build.sh
ln -s ${IMX_RELEASE}/yocto-build.sh

. ./env.sh
cd ${YOCTO_DIR}

export BB_ENV_PASSTHROUGH_ADDITIONS="DL_DIR SSTATE_DIR"
export DL_DIR=/opt/yocto/data_cache/downloads
export SSTATE_DIR=/opt/yocto/data_cache/sstate-cache

EULA=1 MACHINE="${MACHINE}" DISTRO="${DISTRO}" source imx-setup-release.sh -b build_${DISTRO}
bitbake ${IMAGES}
