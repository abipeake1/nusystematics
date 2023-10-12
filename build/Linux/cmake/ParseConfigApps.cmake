include(CMessage)

if(NOT COMMAND GetFirstMatchingDelimitedArg)
function(GetFirstMatchingDelimitedArg)
  set(options ALLOW_FAIL)
  set(oneValueArgs DELIMITER CONFIG_APP RESULT_VARIABLE OUTPUT_VARIABLE)
  set(multiValueArgs ARGS)
  cmake_parse_arguments(OPTS 
                      "${options}" 
                      "${oneValueArgs}"
                      "${multiValueArgs}" ${ARGN})

  foreach(ARG CONFIG_APP OUTPUT_VARIABLE DELIMITER)
    if(NOT DEFINED OPTS_${ARG})
      dump_cmake_variables("OPTS_")
      cmessage(FATAL_ERROR "GetFirstMatchingDelimitedArg called without required argument ${ARG}\n\tARGN:\n\t\t${ARGN}")
    endif()
  endforeach()

  SET(CONFIG_APP_LOCATION "CONFIG_APP_LOCATION-NOTFOUND")
  find_program(CONFIG_APP_LOCATION ${OPTS_CONFIG_APP})
  if(NOT CONFIG_APP_LOCATION STREQUAL "CONFIG_APP_LOCATION-NOTFOUND")
    execute_process (COMMAND ${CONFIG_APP_LOCATION}
      ${OPTS_ARGS} 
      OUTPUT_VARIABLE CONFIGAPP_RESPONSE_RAW
      RESULT_VARIABLE RETURN_VALUE
      OUTPUT_STRIP_TRAILING_WHITESPACE)
    
    if(DEFINED OPTS_RESULT_VARIABLE)
      set(${OPTS_RESULT_VARIABLE} ${RETURN_VALUE} PARENT_SCOPE)
    endif()

    if(CONFIGAPP_RESPONSE_RAW STREQUAL "")
      if(OPTS_ALLOW_FAIL)
        set(${DIR_OUT} "" PARENT_SCOPE)
      else()
        cmessage(FATAL_ERROR "\"${CONFIG_APP_LOCATION} ${OPTS_ARGS}\" produced no output and was required to.")
      endif()
    else()
      string(REGEX MATCH "${OPTS_DELIMITER}\([^ ]+\)" PARSE_CONFIGAPP_RESPONSE_MATCH ${CONFIGAPP_RESPONSE_RAW})

      if(NOT PARSE_CONFIGAPP_RESPONSE_MATCH)
        if(OPTS_ALLOW_FAIL)
          set(${CMAKE_MATCH_1} "")
        else()
          cmessage(FATAL_ERROR "Expected to be able to parse the result of ${OPTS_CONFIG_APP} ${OPTS_ARGS} to a directory, but couldn't find a ${OPTS_DELIMITER} flag, found: \"${CONFIGAPP_RESPONSE_RAW}\"")
        endif()
      endif()

      set(${OPTS_OUTPUT_VARIABLE} ${CMAKE_MATCH_1} PARENT_SCOPE)
    endif()
  else()
    cmessage(FATAL_ERROR "[ERROR]: Failed to find dependency configuration application: \"${OPTS_CONFIG_APP}\"")
  endif()
endfunction(GetFirstMatchingDelimitedArg)
endif()

if(NOT COMMAND GetAllMatchingDelimitedArg)
function(GetAllMatchingDelimitedArg)
  set(options ALLOW_FAIL)
  set(oneValueArgs DELIMITER CONFIG_APP RESULT_VARIABLE OUTPUT_VARIABLE)
  set(multiValueArgs ARGS)
  cmake_parse_arguments(OPTS 
                      "${options}" 
                      "${oneValueArgs}"
                      "${multiValueArgs}" ${ARGN})

  foreach(ARG CONFIG_APP OUTPUT_VARIABLE DELIMITER)
    if(NOT DEFINED OPTS_${ARG})
      dump_cmake_variables("OPTS_")
      cmessage(FATAL_ERROR "GetAllMatchingDelimitedArg called without required argument ${ARG}\n\tARGN:\n\t\t${ARGN}")
    endif()
  endforeach()

  SET(CONFIG_APP_LOCATION "CONFIG_APP_LOCATION-NOTFOUND")
  find_program(CONFIG_APP_LOCATION ${OPTS_CONFIG_APP})
  if(NOT CONFIG_APP_LOCATION STREQUAL "CONFIG_APP_LOCATION-NOTFOUND")
    execute_process (COMMAND ${CONFIG_APP_LOCATION}
      ${OPTS_ARGS} 
      OUTPUT_VARIABLE CONFIGAPP_RESPONSE_RAW
      RESULT_VARIABLE RETURN_VALUE
      OUTPUT_STRIP_TRAILING_WHITESPACE)

    if(DEFINED OPTS_RESULT_VARIABLE)
      set(${OPTS_RESULT_VARIABLE} ${RETURN_VALUE} PARENT_SCOPE)
    endif()

    string(REPLACE " " ";" CONFIGAPP_RESPONSE_LIST "${CONFIGAPP_RESPONSE_RAW}")

    set(LIST_BUILD)

    foreach(I ${CONFIGAPP_RESPONSE_LIST})
      if(I)
        string(REGEX MATCH "^${OPTS_DELIMITER}" WASMATCHED ${I})
        if(WASMATCHED)
          string(REPLACE "${OPTS_DELIMITER}" "" I_STRIPPED "${I}")
          LIST(APPEND LIST_BUILD ${I_STRIPPED})
        endif()
      endif()
    endforeach()

    set(${OPTS_OUTPUT_VARIABLE} ${LIST_BUILD} PARENT_SCOPE)
  else()
    cmessage(FATAL_ERROR "[ERROR]: Failed to find dependency configuration application: \"${OPTS_CONFIG_APP}\"")
  endif()
endfunction(GetAllMatchingDelimitedArg)
endif()

#Uselike GetLibDir(CONFIG_APP gsl-config ARGS --libs OUTPUT_VARIABLE GSL_LIB_DIR)
if(NOT COMMAND GetLibDir)
function(GetLibDir)
  set(options ALLOW_FAIL)
  set(oneValueArgs CONFIG_APP RESULT_VARIABLE OUTPUT_VARIABLE)
  set(multiValueArgs ARGS)
  cmake_parse_arguments(OPTS 
                      "${options}" 
                      "${oneValueArgs}"
                      "${multiValueArgs}" ${ARGN})

  foreach(ARG CONFIG_APP OUTPUT_VARIABLE)
    if(NOT DEFINED OPTS_${ARG})
      dump_cmake_variables("OPTS_")
      cmessage(FATAL_ERROR "GetLibDir called without required argument ${ARG}\n\tARGN:\n\t\t${ARGN}")
    endif()
  endforeach()

  set(ALLOW_FAIL)
  if(OPTS_ALLOW_FAIL)
    set(ALLOW_FAIL "ALLOW_FAIL")
  endif()

  GetFirstMatchingDelimitedArg(
    DELIMITER "-L"
    CONFIG_APP ${OPTS_CONFIG_APP}
    ARGS ${OPTS_ARGS}
    OUTPUT_VARIABLE MATCHING_DIR
    RESULT_VARIABLE RETURN_VALUE
    ${ALLOW_FAIL})

  set(${OPTS_OUTPUT_VARIABLE} ${MATCHING_DIR} PARENT_SCOPE)
  if(DEFINED OPTS_RESULT_VARIABLE)
    set(${OPTS_RESULT_VARIABLE} ${RETURN_VALUE} PARENT_SCOPE)
  endif()
endfunction(GetLibDir)
endif()

#Uselike GetIncDir(CONFIG_APP gsl-config ARGS --incdir OUTPUT_VARIABLE GSL_INC_DIR)
if(NOT COMMAND GetIncDir)
function(GetIncDir)
  set(options ALLOW_FAIL)
  set(oneValueArgs CONFIG_APP RESULT_VARIABLE OUTPUT_VARIABLE)
  set(multiValueArgs ARGS)
  cmake_parse_arguments(OPTS 
                      "${options}" 
                      "${oneValueArgs}"
                      "${multiValueArgs}" ${ARGN})


  foreach(ARG CONFIG_APP OUTPUT_VARIABLE)
    if(NOT DEFINED OPTS_${ARG})
      dump_cmake_variables("OPTS_")
      cmessage(FATAL_ERROR "GetIncDir called without required argument ${ARG}\n\tARGN:\n\t\t${ARGN}")
    endif()
  endforeach()

  set(ALLOW_FAIL)
  if(OPTS_ALLOW_FAIL)
    set(ALLOW_FAIL "ALLOW_FAIL")
  endif()

  GetFirstMatchingDelimitedArg(
    DELIMITER "-I"
    CONFIG_APP ${OPTS_CONFIG_APP}
    ARGS ${OPTS_ARGS}
    OUTPUT_VARIABLE MATCHING_DIR
    RESULT_VARIABLE RETURN_VALUE
    ${ALLOW_FAIL})

  set(${OPTS_OUTPUT_VARIABLE} ${MATCHING_DIR} PARENT_SCOPE)
  if(DEFINED OPTS_RESULT_VARIABLE)
    set(${OPTS_RESULT_VARIABLE} ${RETURN_VALUE} PARENT_SCOPE)
  endif()
endfunction(GetIncDir)
endif()

#Uselike GetLibDirs(CONFIG_APP gsl-config ARGS --libs OUTPUT_VARIABLE GSL_LIB_DIR)
if(NOT COMMAND GetLibDirs)
function(GetLibDirs)
  set(options ALLOW_FAIL)
  set(oneValueArgs CONFIG_APP RESULT_VARIABLE OUTPUT_VARIABLE)
  set(multiValueArgs ARGS)
  cmake_parse_arguments(OPTS 
                      "${options}" 
                      "${oneValueArgs}"
                      "${multiValueArgs}" ${ARGN})

  foreach(ARG CONFIG_APP OUTPUT_VARIABLE)
    if(NOT DEFINED OPTS_${ARG})
      dump_cmake_variables("OPTS_")
      cmessage(FATAL_ERROR "GetLibDirs called without required argument ${ARG}\n\tARGN:\n\t\t${ARGN}")
    endif()
  endforeach()

  set(ALLOW_FAIL)
  if(OPTS_ALLOW_FAIL)
    set(ALLOW_FAIL "ALLOW_FAIL")
  endif()

  GetAllMatchingDelimitedArg(
    DELIMITER "-L"
    CONFIG_APP ${OPTS_CONFIG_APP}
    ARGS ${OPTS_ARGS}
    OUTPUT_VARIABLE MATCHING_DIR
    RESULT_VARIABLE RETURN_VALUE
    ${ALLOW_FAIL})

  set(${OPTS_OUTPUT_VARIABLE} ${MATCHING_DIR} PARENT_SCOPE)
  if(DEFINED OPTS_RESULT_VARIABLE)
    set(${OPTS_RESULT_VARIABLE} ${RETURN_VALUE} PARENT_SCOPE)
  endif()
endfunction(GetLibDirs)
endif()

#Uselike GetLibs(CONFIG_APP gsl-config ARGS --libs OUTPUT_VARIABLE GSL_LIB_DIR)
if(NOT COMMAND GetLibs)
function(GetLibs)
  set(options ALLOW_FAIL)
  set(oneValueArgs CONFIG_APP RESULT_VARIABLE OUTPUT_VARIABLE)
  set(multiValueArgs ARGS)
  cmake_parse_arguments(OPTS 
                      "${options}" 
                      "${oneValueArgs}"
                      "${multiValueArgs}" ${ARGN})

  foreach(ARG CONFIG_APP OUTPUT_VARIABLE)
    if(NOT DEFINED OPTS_${ARG})
      dump_cmake_variables("OPTS_")
      cmessage(FATAL_ERROR "GetLibDir called without required argument ${ARG}\n\tARGN:\n\t\t${ARGN}")
    endif()
  endforeach()

  set(ALLOW_FAIL)
  if(OPTS_ALLOW_FAIL)
    set(ALLOW_FAIL "ALLOW_FAIL")
  endif()

  GetAllMatchingDelimitedArg(
    DELIMITER "-l"
    CONFIG_APP ${OPTS_CONFIG_APP}
    ARGS ${OPTS_ARGS}
    OUTPUT_VARIABLE MATCHING_DIR
    RESULT_VARIABLE RETURN_VALUE
    ${ALLOW_FAIL})

  set(${OPTS_OUTPUT_VARIABLE} ${MATCHING_DIR} PARENT_SCOPE)
  if(DEFINED OPTS_RESULT_VARIABLE)
    set(${OPTS_RESULT_VARIABLE} ${RETURN_VALUE} PARENT_SCOPE)
  endif()
endfunction(GetLibs)
endif()

#Uselike GetIncDirs(CONFIG_APP gsl-config ARGS --incdir OUTPUT_VARIABLE GSL_INC_DIR)
if(NOT COMMAND GetIncDirs)
function(GetIncDirs)
  set(options ALLOW_FAIL)
  set(oneValueArgs CONFIG_APP RESULT_VARIABLE OUTPUT_VARIABLE)
  set(multiValueArgs ARGS)
  cmake_parse_arguments(OPTS 
                      "${options}" 
                      "${oneValueArgs}"
                      "${multiValueArgs}" ${ARGN})


  foreach(ARG CONFIG_APP OUTPUT_VARIABLE)
    if(NOT DEFINED OPTS_${ARG})
      dump_cmake_variables("OPTS_")
      cmessage(FATAL_ERROR "GetIncDir called without required argument ${ARG}\n\tARGN:\n\t\t${ARGN}")
    endif()
  endforeach()

  set(ALLOW_FAIL)
  if(OPTS_ALLOW_FAIL)
    set(ALLOW_FAIL "ALLOW_FAIL")
  endif()

  GetAllMatchingDelimitedArg(
    DELIMITER "-I"
    CONFIG_APP ${OPTS_CONFIG_APP}
    ARGS ${OPTS_ARGS}
    OUTPUT_VARIABLE MATCHING_DIR
    RESULT_VARIABLE RETURN_VALUE
    ${ALLOW_FAIL})

  set(${OPTS_OUTPUT_VARIABLE} ${MATCHING_DIR} PARENT_SCOPE)
  if(DEFINED OPTS_RESULT_VARIABLE)
    set(${OPTS_RESULT_VARIABLE} ${RETURN_VALUE} PARENT_SCOPE)
  endif()
endfunction(GetIncDirs)
endif()

if(NOT COMMAND BuildFlagString)
function(BuildFlagString)
  set(oneValueArgs DELIMITER OUTPUT_VARIABLE)
  set(multiValueArgs ARGS)
  cmake_parse_arguments(OPTS 
                      "${options}" 
                      "${oneValueArgs}"
                      "${multiValueArgs}" ${ARGN})

  foreach(ARG DELIMITER OUTPUT_VARIABLE ARGS)
    if(NOT DEFINED OPTS_${ARG})
      dump_cmake_variables("OPTS_")
      cmessage(FATAL_ERROR "BuildFlagString called without required argument ${ARG}\n\tARGN:\n\t\t${ARGN}")
    endif()
  endforeach()

  LIST(APPEND INPUT_LIST ${OPTS_ARGS})
  if(NOT "${INPUT_LIST} " STREQUAL " ")
    string(REPLACE ";" " ${OPTS_DELIMITER}" LIST_STR "${OPTS_DELIMITER}${INPUT_LIST}")
    string(STRIP "${LIST_STR}" LIST_STR)
    set(${OPTS_OUTPUT_VARIABLE} ${LIST_STR} PARENT_SCOPE)
  else()
      set(${OPTS_OUTPUT_VARIABLE} PARENT_SCOPE)
  endif()
endfunction(BuildFlagString)
endif()

#Here we want to look for linker flags in a list of libraries and escape them
if(NOT COMMAND BuildLibraryFlagString)
function(BuildLibraryFlagString)
  set(oneValueArgs OUTPUT_VARIABLE)
  set(multiValueArgs ARGS)
  cmake_parse_arguments(OPTS 
                      "${options}" 
                      "${oneValueArgs}"
                      "${multiValueArgs}" ${ARGN})

  foreach(ARG OUTPUT_VARIABLE ARGS)
    if(NOT DEFINED OPTS_${ARG})
      dump_cmake_variables("OPTS_")
      cmessage(FATAL_ERROR "BuildLibraryFlagString called without required argument ${ARG}\n\tARGN:\n\t\t${ARGN}")
    endif()
  endforeach()

  BuildFlagString(
    OUTPUT_VARIABLE LINKOPTS 
    DELIMITER "-l" 
    ARGS ${OPTS_ARGS})

  string(REPLACE "-l-" "-" LINKOPTS "${LINKOPTS}")
  set(${OPTS_OUTPUT_VARIABLE} ${LINKOPTS} PARENT_SCOPE)
endfunction(BuildLibraryFlagString)
endif()

if(NOT COMMAND CatStringsIfNotEmpty)
function(CatStringsIfNotEmpty)
  set(oneValueArgs OUTPUT_VARIABLE)
  set(multiValueArgs ARGS)
  cmake_parse_arguments(OPTS 
                      "${options}" 
                      "${oneValueArgs}"
                      "${multiValueArgs}" ${ARGN})

  foreach(ARG OUTPUT_VARIABLE ARGS)
    if(NOT DEFINED OPTS_${ARG})
      dump_cmake_variables("OPTS_")
      cmessage(FATAL_ERROR "CatStringsIfNotEmpty called without required argument ${ARG}\n\tARGN:\n\t\t${ARGN}")
    endif()
  endforeach()

  set(BUILD_STR)
  foreach(I ${OPTS_ARGS})
    if(NOT "${I} " STREQUAL " ")
      set(BUILD_STR "${BUILD_STR} ${I}")
    endif()
  endforeach()
  if(NOT "${BUILD_STR} " STREQUAL " ")
    string(STRIP "${BUILD_STR}" BUILD_STR)
  endif()
  set(${OPTS_OUTPUT_VARIABLE} ${BUILD_STR} PARENT_SCOPE)
endfunction(CatStringsIfNotEmpty)
endif()

if(NOT COMMAND PrefixList)
function(PrefixList)
  set(oneValueArgs OUTPUT_VARIABLE PREFIX)
  set(multiValueArgs ARGS)
  cmake_parse_arguments(OPTS 
                      "${options}" 
                      "${oneValueArgs}"
                      "${multiValueArgs}" ${ARGN})

  foreach(ARG OUTPUT_VARIABLE PREFIX ARGS)
    if(NOT DEFINED OPTS_${ARG})
      dump_cmake_variables("OPTS_")
      cmessage(FATAL_ERROR "PrefixList called without required argument ${ARG}\n\tARGN:\n\t\t${ARGN}")
    endif()
  endforeach()

  set(BUILD_LIST)
  foreach(I ${OPTS_ARGS})
    if(NOT "${I} " STREQUAL " ")
      LIST(APPEND BUILD_LIST "${OPTS_PREFIX}${I}")
    endif()
  endforeach()
  set(${OPTS_OUTPUT_VARIABLE} ${BUILD_LIST} PARENT_SCOPE)
endfunction(PrefixList)
endif()
