export OTB_TOOLSET=gcc
export OTB_MPI=openmpi
export OTB_COMPILER_VERSION=8.4.0
export OTB_MPI_VERSION=3.1.6

declare -a OTB_RECIPES=(
	010-build-gmp
	020-build-mpfr
	030-build-mpc
	040-build-gcc
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
