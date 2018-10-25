#!/bin/bash

# this file must be sourced *NOT* executed

PREFIX="${HOME}/OPAL"
export DOWNLOADS_DIR="${PREFIX}/Downloads"
export SRC_DIR="${PREFIX}/src"

PATH="${PREFIX}/bin:${PATH}"

if [[ -z "${C_INCLUDE_PATH}" ]]; then
      C_INCLUDE_PATH="${PREFIX}/include"
else
      C_INCLUDE_PATH="${PREFIX}/include:${C_INCLUDE_PATH}"
fi

if [[ -z "${CPLUS_INCLUDE_PATH}" ]]; then
      CPLUS_INCLUDE_PATH="${PREFIX}/include"
else
      CPLUS_INCLUDE_PATH="${PREFIX}/include:${CPLUS_INCLUDE_PATH}"
fi

if [[ -z "${LIBRARY_PATH}" ]]; then
      LIBRARY_PATH="${PREFIX}/lib:${PREFIX}/lib64"
else
      LIBRARY_PATH="${PREFIX}/lib:${PREFIX}/lib64:${LIBRARY_PATH}"
fi

if [[ -z "${LD_LIBRARY_PATH}" ]]; then
      LD_LIBRARY_PATH="${PREFIX}/lib:${PREFIX}/lib64"
else
      LD_LIBRARY_PATH="${PREFIX}/lib:${PREFIX}/lib64:${LD_LIBRARY_PATH}"
fi

export C_INCLUDE_PATH
export CPLUS_INCLUDE_PATH
export LIBRARY_PATH
export LD_LIBRARY_PATH

if [[ -z "${BOOST_DIR}" ]] && [[ -z "${BOOST_ROOT}" ]]; then
        export BOOST_DIR="${PREFIX}"
fi

export NJOBS=4

mkdir -p "${PREFIX}"
mkdir -p "${DOWNLOADS_DIR}"
mkdir -p "${SRC_DIR}"
