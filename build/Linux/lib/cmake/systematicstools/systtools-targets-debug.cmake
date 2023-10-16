#----------------------------------------------------------------
# Generated CMake target import file for configuration "Debug".
#----------------------------------------------------------------

# Commands may need to know the format version.
set(CMAKE_IMPORT_FILE_VERSION 1)

# Import target "systtools::interface" for configuration "Debug"
set_property(TARGET systtools::interface APPEND PROPERTY IMPORTED_CONFIGURATIONS DEBUG)
set_target_properties(systtools::interface PROPERTIES
  IMPORTED_LOCATION_DEBUG "${_IMPORT_PREFIX}/lib/libsystematicstools_interface.so"
  IMPORTED_SONAME_DEBUG "libsystematicstools_interface.so"
  )

list(APPEND _IMPORT_CHECK_TARGETS systtools::interface )
list(APPEND _IMPORT_CHECK_FILES_FOR_systtools::interface "${_IMPORT_PREFIX}/lib/libsystematicstools_interface.so" )

# Import target "systtools::interpreters" for configuration "Debug"
set_property(TARGET systtools::interpreters APPEND PROPERTY IMPORTED_CONFIGURATIONS DEBUG)
set_target_properties(systtools::interpreters PROPERTIES
  IMPORTED_LOCATION_DEBUG "${_IMPORT_PREFIX}/lib/libsystematicstools_interpreters.so"
  IMPORTED_SONAME_DEBUG "libsystematicstools_interpreters.so"
  )

list(APPEND _IMPORT_CHECK_TARGETS systtools::interpreters )
list(APPEND _IMPORT_CHECK_FILES_FOR_systtools::interpreters "${_IMPORT_PREFIX}/lib/libsystematicstools_interpreters.so" )

# Import target "systtools::systproviders" for configuration "Debug"
set_property(TARGET systtools::systproviders APPEND PROPERTY IMPORTED_CONFIGURATIONS DEBUG)
set_target_properties(systtools::systproviders PROPERTIES
  IMPORTED_LOCATION_DEBUG "${_IMPORT_PREFIX}/lib/libsystematicstools_systproviders.so"
  IMPORTED_SONAME_DEBUG "libsystematicstools_systproviders.so"
  )

list(APPEND _IMPORT_CHECK_TARGETS systtools::systproviders )
list(APPEND _IMPORT_CHECK_FILES_FOR_systtools::systproviders "${_IMPORT_PREFIX}/lib/libsystematicstools_systproviders.so" )

# Import target "systtools::utility" for configuration "Debug"
set_property(TARGET systtools::utility APPEND PROPERTY IMPORTED_CONFIGURATIONS DEBUG)
set_target_properties(systtools::utility PROPERTIES
  IMPORTED_LOCATION_DEBUG "${_IMPORT_PREFIX}/lib/libsystematicstools_utility.so"
  IMPORTED_SONAME_DEBUG "libsystematicstools_utility.so"
  )

list(APPEND _IMPORT_CHECK_TARGETS systtools::utility )
list(APPEND _IMPORT_CHECK_FILES_FOR_systtools::utility "${_IMPORT_PREFIX}/lib/libsystematicstools_utility.so" )

# Commands beyond this point should not need to know the version.
set(CMAKE_IMPORT_FILE_VERSION)
