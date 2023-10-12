
####### Expanded from @PACKAGE_INIT@ by configure_package_config_file() #######
####### Any changes to this file will be overwritten by the next CMake run ####
####### The input file was nusystematicsConfig.cmake.in                            ########

get_filename_component(PACKAGE_PREFIX_DIR "${CMAKE_CURRENT_LIST_DIR}/../" ABSOLUTE)

####################################################################################

set(systematicstools_VERSION 23.06)

find_package(systematicstools 23.06 REQUIRED)

#expect that NuHepMC/CMakeModules gets installed to the prefix/cmake
get_filename_component(CMakeModules_CMAKE_DIR "${CMAKE_CURRENT_LIST_FILE}" DIRECTORY)
SET(CMakeModules_CMAKE_DIR ${CMakeModules_CMAKE_DIR}/../../../cmake/)

if(EXISTS "${CMakeModules_CMAKE_DIR}/FindGENIE3.cmake")
  LIST(APPEND CMAKE_MODULE_PATH ${CMakeModules_CMAKE_DIR})
endif()

find_package(GENIE3 REQUIRED)

set(systematicstools_FOUND TRUE)

if(NOT TARGET GENIE3::All)
  message(WARNING "Expected find_package(GENIE3 REQUIRED) call to set up target GENIE3::All.")
  set(systematicstools_FOUND FALSE)
  return()
endif()

include(${CMAKE_CURRENT_LIST_DIR}/nusyst-targets.cmake)

if(NOT TARGET nusyst::all)
  message(WARNING "Expected to find target nusyst::all in ${CMAKE_CURRENT_LIST_DIR}/systtools-targets.cmake")
  set(systematicstools_FOUND FALSE)
  return()
endif()
