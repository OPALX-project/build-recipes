export TOOLSET=gcc
export MPI_IMPLEMENTATION=openmpi

export PREFIX="${PREFIX:-${HOME}/OPAL-gcc-mp-9-openmpi}"

test -r "$(dirname '${BASH_SOURCE}')/setup.sh" && source "$_"
