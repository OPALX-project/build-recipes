export TOOLSET=gcc
export MPI_IMPLEMENTATION=openmpi
export PREFIX="${PREFIX:=${HOME}/OPAL-gcc-openmpi}"

test -r "$(dirname '${BASH_SOURCE}')/setup.sh" && source "$_"

