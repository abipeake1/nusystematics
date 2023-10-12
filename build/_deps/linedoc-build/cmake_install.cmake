# Install script for directory: /root/software/newsystematics_new/build/_deps/linedoc-src

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
    set(CMAKE_INSTALL_CONFIG_NAME "DebWithRelInfo")
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
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "/root/software/newsystematics_new/build/Linux/include/linedoc/doc.hxx;/root/software/newsystematics_new/build/Linux/include/linedoc/doc_line.hxx;/root/software/newsystematics_new/build/Linux/include/linedoc/doc_line_point.hxx;/root/software/newsystematics_new/build/Linux/include/linedoc/doc_range.hxx;/root/software/newsystematics_new/build/Linux/include/linedoc/doc_utils.hxx")
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
file(INSTALL DESTINATION "/root/software/newsystematics_new/build/Linux/include/linedoc" TYPE FILE FILES
    "/root/software/newsystematics_new/build/_deps/linedoc-src/linedoc/doc.hxx"
    "/root/software/newsystematics_new/build/_deps/linedoc-src/linedoc/doc_line.hxx"
    "/root/software/newsystematics_new/build/_deps/linedoc-src/linedoc/doc_line_point.hxx"
    "/root/software/newsystematics_new/build/_deps/linedoc-src/linedoc/doc_range.hxx"
    "/root/software/newsystematics_new/build/_deps/linedoc-src/linedoc/doc_utils.hxx"
    )
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  if(EXISTS "$ENV{DESTDIR}/root/software/newsystematics_new/build/Linux/bin/dump-doc" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}/root/software/newsystematics_new/build/Linux/bin/dump-doc")
    file(RPATH_CHECK
         FILE "$ENV{DESTDIR}/root/software/newsystematics_new/build/Linux/bin/dump-doc"
         RPATH "")
  endif()
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "/root/software/newsystematics_new/build/Linux/bin/dump-doc")
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
file(INSTALL DESTINATION "/root/software/newsystematics_new/build/Linux/bin" TYPE EXECUTABLE FILES "/root/software/newsystematics_new/build/_deps/linedoc-build/dump-doc")
  if(EXISTS "$ENV{DESTDIR}/root/software/newsystematics_new/build/Linux/bin/dump-doc" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}/root/software/newsystematics_new/build/Linux/bin/dump-doc")
    if(CMAKE_INSTALL_DO_STRIP)
      execute_process(COMMAND "/usr/bin/strip" "$ENV{DESTDIR}/root/software/newsystematics_new/build/Linux/bin/dump-doc")
    endif()
  endif()
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/linedoc/linedocTargets.cmake")
    file(DIFFERENT EXPORT_FILE_CHANGED FILES
         "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/linedoc/linedocTargets.cmake"
         "/root/software/newsystematics_new/build/_deps/linedoc-build/CMakeFiles/Export/lib/cmake/linedoc/linedocTargets.cmake")
    if(EXPORT_FILE_CHANGED)
      file(GLOB OLD_CONFIG_FILES "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/linedoc/linedocTargets-*.cmake")
      if(OLD_CONFIG_FILES)
        message(STATUS "Old export file \"$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/linedoc/linedocTargets.cmake\" will be replaced.  Removing files [${OLD_CONFIG_FILES}].")
        file(REMOVE ${OLD_CONFIG_FILES})
      endif()
    endif()
  endif()
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/linedoc" TYPE FILE FILES "/root/software/newsystematics_new/build/_deps/linedoc-build/CMakeFiles/Export/lib/cmake/linedoc/linedocTargets.cmake")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/linedoc" TYPE FILE FILES
    "/root/software/newsystematics_new/build/_deps/linedoc-build/linedocConfigVersion.cmake"
    "/root/software/newsystematics_new/build/_deps/linedoc-build/linedocConfig.cmake"
    )
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/bin" TYPE PROGRAM FILES "/root/software/newsystematics_new/build/_deps/linedoc-build/setup.linedoc.sh")
endif()

