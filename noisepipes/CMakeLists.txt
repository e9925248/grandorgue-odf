# NoisePipes cmake build file
# Copyright (C) 2021 Lars Palo
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

cmake_minimum_required(VERSION 3.10)

# Set the project name and info
project(
  NoisePipes
  VERSION 0.2.0
  DESCRIPTION "NoisePipes - Software for writing ODF lines for noise effect stops"
  LANGUAGES CXX C
)

# Specify the C++ standard
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED True)

# Set output locations
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set(RESOURCE_INSTALL_DIR "share/${PROJECT_NAME}")
set(RESOURCE_DIR "${CMAKE_BINARY_DIR}/${RESOURCE_INSTALL_DIR}")


# Get wxWidgets
if(CMAKE_CROSSCOMPILING AND WIN32)
  set(wxWidgets_USE_UNICODE ON)
  set(wxWidgets_USE_STATIC ON)
endif()
find_package(wxWidgets REQUIRED html net adv core base)

# Get libsndfile somehow
if(CMAKE_LIBRARY_PATH AND CMAKE_PREFIX_PATH)
  add_library(Local_SF STATIC IMPORTED GLOBAL)
  set_target_properties(Local_SF PROPERTIES IMPORTED_LOCATION ${CMAKE_LIBRARY_PATH})
  set_target_properties(Local_SF PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${CMAKE_PREFIX_PATH})
  message(STATUS "Using a parameter supplied version of libsndfile.")
  set(USE_SUPPLIED_SF ON)
else()
  set(USE_SUPPLIED_SF OFF)

  # Get PkgConfig used for external libraries
  find_package(PkgConfig REQUIRED)

  pkg_check_modules(SF QUIET IMPORTED_TARGET sndfile)
  if(NOT SF_FOUND)
    message(FATAL_ERROR "

Couldn't find libsndfile!
Either install it or provide paths with options:

-DCMAKE_PREFIX_PATH=path/to/libsndfile/include
-DCMAKE_LIBRARY_PATH=path/to/libsndfile/lib/libsndfile.a

    ")
  else()
    message("Found an installation of libsndfile!")
  endif() 
endif()

# create definition file
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/src/NPDef.h.in ${CMAKE_CURRENT_BINARY_DIR}/src/NPDef.h)
include_directories(${CMAKE_CURRENT_BINARY_DIR}/src)

# include wxWidgets convenience file
include(${wxWidgets_USE_FILE})

# set some compile options
if(CMAKE_CROSSCOMPILING AND WIN32)
  add_compile_options(-static)
endif()
if(CMAKE_BUILD_TYPE STREQUAL "Debug")
  add_compile_options(-g -Wall -Wextra -pedantic)
else()
  add_compile_options(-O3 -mmmx -msse -msse2 -msse3 -mssse3 -mfpmath=sse -ffast-math)
endif()

# add windows resources
if(CMAKE_CROSSCOMPILING AND WIN32)
  configure_file(${CMAKE_SOURCE_DIR}/resources/NoisePipes.rc.in ${CMAKE_CURRENT_BINARY_DIR}/NoisePipes.rc)
  configure_file(${CMAKE_SOURCE_DIR}/resources/NoisePipes.ico ${CMAKE_CURRENT_BINARY_DIR}/NoisePipes.ico COPYONLY)
endif()

set(NP_SRC
  src/NoisePipes.cpp
  src/NPFrame.cpp
  src/NPPipe.cpp
)

# add the executable
if(CMAKE_CROSSCOMPILING AND WIN32)
  add_executable(${CMAKE_PROJECT_NAME}
    WIN32
    ${NP_SRC}
    NoisePipes.rc
  )
else()
  add_executable(${CMAKE_PROJECT_NAME}
    ${NP_SRC}
  )
endif()

# set windows specific linker options
if(CMAKE_CROSSCOMPILING AND WIN32)
  target_link_libraries(${CMAKE_PROJECT_NAME} PRIVATE
    -static
    -lwinmm
    -Wl,--as-needed
    -lssp
  )
endif()

# includes and link with libsndfile
if(${USE_SUPPLIED_SF})
  target_include_directories(${CMAKE_PROJECT_NAME} PUBLIC
    Local_SF
  )
  target_link_libraries(${CMAKE_PROJECT_NAME} PUBLIC
    Local_SF
  )
else()
  target_include_directories(${CMAKE_PROJECT_NAME} PUBLIC
    PkgConfig::SF
  )
  target_link_libraries(${CMAKE_PROJECT_NAME} PUBLIC
    PkgConfig::SF
  )
endif()

# link with wxWidgets
target_link_libraries(${CMAKE_PROJECT_NAME} PUBLIC
  ${wxWidgets_LIBRARIES}
)

# Strip binary for release builds
if(CMAKE_BUILD_TYPE STREQUAL "Release")
  if(CMAKE_CROSSCOMPILING AND WIN32)
    add_custom_command(TARGET ${CMAKE_PROJECT_NAME} POST_BUILD COMMAND strip --strip-all NoisePipes.exe WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
  else()
    add_custom_command(TARGET ${CMAKE_PROJECT_NAME} POST_BUILD COMMAND strip --strip-all ${CMAKE_PROJECT_NAME} WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
  endif()
endif()

# Copy icons to the build
set(ICON_SIZES 16 24 32 48 64 128 256 512 1024)
foreach(ICON_SIZE IN ITEMS ${ICON_SIZES})
  configure_file(${CMAKE_SOURCE_DIR}/resources/icons/${ICON_SIZE}x${ICON_SIZE}/${CMAKE_PROJECT_NAME}.png ${CMAKE_BINARY_DIR}/share/icons/hicolor/${ICON_SIZE}x${ICON_SIZE}/apps/${CMAKE_PROJECT_NAME}.png COPYONLY)
endforeach()

# Copy desktop file for linux
if(UNIX AND NOT APPLE)
  configure_file(${CMAKE_SOURCE_DIR}/resources/${CMAKE_PROJECT_NAME}.desktop.in ${CMAKE_BINARY_DIR}/share/${CMAKE_PROJECT_NAME}/applications/${CMAKE_PROJECT_NAME}.desktop COPYONLY)
endif()

# installation rules
install(TARGETS ${CMAKE_PROJECT_NAME} DESTINATION bin)
install(DIRECTORY ${CMAKE_BINARY_DIR}/share/icons/ DESTINATION share/icons FILES_MATCHING PATTERN "*.png")
if(UNIX AND NOT APPLE)
  install(FILES ${CMAKE_BINARY_DIR}/share/${CMAKE_PROJECT_NAME}/applications/${CMAKE_PROJECT_NAME}.desktop DESTINATION share/${CMAKE_PROJECT_NAME}/applications)
endif()

# packaging
set(CPACK_PACKAGE_NAME "NoisePipes")
set(CPACK_PACKAGE_VENDOR "NoisePipes")
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "NoisePipes - Software for writing ODF lines for noise effect stops")
set(
  CPACK_PACKAGE_DESCRIPTION
  "NoisePipes"
)
set(CPACK_PACKAGE_VERSION_MAJOR "${NoisePipes_VERSION_MAJOR}")
set(CPACK_PACKAGE_VERSION_MINOR "${NoisePipes_VERSION_MINOR}")
set(CPACK_PACKAGE_VERSION ${NoisePipes_VERSION})
set(CPACK_PACKAGE_INSTALL_DIRECTORY "NoisePipes")
set(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_SOURCE_DIR}/LICENSE.txt")
set(CPACK_PACKAGE_CONTACT "larspalo@yahoo.se")
set(CPACK_PACKAGE_EXECUTABLES "NoisePipes" "NoisePipes")
set(CPACK_SOURCE_IGNORE_FILES ".gitignore" "/build/")
if(WIN32)
  set(CPACK_SYSTEM_NAME "windows")
  set(CPACK_GENERATOR ZIP)
  set(CMAKE_SYSTEM_PROCESSOR "x86")
elseif(${CMAKE_SYSTEM_NAME} MATCHES "Linux")
  set(CPACK_SYSTEM_NAME "linux")
  set(CPACK_GENERATOR TGZ)
endif()
set(CPACK_PACKAGE_FILE_NAME "${CPACK_PACKAGE_NAME}-${CPACK_PACKAGE_VERSION}-${CPACK_SYSTEM_NAME}.${CMAKE_SYSTEM_PROCESSOR}")
include(CPack)

message(STATUS "

============================================================================
CMake Generator            : ${CMAKE_GENERATOR}
Project name               : ${CMAKE_PROJECT_NAME}
Project version            : ${NoisePipes_VERSION}
Build type                 : ${CMAKE_BUILD_TYPE}
Install prefix             : ${CMAKE_INSTALL_PREFIX}
Output directory           : ${CMAKE_BINARY_DIR}
Using users own libsndfile : ${USE_SUPPLIED_SF}
Libsndfile source include  : ${CMAKE_PREFIX_PATH}
Libsndfile library path    : ${CMAKE_LIBRARY_PATH}
============================================================================
wxWidgets Version          : ${wxWidgets_VERSION}
wxWidgets Unicode?         : ${wxWidgets_USE_UNICODE}
wxWidgets Debug?           : ${wxWidgets_USE_DEBUG}
wxWidgets Static linking   : ${wxWidgets_USE_STATIC}
wxWidgets config binary    : ${wxWidgets_CONFIG_EXECUTABLE}
wxWidgets configuration    : ${wxWidgets_CONFIGURATION}
============================================================================

")

