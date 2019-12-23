export TOOLSET=gcc
export MPI_IMPLEMENTATION=openmpi
export PREFIX="${PREFIX:=${HOME}/OPAL-gcc920-openmpi}"
export GCC_VERSION=9.2.0

test -r "$(dirname ${BASH_SOURCE[0]})/setup.sh" && source "$_"

