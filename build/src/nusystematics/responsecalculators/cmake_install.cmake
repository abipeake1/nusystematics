# Install script for directory: /root/software/newsystematics_new/src/nusystematics/responsecalculators

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "/root/software/newsystematics_new/build/Linux")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "Debug")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

# Install shared libraries without execute permission?
if(NOT DEFINED CMAKE_INSTALL_SO_NO_EXE)
  set(CMAKE_INSTALL_SO_NO_EXE "0")
endif()

# Is this installation the result of a crosscompile?
if(NOT DEFINED CMAKE_CROSSCOMPILING)
  set(CMAKE_CROSSCOMPILING "FALSE")
endif()

# Set default install directory permissions.
if(NOT DEFINED CMAKE_OBJDUMP)
  set(CMAKE_OBJDUMP "/usr/bin/objdump")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xDevelopmentx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/nusystematics/responsecalculators" TYPE FILE FILES
    "/root/software/newsystematics_new/src/nusystematics/responsecalculators/BeRPA.hh"
    "/root/software/newsystematics_new/src/nusystematics/responsecalculators/MINERvA2p2hEnergyDependenceScale.hh"
    "/root/software/newsystematics_new/src/nusystematics/responsecalculators/MKSinglePiTemplate_ReWeight.hh"
    "/root/software/newsystematics_new/src/nusystematics/responsecalculators/nuenumu_xsec_ratio.hh"
    "/root/software/newsystematics_new/src/nusystematics/responsecalculators/C12ToAr40_2p2hScaling.hh"
    "/root/software/newsystematics_new/src/nusystematics/responsecalculators/MINERvA2p2hq0q3.hh"
    "/root/software/newsystematics_new/src/nusystematics/responsecalculators/SPPLowQ2Suppression.hh"
    "/root/software/newsystematics_new/src/nusystematics/responsecalculators/EnuBinnedTemplateResponseCalculator.hh"
    "/root/software/newsystematics_new/src/nusystematics/responsecalculators/MINERvARPAq0q3_ReWeight.hh"
    "/root/software/newsystematics_new/src/nusystematics/responsecalculators/TemplateResponseCalculatorBase.hh"
    "/root/software/newsystematics_new/src/nusystematics/responsecalculators/FSILikeEAvailSmearing.hh"
    "/root/software/newsystematics_new/src/nusystematics/responsecalculators/MINERvAq0q3Weighting_data.hh"
    "/root/software/newsystematics_new/src/nusystematics/responsecalculators/nuenuebar_xsec_ratio.hh"
    )
endif()

