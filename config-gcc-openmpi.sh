export TOOLSET=gcc
export MPI_IMPLEMENTATION=openmpi
export PREFIX="${PREFIX:=${HOME}/OPAL-${TOOLSET}-${MPI_IMPLEMENTATION}}"

declare dir="$(cd $(dirname '${dir}'); pwd)"

declare -xa recipes=(
	${dir}/010-build-gmp
	${dir}/020-build-mpfr
	${dir}/030-build-mpc
	${dir}/040-build-gcc
	${dir}/050-build-cmake
	${dir}/060-build-open-mpi
	${dir}/070-build-hdf5
	${dir}/080-build-gsl
	${dir}/090-build-h5hut
	${dir}/100-build-zlib
	${dir}/110-build-boost
	${dir}/200-build-parmetis
	${dir}/210-build-openblas
	${dir}/220-build-trilinos
	${dir}/300-build-gtest)

test -r "${dir}/setup.sh" && source "$_"

