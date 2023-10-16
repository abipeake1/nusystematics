# Install script for directory: /root/software/newsystematics_new/build/_deps/cmakemodules-src

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
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/cmake" TYPE FILE FILES
    "/root/software/newsystematics_new/build/_deps/cmakemodules-src/CMessage.cmake"
    "/root/software/newsystematics_new/build/_deps/cmakemodules-src/FindGENIE.cmake"
    "/root/software/newsystematics_new/build/_deps/cmakemodules-src/FindGENIE2.cmake"
    "/root/software/newsystematics_new/build/_deps/cmakemodules-src/FindGENIE3.cmake"
    "/root/software/newsystematics_new/build/_deps/cmakemodules-src/FindGENIEDependencies.cmake"
    "/root/software/newsystematics_new/build/_deps/cmakemodules-src/FindGENIEVersion.cmake"
    "/root/software/newsystematics_new/build/_deps/cmakemodules-src/FindLHAPDF.cmake"
    "/root/software/newsystematics_new/build/_deps/cmakemodules-src/FindNEUT53X.cmake"
    "/root/software/newsystematics_new/build/_deps/cmakemodules-src/FindNEUT54X.cmake"
    "/root/software/newsystematics_new/build/_deps/cmakemodules-src/FindNEUTConfigLegacy.cmake"
    "/root/software/newsystematics_new/build/_deps/cmakemodules-src/FindNuWro.cmake"
    "/root/software/newsystematics_new/build/_deps/cmakemodules-src/FindPythia6.cmake"
    "/root/software/newsystematics_new/build/_deps/cmakemodules-src/Findlog4cpp.cmake"
    "/root/software/newsystematics_new/build/_deps/cmakemodules-src/NEUT.cmake"
    "/root/software/newsystematics_new/build/_deps/cmakemodules-src/NuHepMCModules.cmake"
    "/root/software/newsystematics_new/build/_deps/cmakemodules-src/NuHepMCUtils.cmake"
    "/root/software/newsystematics_new/build/_deps/cmakemodules-src/ParseConfigApps.cmake"
    "/root/software/newsystematics_new/build/_deps/cmakemodules-src/ROOT.cmake"
    )
endif()

