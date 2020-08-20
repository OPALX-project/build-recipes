pathmunge () {
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

export OPAL_PREFIX=$(cd "$(dirname ${BASH_SOURCE})/../../"; pwd )
export LD_LIBRARY_PATH
export LIBRARY_PATH
export DYLD_LIBRARY_PATH
export C_INCLUDE_PATH
export CPLUS_INCLUDE_PATH
export HDF5_ROOT="${OPAL_PREFIX}"
export BOOST_ROOT="${OPAL_PREFIX}"
export BOOST_DIR="${OPAL_PREFIX}"
#export TERMINFO="${OPAL_PREFIX}/share/terminfo"

pathmunge PATH		  "${OPAL_PREFIX}/bin"
pathmunge C_INCLUDE_PATH  "${OPAL_PREFIX}/include"
pathmunge CPLUS_INCLUDE_PATH  "${OPAL_PREFIX}/include"
pathmunge LD_LIBRARY_PATH "${OPAL_PREFIX}/lib"
pathmunge LIBRARY_PATH    "${OPAL_PREFIX}/lib"

if [[ -d /usr/lib/x86_64-linux-gnu ]]; then
	pathmunge LIBRARY_PATH "/usr/lib/x86_64-linux-gnu"
fi

DYLD_LIBRARY_PATH=${LD_LIBRARY_PATH}
