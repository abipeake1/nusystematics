
####### Expanded from @PACKAGE_INIT@ by configure_package_config_file() #######
####### Any changes to this file will be overwritten by the next CMake run ####
####### The input file was fhiclcppConfig.cmake.in                            ########

get_filename_component(PACKAGE_PREFIX_DIR "${CMAKE_CURRENT_LIST_DIR}/../" ABSOLUTE)

####################################################################################

find_package(linedoc REQUIRED)

set(fhiclcpp_VERSION 23.6)

include(${CMAKE_CURRENT_LIST_DIR}/fhiclcppTargets.cmake)
if(NOT TARGET fhiclcpp::includes)
  message(WARNING "Expected to find target fhiclcpp::includes in ${CMAKE_CURRENT_LIST_DIR}/fhiclcppTargets.cmake")
  set(fhiclcpp_FOUND FALSE)
  return()
endif()

get_filename_component(fhiclcpp_CMAKE_DIR "${CMAKE_CURRENT_LIST_FILE}" PATH)

find_path(fhiclcpp_INCLUDE_DIR
  NAMES fhiclcpp/fhicl_doc.hxx
  PATHS ${fhiclcpp_CMAKE_DIR}/../../../include
)

find_path(fhiclcpp_PREFIX
  NAMES bin/setup.fhiclcpp.sh
  PATHS ${fhiclcpp_CMAKE_DIR}/../../../
)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(fhiclcpp
    REQUIRED_VARS 
      fhiclcpp_INCLUDE_DIR 
      fhiclcpp_PREFIX
    VERSION_VAR 
      fhiclcpp_VERSION
)

message(STATUS "Found fhiclcpp Version: ${fhiclcpp_VERSION} in \"${fhiclcpp_CMAKE_DIR}\"")
message(STATUS "    fhiclcpp_INCLUDE_DIR: ${fhiclcpp_INCLUDE_DIR}")
message(STATUS "    fhiclcpp_PREFIX: ${fhiclcpp_PREFIX}")
