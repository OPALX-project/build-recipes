#!/bin/bash

# this file must be sourced *NOT* executed

my_dir=$(dirname "${BASH_SOURCE}")

test -r "${my_dir}/config.sh" && source "$_"

export PREFIX="${PREFIX-${HOME}/OPAL}"
export DOWNLOADS_DIR="${PREFIX:=${HOME}/OPAL}/Downloads"
export SRC_DIR="${PREFIX}/src"
export PREFIX
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

if [[ "$(uname -s)" == "Linux" ]]; then
	( cd $PREFIX; ln -fs lib lib64;)
fi
