#!/bin/bash

shopt -s nullglob

if [[ -n "$1" ]]; then
        if [[ -d "$1" ]]; then
                OTB_PREFIX="$1"
        else
                echo -e "Passed prefix does not exist or is not a directory -- $1" 1>&2
		exit 1
	fi
fi
if [[ -z "${OTB_PREFIX}" ]]; then
	echo -e "OTB_PREFIX not set!\nAborting..." 1>&2
	exit 1
fi

mydir="$(cd $(dirname -- "$0") && pwd)"

#
# remove all libtool .la files
# Libtool creates .la files which are not relocatable. Till now
# I do not know how to make them relecatable. Since we dont need
# them to compile OPAL, they are removed. 
#
find ${OTB_PREFIX} -name "*.la" -exec rm {} \; 

#
# make script 'gsl-config' relocatable
#
sed_expr=''
sed_expr+='s|^prefix=.*|prefix=\$(cd \$(dirname \$0) \&\& pwd)|g;'
sed_expr+='s|'"${OTB_PREFIX}"'|\"${prefix}\"|g;'
sed -i.bak "${sed_expr}" "${OTB_PREFIX}/bin/gsl-config"

#
# make script HDF5 wrappers relocatable
#
for f in h5c++ h5pcc; do
	sed -i.bak 's|^prefix=.*|prefix="\$(cd "\$(dirname \$0)/.." \&\& pwd)"|' "${OTB_PREFIX}/bin/$f"
done

#
# cleanup backup files in bin
#
rm -f "${OTB_PREFIX}/bin/*.bak"

#
# make pkg-config files relocatable
#
sed_expr=''
sed_expr+='s|^prefix=.*|prefix=${pcfiledir}/../..|g;'
sed_expr+='s|'"${OTB_PREFIX}"'|\"${prefix}\"|g;'
sed_expr+='s|^prefix=.*|prefix=${pcfiledir}/../..|g;'
sed_expr+='s|'"${OTB_PREFIX}"'|\"${prefix}\"|g;'
for f in "${OTB_PREFIX}"/lib/pkgconfig/*.pc; do
	sed -i.bak "${sed_expr}" "$f"
done
rm -f "${OTB_PREFIX}"/lib/pkgconfig/*.pc.bak

#
# make Trilinos exported Makefiles relocatable
#
patch_Trilinos() {
	sed_expr=''
	sed_expr+='s|_CXX_COMPILER='"${OTB_PREFIX}"'|_CXX_COMPILER:=$(abspath $(dir $(lastword $(MAKEFILE_LIST)))/..)|g;'
	sed_expr+='s|_C_COMPILER='"${OTB_PREFIX}"'|_C_COMPILER:=$(abspath $(dir $(lastword $(MAKEFILE_LIST)))/..)|g;'
	sed_expr+='s|_FORTRAN_COMPILER='"${OTB_PREFIX}"'|_FORTRAN_COMPILER:=$(abspath $(dir $(lastword $(MAKEFILE_LIST)))/..)|g;'
	sed_expr+='s|_Fortran_COMPILER='"${OTB_PREFIX}"'|_Fortran_COMPILER:=$(abspath $(dir $(lastword $(MAKEFILE_LIST)))/..)|g;'
	sed_expr+='s|_MPI_EXEC='"${OTB_PREFIX}"'|_MPI_EXEC:=$(abspath $(dir $(lastword $(MAKEFILE_LIST)))/..)|g;'
	sed_expr+='s|_INCLUDE_DIRS= -I'"${OTB_PREFIX}"'|_INCLUDE_DIRS:= -I$(abspath $(dir $(lastword $(MAKEFILE_LIST)))/..)|g;'
	sed_expr+='s| -I'"${OTB_PREFIX}"'||g;'
	sed_expr+='s|_LIBRARY_DIRS= '-L"${OTB_PREFIX}"'|_LIBRARY_DIRS:= -L$(abspath $(dir $(lastword $(MAKEFILE_LIST)))/..)|g;'
	sed_expr+='s|_TPL_LIBRARIES= '"${OTB_PREFIX}"'|_TPL_LIBRARIES:= $(abspath $(dir $(lastword $(MAKEFILE_LIST)))/..)|g;'
	sed_expr+='s|_CXX_COMPILER_FLAGS=|_CXX_COMPILER_FLAGS:=|g;'
	sed_expr+='s|'"${OTB_PREFIX}"'|$(abspath $(dir $(lastword $(MAKEFILE_LIST)))/..)|g'
	for f in "${OTB_PREFIX}"/include/Makefile.export.*; do
		sed -i.bak "${sed_expr}" "$f"
	done
	rm -f "${OTB_PREFIX}"/include/Makefile.export.*.bak
}

#
# strip binaries
#
strip_unneeded() {
	for f in "${OTB_PREFIX}/bin/"*; do
		file "$f" | grep -q "ELF 64-bit" && strip --strip-unneeded "$f"
	done
	for f in "${OTB_PREFIX}"/libexec/gcc/x86_64*/*/*; do
		file "$f" | grep -q "ELF 64-bit" && strip --strip-unneeded "$f"
	done
}

#
# make CMake files relocatable
#
make_cmake_module_relocatable() {
	cmake -DPREFIX="${OTB_PREFIX}" -P "${mydir}"/make_relocatable.cmake
}

patch_Trilinos
strip_unneeded
make_cmake_module_relocatable

