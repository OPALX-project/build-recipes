#!/bin/bash

declare my_dir=$(dirname "${BASH_SOURCE[0]}")
my_dir=$(cd "${my_dir}"; pwd)

usage(){
	echo "
Usage:
    source ${BASH_SOURCE[0]} CONFIG_FILE
" 1>&2
	return 1
}

if [[ $_ == $0 ]]; then
	echo "This file must be sourced not executed!"
	usage
	exit $?
fi

if [[ -n "$1" ]]; then
	source "$1"
fi

#
# TOOLSET is used in the boost build recipe
#
if [[ -z "${TOOLSET}" ]]; then
	echo "TOOLSET not set, using gcc!" 1>&2
	export TOOLSET='gcc'
fi

for ((i=0; i<${#recipes[@]}; i++)); do
    recipes[i]="${my_dir}/${recipes[i]}"
done

unset my_dir

export PREFIX="${PREFIX:-${HOME}/OPAL}"
export DOWNLOADS_DIR="${PREFIX}/tmp/Downloads"
export SRC_DIR="${PREFIX}/tmp/src"
export PATH="${PREFIX}/bin:${PATH}"

export C_INCLUDE_PATH="${PREFIX}/include"
export CPLUS_INCLUDE_PATH="${PREFIX}/include"
export LIBRARY_PATH="${PREFIX}/lib"
export LD_LIBRARY_PATH="${PREFIX}/lib"

export BOOST_DIR="${PREFIX}"
export BOOST_ROOT="${PREFIX}"

ncores=$(getconf _NPROCESSORS_ONLN)
[[ ${ncores} > 10 ]] && ncores=10
export NJOBS=${NJOBS:-${ncores}}

mkdir -p "${PREFIX}/lib"
mkdir -p "${DOWNLOADS_DIR}"
mkdir -p "${SRC_DIR}"

if [[ "$(uname -s)" == "Linux" ]]; then
	( cd $PREFIX; ln -fs lib lib64;)
	LIBRARY_PATH+=":${PREFIX}/lib64"
	LD_LIBRARY_PATH+=":${PREFIX}/lib64"
fi

unset OPAL_PREFIX

echo "Using:"
echo "    Prefix:             ${PREFIX}"
echo "    Toolset:            ${TOOLSET}"
