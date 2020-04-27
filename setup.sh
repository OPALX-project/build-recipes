#!/bin/bash

declare my_dir=$(dirname "${BASH_SOURCE[0]}")
my_dir=$(cd "${my_dir}"; pwd)

declare -ix BUILD_ERR_ARG=1
declare -ix BUILD_ERR_SETUP=2
declare -ix BUILD_ERR_SYSTEM=3
declare -ix BUILD_ERR_DOWNLOAD=4
declare -ix BUILD_ERR_UNTAR=5
declare -ix BUILD_ERR_CONFIGURE=6
declare -ix BUILD_ERR_MAKE=7
declare -ix BUILD_ERR_INSTALL=8

usage(){
	echo "
Usage:
    source ${BASH_SOURCE[0]} [--prefix DIR] [CONFIG_FILE]
" 1>&2
	return ${BUILD_ERR_ARG}
}

if [[ $_ == $0 ]]; then
	echo "This file must be sourced not executed!"
	usage
	exit $?
fi

while (($# > 0)); do
	case $1 in
	--prefix )
		PREFIX="$2"
		shift 1
		;;
	-h | --help | -\? )
		usage
		return $?
		;;
	-* )
		echo "Illegal option -- $1" 1>&2
		usage
		return $?
		;;
	* )
		if [[ ! -r "$1" ]]; then
			echo "File doesn't exist or is not readable -- $1" 1>&2
			return ${BUILD_ERR_ARG}
		fi
		source "$1" || return ${BUILD_ERR_SETUP}
		;;
	esac
	shift 1
done

#
# TOOLSET is used in the boost build recipe
#
if [[ -z "${TOOLSET}" ]]; then
	if [[ $(uname -s) == 'Darwin' ]]; then
		export TOOLSET='clang'
	else
		export TOOLSET='gcc'
	fi
	echo "TOOLSET not set, using '${TOOLSET}'!" 1>&2
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

mkdir -p "${PREFIX}/lib" "${DOWNLOADS_DIR}" "${SRC_DIR}" || return ${BUILD_ERR_SETUP}

if [[ "$(uname -s)" == "Linux" ]]; then
	( cd "${PREFIX}" && ln -fs lib lib64 || return ${BUILD_ERR_SETUP};)
	LIBRARY_PATH+=":${PREFIX}/lib64"
	LD_LIBRARY_PATH+=":${PREFIX}/lib64"
fi

unset OPAL_PREFIX

echo "Using:"
echo "    Prefix:             ${PREFIX}"
echo "    Toolset:            ${TOOLSET}"
