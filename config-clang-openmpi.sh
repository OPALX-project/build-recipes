export TOOLSET=clang
export MPI_IMPLEMENTATION=openmpi

#export MACOSX_DEPLOYMENT_TARGET=10.14

declare -a recipes=(
	050-build-cmake
	060-build-open-mpi
	070-build-hdf5
	080-build-gsl
	090-build-h5hut
	100-build-zlib
	110-build-boost
	200-build-parmetis
	210-build-openblas
	220-build-trilinos
	300-build-gtest)

