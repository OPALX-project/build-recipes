#!/bin/bash

# this file must be sourced *NOT* executed

export PREFIX="${HOME}/OPAL"
export DOWNLOADS_DIR="${PREFIX}/Downloads"
export SRC_DIR="${PREFIX}/src"

PATH="${PREFIX}/bin:${PATH}"

export C_INCLUDE_PATH="${PREFIX}/include"
export CPLUS_INCLUDE_PATH="${PREFIX}/include"
export LIBRARY_PATH="${PREFIX}/lib:${PREFIX}/lib64"
export LD_LIBRARY_PATH="${PREFIX}/lib:${PREFIX}/lib64"

export BOOST_DIR="${PREFIX}"
export BOOST_ROOT="${PREFIX}"

export NJOBS=4

mkdir -p "${PREFIX}/lib"
mkdir -p "${DOWNLOADS_DIR}"
mkdir -p "${SRC_DIR}"

( cd $PREFIX; ln -s lib lib64;)

