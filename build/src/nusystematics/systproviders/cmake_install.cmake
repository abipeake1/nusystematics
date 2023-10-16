# Install script for directory: /root/software/newsystematics_new/src/nusystematics/systproviders

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

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libnusystematics_systproviders.so" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libnusystematics_systproviders.so")
    file(RPATH_CHECK
         FILE "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libnusystematics_systproviders.so"
         RPATH "")
  endif()
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE SHARED_LIBRARY FILES "/root/software/newsystematics_new/build/src/nusystematics/systproviders/libnusystematics_systproviders.so")
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libnusystematics_systproviders.so" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libnusystematics_systproviders.so")
    file(RPATH_CHANGE
         FILE "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libnusystematics_systproviders.so"
         OLD_RPATH "/opt/genie/3_02_02/lib:/opt/pythia/6.4.28:/opt/lhapdf/5.9.1/lib:/opt/root/v6-26-10/lib:/root/software/newsystematics_new/build/_deps/systematicstools-build/src/systematicstools/interpreters:/root/software/newsystematics_new/build/_deps/systematicstools-build/src/systematicstools/utility:/root/software/newsystematics_new/build/_deps/systematicstools-build/src/systematicstools/systproviders:/root/software/newsystematics_new/build/_deps/systematicstools-build/src/systematicstools/interface:"
         NEW_RPATH "")
    if(CMAKE_INSTALL_DO_STRIP)
      execute_process(COMMAND "/usr/bin/strip" "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libnusystematics_systproviders.so")
    endif()
  endif()
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xDevelopmentx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/nusystematics/systproviders" TYPE FILE FILES
    "/root/software/newsystematics_new/src/nusystematics/systproviders/BeRPAWeight_tool.hh"
    "/root/software/newsystematics_new/src/nusystematics/systproviders/EbLepMomShift_tool.hh"
    "/root/software/newsystematics_new/src/nusystematics/systproviders/FSILikeEAvailSmearing_tool.hh"
    "/root/software/newsystematics_new/src/nusystematics/systproviders/MINERvAE2p2h_tool.hh"
    "/root/software/newsystematics_new/src/nusystematics/systproviders/MINERvAq0q3Weighting_tool.hh"
    "/root/software/newsystematics_new/src/nusystematics/systproviders/MKSinglePiTemplate_tool.hh"
    "/root/software/newsystematics_new/src/nusystematics/systproviders/MiscInteractionSysts_tool.hh"
    "/root/software/newsystematics_new/src/nusystematics/systproviders/NOvAStyleNonResPionNorm_tool.hh"
    "/root/software/newsystematics_new/src/nusystematics/systproviders/zexpansion_weighter.hh"
    "/root/software/newsystematics_new/src/nusystematics/systproviders/GENIEReWeightEngineConfig.hh"
    "/root/software/newsystematics_new/src/nusystematics/systproviders/GENIEReWeightParamConfig.hh"
    "/root/software/newsystematics_new/src/nusystematics/systproviders/GENIEReWeight_tool.hh"
    "/root/software/newsystematics_new/src/nusystematics/systproviders/GENIEResponseParameterAssociation.hh"
    "/root/software/newsystematics_new/src/nusystematics/systproviders/SkeleWeighter_tool.hh"
    "/root/software/newsystematics_new/src/nusystematics/systproviders/zexpansion_weighter.hh"
    )
endif()

