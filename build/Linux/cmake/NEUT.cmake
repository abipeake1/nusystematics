if(NOT TARGET NEUT::All)

cmake_minimum_required (VERSION 3.14 FATAL_ERROR)

# This will define the following variables
#
#    NEUT_FOUND
#    NEUTReWeight_ENABLED
#
# This will declare the following imported targets on successful completion
#
#    NEUT::All
#

find_program(NEUTCONFIG NAMES neut-config)

set(NEUT_FOUND FALSE)
EnsureVarSet(NEUTReWeight_ENABLED FALSE)

if(NOT "${NEUTCONFIG}x" STREQUAL "NEUTCONFIG-NOTFOUNDx")
  cmessage(STATUS "Found neut-config, using it to determine configuration.")

  execute_process (COMMAND neut-config --version 
    OUTPUT_VARIABLE NEUT_CONFIG_VERSION 
    OUTPUT_STRIP_TRAILING_WHITESPACE)

  if(NEUT_CONFIG_VERSION VERSION_LESS 5.5.0)
    include(FindNEUTConfigLegacy)

    add_library(NEUT::All INTERFACE IMPORTED)
    set_target_properties(NEUT::All PROPERTIES
      INTERFACE_LINK_LIBRARIES NEUT::ReWeight)

  else()
    include(CMakeFindDependencyMacro)
    find_package(NEUT)

    if(NEUT_FOUND)
      add_library(NEUT::All INTERFACE IMPORTED)
      #Any additional target options that we want to attach to the NEUT target can go here.
      string(REPLACE "." "" NEUT_SINGLE_VERSION ${NEUT_VERSION})
      set_target_properties(NEUT::All PROPERTIES 
        INTERFACE_COMPILE_OPTIONS "-DNEUT_ENABLED;-DNEUT_VERSION=${NEUT_SINGLE_VERSION};-DNEUTReWeight_ENABLED"
        INTERFACE_LINK_OPTIONS "-Wl,--allow-multiple-definition"
        INTERFACE_LINK_LIBRARIES NEUT::ReWeight)

      set(NEUTReWeight_ENABLED TRUE)

    endif()
  endif()
else()

  include(CMessage)

  EnsureVarOrEnvSet(NEUT_VERSION NEUT_VERSION)
  EnsureVarOrEnvSet(NEUT_ROOT NEUT_ROOT)
  EnsureVarOrEnvSet(CERN CERN)
  EnsureVarOrEnvSet(CERN_LEVEL CERN_LEVEL)
  
  if("${NEUT_ROOT}" STREQUAL "NEUT_ROOT-NOTFOUND")
    cmessage(STATUS "Variable NEUT_ROOT is not defined and could not find neut-config, disabling NEUT support")
    set(NEUT_FOUND FALSE)
  else()

    if("${CERN}" STREQUAL "CERN-NOTFOUND")
      cmessage(FATAL_ERROR "Variable CERN is not defined. Please export environment variable CERN or configure with -DCERN=/path/to/CERNLIB. This must be set to point to a prebuilt CERNLIB instance.")
    endif()

    if("${CERN_LEVEL}" STREQUAL "CERN_LEVEL-NOTFOUND")
      cmessage(FATAL_ERROR "Variable CERN_LEVEL is not defined. Please export environment variable CERN_LEVEL or configure with -DCERN_LEVEL=XXXX (likely to be 2005).")
    endif()

    if("${NEUT_VERSION}" STREQUAL "NEUT_VERSION-NOTFOUND")
      cmessage(FATAL_ERROR "Variable NEUT_VERSION is not defined. Please export environment variable NEUT_VERSION or configure with -DNEUT_VERSION=5.X.Y")
    endif()

    if(NEUT_VERSION VERSION_LESS 5.4.0)
      include(FindNEUT53X)
    else()
      include(FindNEUT54X)
    endif()
    
  endif()

  add_library(NEUT::All INTERFACE IMPORTED)
  set_target_properties(NEUT::All PROPERTIES
      INTERFACE_LINK_LIBRARIES NEUT::ReWeight)

endif()

endif()
