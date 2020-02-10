export TOOLSET=gcc
export TOOLSET_SUFFIX='-mp-9'
export MPI_IMPLEMENTATION=openmpi

declare -ra recipes=(
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
