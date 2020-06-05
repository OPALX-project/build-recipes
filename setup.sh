#!/bin/bash

if [[ $_ == $0 ]]; then
	echo "This file must be sourced not executed!"
	exit 1
fi


declare __my_dir=$(dirname "${BASH_SOURCE[0]}")
__my_dir=$(cd "${__my_dir}"; pwd)

declare -ix OTB_ERR_ARG=1
declare -ix OTB_ERR_SETUP=2
declare -ix OTB_ERR_SYSTEM=3
declare -ix OTB_ERR_DOWNLOAD=4
declare -ix OTB_ERR_UNTAR=5
declare -ix OTB_ERR_CONFIGURE=6
declare -ix OTB_ERR_MAKE=7
declare -ix OTB_ERR_PRE_INSTALL=8
declare -ix OTB_ERR_INSTALL=9
declare -ix OTB_ERR_POST_INSTALL=10
declare -ix OTB_ERR=255

__usage(){
	echo "
Usage:
    source ${BASH_SOURCE[0]} [--prefix DIR] [CONFIG_FILE]
" 1>&2
	return ${OTB_ERR_ARG}
}

#
# This function is used in the build recipes to trap EXIT.
#
# Note: we cannot use it in this script!
#
otb_exit() {
        local -i ec=$?
        local -i n=${#BASH_SOURCE[@]}
        local -r recipe_name="${BASH_SOURCE[n]}"
        echo -n "${recipe_name}: "
        if (( ec == 0 )); then
                echo "done!"
        elif (( ec == OTB_ERR_ARG )); then
                echo "argument error!"
        elif (( ec == OTB_ERR_SETUP )); then
                echo "error in setting everything up!"
        elif (( ec == OTB_ERR_SYSTEM )); then
                echo "unexpected systm error!"
        elif (( ec == OTB_ERR_DOWNLOAD )); then
                echo "error in downloading the source file!"
        elif (( ec == OTB_ERR_UNTAR )); then
                echo "error in un-taring the source file!"
        elif (( ec == OTB_ERR_CONFIGURE )); then
                echo "error in configuring the software!"
        elif (( ec == OTB_ERR_MAKE )); then
                echo "error in compiling the software!"
        elif (( ec == OTB_ERR_PRE_INSTALL )); then
                echo "error in pre-installing the software!"
        elif (( ec == OTB_ERR_INSTALL )); then
                echo "error in installing the software!"
        elif (( ec == OTB_ERR_POST_INSTALL )); then
                echo "error in post-installing the software!"
        else
                echo "oops, unknown error!!!"
        fi
        exit ${ec}
}

export -f otb_exit

__otb_path_munge () {
	path=$1
    	case ":${!path}:" in
        *:"$2":*)
            ;;
        *)
            if [ -z "${!path}" ] ; then
                eval ${path}=\"$2\"
            else
                eval ${path}=\"$2:${!path}\"
            fi
    esac
}

__otb_path_remove () {
        path=$1
        eval ${path}=\"${!path//:$2:/:}\"
        eval ${path}=\"${!path#$2:}\"
        eval ${path}=\"${!path%:$2}\"
}

declare config_file="${__my_dir}/config.sh"
if [[ ${__my_dir} == */etc/profile.d ]]; then
        if [[ -r ${config_file} ]]; then
                source "${config_file}"
                OTB_PREFIX=$(cd "${__my_dir}/../.." && pwd)
                
        fi
else
        while (($# > 0)); do
	        case $1 in
	                --prefix )
		                OTB_PREFIX="$2"
		                shift 1
		                ;;
	                -h | --help | -\? )
		                __usage
		                return $?
		                ;;
	                -* )
		                echo "Illegal option -- $1" 1>&2
		                __usage
		                return $?
		                ;;
	                * )
		                if [[ ! -r "$1" ]]; then
			                echo "File doesn't exist or is not readable -- $1" 1>&2
			                return ${OTB_ERR_ARG}
		                fi
		                source "$1" || return ${OTB_ERR_SETUP}
		                ;;
	        esac
	        shift 1
        done
fi

#
# OTB_TOOLSET is used in the boost build recipe
#
if [[ -z "${OTB_TOOLSET}" ]]; then
	if [[ $(uname -s) == 'Darwin' ]]; then
		export OTB_TOOLSET='clang'
	else
		export OTB_TOOLSET='gcc'
	fi
	echo "TOOLSET not set, using '${OTB_TOOLSET}'!" 1>&2
fi

#
# a list of recipes can be defined in a configuration file
#
for ((i=0; i<${#OTB_RECIPES[@]}; i++)); do
        OTB_RECIPES[i]="${__my_dir}/${OTB_RECIPES[i]}"
done

export OTB_PREFIX="${OTB_PREFIX:-${HOME}/OPAL}"
export OTB_DOWNLOAD_DIR="${OTB_PREFIX}/tmp/Downloads"
export OTB_SRC_DIR="${OTB_PREFIX}/tmp/src"
export OTB_PROFILE_DIR="${OTB_PREFIX}/etc/profile.d"

__otb_path_munge PATH "${OTB_PREFIX}/bin"

export C_INCLUDE_PATH="${OTB_PREFIX}/include"
export CPLUS_INCLUDE_PATH="${OTB_PREFIX}/include"
export LIBRARY_PATH="${OTB_PREFIX}/lib"
export LD_LIBRARY_PATH="${OTB_PREFIX}/lib"

export BOOST_DIR="${OTB_PREFIX}"
export BOOST_ROOT="${OTB_PREFIX}"
export HDF5_ROOT="${OTB_PREFIX}"

__ncores=$(getconf _NPROCESSORS_ONLN)
[[ ${__ncores} > 10 ]] && __ncores=10
export NJOBS=${NJOBS:-${__ncores}}

mkdir -p "${OTB_PREFIX}/lib" "${OTB_DOWNLOAD_DIR}" "${OTB_SRC_DIR}" \
        || return ${OTB_ERR_SETUP}

if [[ "$(uname -s)" == "Linux" ]]; then
	( cd "${OTB_PREFIX}" && ln -fs lib lib64 || return ${OTB_ERR_SETUP};)
	LIBRARY_PATH+=":${OTB_PREFIX}/lib64"
	LD_LIBRARY_PATH+=":${OTB_PREFIX}/lib64"
fi

if [[  ${__my_dir} != */etc/profile.d ]]; then
        mkdir -p "${OTB_PROFILE_DIR}"
        cp "${__my_dir}/files/opal.sh" "${OTB_PROFILE_DIR}"
        cp "${__my_dir}/setup.sh"      "${OTB_PROFILE_DIR}/otb_setup.sh"

        {
                echo "OTB_TOOLSET=${OTB_TOOLSET}"
                [[ -n ${OTB_COMPILER_VERSION} ]] && \
                        echo "OTB_COMPILER_VERSION=${OTB_COMPILER_VERSION}"
                echo "OTB_MPI=${OTB_MPI}"
                [[ -n ${OTB_MPI_VERSION} ]] && \
                        echo "OTB_MPI_VERSION=${OTB_MPI_VERSION}"
        }  > "${OTB_PROFILE_DIR}/config.sh"
fi

echo "Using:"
echo "    Prefix:       ${OTB_PREFIX}"
echo "    Compiler:     ${OTB_TOOLSET}"
[[ -n ${OTB_COMPILER_VERSION} ]] && \
        echo "    Version:      ${OTB_COMPILER_VERSION}"
echo "    MPI:          ${OTB_MPI}"
[[ -n ${OTB_MPI_VERSION} ]] && \
        echo "    Version:      ${OTB_MPI_VERSION}"

unset __my_dir
unset __ncores
unset __usage
unset __otb_path_munge
unset __otb_path_remove

# Local Variables:
# mode: shell-script-mode
# sh-basic-offset: 8
# End:

