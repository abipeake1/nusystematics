
####### Expanded from @PACKAGE_INIT@ by configure_package_config_file() #######
####### Any changes to this file will be overwritten by the next CMake run ####
####### The input file was linedocConfig.cmake.in                            ########

get_filename_component(PACKAGE_PREFIX_DIR "${CMAKE_CURRENT_LIST_DIR}/../" ABSOLUTE)

####################################################################################

set(linedoc_VERSION 23.6)

include(${CMAKE_CURRENT_LIST_DIR}/linedocTargets.cmake)
if(NOT TARGET linedoc::includes)
  message(WARNING "Expected to find target linedoc::includes in ${CMAKE_CURRENT_LIST_DIR}/linedocTargets.cmake")
  set(linedoc_FOUND FALSE)
  return()
endif()

get_filename_component(linedoc_CMAKE_DIR "${CMAKE_CURRENT_LIST_FILE}" PATH)

find_path(linedoc_INCLUDE_DIR
  NAMES linedoc/doc.hxx
  PATHS ${linedoc_CMAKE_DIR}/../../../include
)

find_path(linedoc_PREFIX
  NAMES bin/setup.linedoc.sh
  PATHS ${linedoc_CMAKE_DIR}/../../../
)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(linedoc
    REQUIRED_VARS 
      linedoc_INCLUDE_DIR 
      linedoc_PREFIX
    VERSION_VAR 
      linedoc_VERSION
)

message(STATUS "Found linedoc Version: ${linedoc_VERSION} in \"${linedoc_CMAKE_DIR}\"")
message(STATUS "    linedoc_INCLUDE_DIR: ${linedoc_INCLUDE_DIR}")
message(STATUS "    linedoc_PREFIX: ${linedoc_PREFIX}")
