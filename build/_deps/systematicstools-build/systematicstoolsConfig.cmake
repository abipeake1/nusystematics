
####### Expanded from @PACKAGE_INIT@ by configure_package_config_file() #######
####### Any changes to this file will be overwritten by the next CMake run ####
####### The input file was systematicstoolsConfig.cmake.in                            ########

get_filename_component(PACKAGE_PREFIX_DIR "${CMAKE_CURRENT_LIST_DIR}/../" ABSOLUTE)

####################################################################################

set(systematicstools_VERSION 23.06)

find_package(ROOT 6.10 REQUIRED)
find_package(fhiclcpp 4.17.01 REQUIRED)

include(${CMAKE_CURRENT_LIST_DIR}/systtools-targets.cmake)

set(systematicstools_FOUND TRUE)

if(NOT TARGET systtools::all)
  message(WARNING "Expected to find target systtools::all in ${CMAKE_CURRENT_LIST_DIR}/systtools-targets.cmake")
  set(systematicstools_FOUND FALSE)
  return()
endif()
