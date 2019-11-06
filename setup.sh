#!/bin/bash

# this file must be sourced *NOT* executed

my_dir=$(dirname "${BASH_SOURCE}")

source "${my_dir}/config.sh"

export PREFIX="${PREFIX:-${HOME}/OPAL}"
export DOWNLOADS_DIR="${DOWNLOADS_DIR:-${PREFIX}/Downloads}"
export SRC_DIR="${SRC_DIR:-${PREFIX}/src}"
export NJOBS="${NJOBS:-4}"

PATH="${PREFIX}/bin:${PATH}"

export C_INCLUDE_PATH="${PREFIX}/include"
export CPLUS_INCLUDE_PATH="${PREFIX}/include"
export LIBRARY_PATH="${PREFIX}/lib:${PREFIX}/lib64"
export LD_LIBRARY_PATH="${PREFIX}/lib:${PREFIX}/lib64"

export BOOST_DIR="${PREFIX}"
export BOOST_ROOT="${PREFIX}"


mkdir -p "${PREFIX}/lib"
mkdir -p "${DOWNLOADS_DIR}"
mkdir -p "${SRC_DIR}"

( cd $PREFIX; ln -fs lib lib64;)

