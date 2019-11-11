export TOOLSET=clang
export MPI_IMPLEMENTATION=openmpi

export PREFIX="${HOME}/OPAL-clang-openmpi"

test -r "$(dirname '${BASH_SOURCE}')/setup.sh" && source "$_"

