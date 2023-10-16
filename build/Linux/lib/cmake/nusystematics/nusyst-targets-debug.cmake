#----------------------------------------------------------------
# Generated CMake target import file for configuration "Debug".
#----------------------------------------------------------------

# Commands may need to know the format version.
set(CMAKE_IMPORT_FILE_VERSION 1)

# Import target "nusyst::systproviders" for configuration "Debug"
set_property(TARGET nusyst::systproviders APPEND PROPERTY IMPORTED_CONFIGURATIONS DEBUG)
set_target_properties(nusyst::systproviders PROPERTIES
  IMPORTED_LOCATION_DEBUG "${_IMPORT_PREFIX}/lib/libnusystematics_systproviders.so"
  IMPORTED_SONAME_DEBUG "libnusystematics_systproviders.so"
  )

list(APPEND _IMPORT_CHECK_TARGETS nusyst::systproviders )
list(APPEND _IMPORT_CHECK_FILES_FOR_nusyst::systproviders "${_IMPORT_PREFIX}/lib/libnusystematics_systproviders.so" )

# Commands beyond this point should not need to know the version.
set(CMAKE_IMPORT_FILE_VERSION)
