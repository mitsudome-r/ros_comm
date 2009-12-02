# DO NOT EDIT THIS FILE

# To change your build configuration, create a file called
# 'rosconfig.cmake' and put it where it will be loaded from here.
# The order of processing is the following, with later steps overriding
# earlier ones:
#  - read this file
#  - if present, read $(ROS_ROOT)/rosconfig.cmake
#  - if present, read rosconfig.cmake from the current packages's top-level
#      directory.
#  - read the rest of the package's CMakeLists.txt (i.e., the content after
#      the invocation of rospack(), which is how we get here

# Unset variables, to force cmake to go looking for the rosconfig.cmake
# again (as opposed to looking up the variables' values in the cache). This
# specifically avoids build failures when a rosconfig.cmake was created,
# then removed, #617.
set(USERCONFIG USERCONFIG-NOTFOUND)
set(PROJECTCONFIG PROJECTCONFIG-NOTFOUND)

#############################################################
# look for user's override in $ROS_ROOT/rosconfig.cmake
find_file(USERCONFIG
          rosconfig.cmake
          PATHS ENV ROS_ROOT
          NO_DEFAULT_PATH)
if(USERCONFIG)
  message("including user's config file: ${USERCONFIG}")
  include(${USERCONFIG})
endif(USERCONFIG)

# look for user's override in rosconfig.cmake in current package directory
find_file(PROJECTCONFIG
          rosconfig.cmake
          PATHS ${PROJECT_SOURCE_DIR}
          NO_DEFAULT_PATH)
if(PROJECTCONFIG)
  message("including package's config file: ${PROJECTCONFIG}")
  include(${PROJECTCONFIG})
endif(PROJECTCONFIG)
#############################################################


#############################################################
# These are default ROS-wide build configuration settings for CMake.  These
# settings are used wherever rospack(<packagename>) is done in a 
# CMakeLists.txt file.  Note that these setting only affect packages 
# that are built with CMake.

# Set the build type.  Options are:
#  Debug          : w/ debug symbols, w/o optimization
#  Release        : w/o debug symbols, w/ optimization
#  RelWithDebInfo : w/ debug symbols, w/ optimization
#  MinSizeRel     : w/o debug symbols, w/ optimization, stripped binaries
if(NOT DEFINED ROS_BUILD_TYPE)
  set(ROS_BUILD_TYPE RelWithDebInfo)
endif(NOT DEFINED ROS_BUILD_TYPE)

# Build static-only executables (e.g., for copying over to another
# machine)? true or false
if(NOT DEFINED ROS_BUILD_STATIC_EXES)
  set(ROS_BUILD_STATIC_EXES false)
endif(NOT DEFINED ROS_BUILD_STATIC_EXES)

# Build shared libs? true or false
if(NOT DEFINED ROS_BUILD_SHARED_LIBS)
  set(ROS_BUILD_SHARED_LIBS true)
endif(NOT DEFINED ROS_BUILD_SHARED_LIBS)

# Build static libs? true or false
if(NOT DEFINED ROS_BUILD_STATIC_LIBS)
  set(ROS_BUILD_STATIC_LIBS false)
endif(NOT DEFINED ROS_BUILD_STATIC_LIBS)

# Default compile flags for all source files
include(CheckCXXCompilerFlag)
if(NOT DEFINED ROS_COMPILE_FLAGS)
  set(ROS_COMPILE_FLAGS "-W -Wall -Wno-unused-parameter -fno-strict-aliasing")
  # Old versions of gcc need -pthread to enable threading, #2095.  
  # We have one data point, which is gcc 3.3.  We'll heuristically 
  # add -pthread to any gcc < 4.0.
  #
  # Cursory testing on Linux suggests that passing -pthread when 
  # you don't need it doesn't materially change the resulting object file.
  execute_process(COMMAND ${CMAKE_CXX_COMPILER} -dumpversion
                  ERROR_VARIABLE _cxx_version_failed
                  OUTPUT_VARIABLE _cxx_version
                  OUTPUT_STRIP_TRAILING_WHITESPACE)
  if(NOT _cxx_version_failed)
    STRING(REGEX REPLACE "^([0-9]+)\\.[0-9]+\\.[0-9]+" "\\1" _cxx_version_major "${_cxx_version}")
    if(_cxx_version_major)
      if(${_cxx_version_major} LESS 4)
        set(ROS_COMPILE_FLAGS "${ROS_COMPILE_FLAGS} -pthread")
      endif(${_cxx_version_major} LESS 4)
    endif(_cxx_version_major)
  endif(NOT _cxx_version_failed)
endif(NOT DEFINED ROS_COMPILE_FLAGS)

# Default link flags for all executables and libraries
if(NOT DEFINED ROS_LINK_FLAGS)
  set(ROS_LINK_FLAGS "")
endif(NOT DEFINED ROS_LINK_FLAGS)

# Default libraries to link against for all executables and libraries
if(NOT DEFINED ROS_LINK_LIBS)
  set(ROS_LINK_LIBS "")
endif(NOT DEFINED ROS_LINK_LIBS)

#############################################################

