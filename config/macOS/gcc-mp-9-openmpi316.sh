export OTB_TOOLSET=gcc
export OTB_MPI=openmpi

declare -a OTB_RECIPES=(
	050-build-cmake
	060-build-openmpi
	070-build-hdf5
	080-build-gsl
	090-build-h5hut
	100-build-zlib
	110-build-boost
	200-build-parmetis
	210-build-openblas
	220-build-trilinos
	300-build-gtest)

declare -A OTB_SYMLINKS
OTB_SYMLINKS['cc']='/opt/local/bin/gcc-mp-9'
OTB_SYMLINKS['c++']='/opt/local/bin/g++-mp-9'
OTB_SYMLINKS['gcc']='/opt/local/bin/gcc-mp-9'
OTB_SYMLINKS['g++']='/opt/local/bin/g++-mp-9'
OTB_SYMLINKS['gfortran']='/opt/local/bin/gfortran-mp-9'
