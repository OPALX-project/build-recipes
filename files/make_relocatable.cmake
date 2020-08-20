# This script fixes the absolute paths, which reference a file within
# a tree (usually the install dir).
#
# It's only input parameter is the root directory (usually the dir set as
# CMAKE_INSTALL_PREFIX).
#
# First it globs all the *.cmake file within the directory.
# Scans them for the root dir.
# If found, introduces a new INSTALL_PREFIX_... variable in the script,
# derived from the location of that script and replaces all references to
# the root dir with that variable.
#
# Input parameters
# PREFIX: the directory under which this operation should be performed
#   usually this is the CMAKE_INSTALL_PREFIX of cmake-install step
#
# Example:
#
#    cmake -DPREFIX=/alpha/bravo -P make_relocatable.cmake
#
# If a config module /alpha/bravo/lib/cmake/delta/delta-config.cmake references
# the file /alpha/bravo/lib/delta.lib then a new variable will be
# introduced:
#
#     get_filename_component(INSTALL_PREFIX_bifu29
#       "${CMAKE_CURRENT_LIST_DIR}/../../../" ABSOLUTE)
#
# and the reference is replaced by ${INSTALL_PREFIX_bifu29}/lib/delta.lib

string(REGEX REPLACE "/$" "" PREFIX "${PREFIX}")

message(STATUS "Replacing absolute paths to relative in ${PREFIX}")

if(NOT IS_ABSOLUTE "${PREFIX}")
  message(FATAL_ERROR "PREFIX must be an absolute path")
endif()

# glob recurse
# - the *.cmake files
# - the directories, sorted by decreasing length
file(GLOB_RECURSE files "${PREFIX}/*.cmake")
list(LENGTH files nfiles)
message(STATUS "Found ${nfiles} files.")

foreach(file IN LISTS files)
  get_filename_component(file_dir "${file}" DIRECTORY)
  file(READ "${file}" content)
  if(content MATCHES "${PREFIX}")
    message(STATUS "Changing ${file}.")
    string(RANDOM random)
    set(var_name "INSTALL_PREFIX_${random}")
    file(RELATIVE_PATH file_dir_to_PREFIX "${file_dir}" "${PREFIX}")
    set(first_line "get_filename_component(${var_name} \"\${CMAKE_CURRENT_LIST_DIR}/${file_dir_to_PREFIX}\" ABSOLUTE)")
    message(STATUS "${file}:")
    message(STATUS "\tAdd first line: ${first_line}")
    set(content "${first_line}\n${content}")
    set(replace_string "\${${var_name}}")
    message(STATUS "\tReplace ${PREFIX} -> ${replace_string}")
    string(REGEX REPLACE "${PREFIX}" "${replace_string}" content "${content}")
    file(WRITE "${file}" "${content}")
  endif()
endforeach()
