#!/bin/bash

export IMX_RELEASE="imx-6.1.22-2.0.0"

./docker-build.sh

./docker-run.sh ${IMX_RELEASE}/yocto-build.sh
