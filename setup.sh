#!/bin/bash

# this file must be sourced *NOT* executed

export PREFIX="${PREFIX:-${HOME}/OPAL}"
export DOWNLOADS_DIR="${PREFIX}/tmp/Downloads"
export SRC_DIR="${PREFIX}/tmp/src"
export PATH="${PREFIX}/bin:${PATH}"

test -z "${TOOLSET}" && export TOOLSET='gcc'

export C_INCLUDE_PATH="${PREFIX}/include"
export CPLUS_INCLUDE_PATH="${PREFIX}/include"
export LIBRARY_PATH="${PREFIX}/lib"
export LD_LIBRARY_PATH="${PREFIX}/lib"

export BOOST_DIR="${PREFIX}"
export BOOST_ROOT="${PREFIX}"

export NJOBS=${NJOBS:-4}

mkdir -p "${PREFIX}/lib"
mkdir -p "${DOWNLOADS_DIR}"
mkdir -p "${SRC_DIR}"

if [[ "$(uname -s)" == "Linux" ]]; then
	( cd $PREFIX; ln -fs lib lib64;)
	LIBRARY_PATH+=":${PREFIX}/lib64"
	LD_LIBRARY_PATH+=":${PREFIX}/lib64"
fi

echo "Using:"
echo "    Prefix:             ${PREFIX}"
echo "    Toolset:            ${TOOLSET}"
echo "    MPI implementation: ${MPI_IMPLEMENTATION}"
