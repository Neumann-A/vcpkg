cmake_minimum_required(VERSION 3.14)
project(boost LANGUAGES C CXX ASM_MASM)

# Create a b2 project config based on CMake toolchain settings.
set(config "TOOLSET_SETTINGS")
set(${config} "")
if(WIN32)
  if(CMAKE_CXX_COMPILER_ID STREQUAL Clang)
    string(APPEND ${config} "using clang-win : ${CMAKE_CXX_COMPILER_VERSION} : ")
  elseif(MSVC)
    string(REGEX REPLACE "^([0-9]*)([0-9])$" "\\1.\\2" toolset_version "${MSVC_TOOLSET_VERSION}")
    string(APPEND ${config} "using msvc : ${toolset_version} : ")
  elseif(CMAKE_CXX_COMPILER_ID STREQUAL Intel)
    message(FATAL_ERROR "Intel compiler currently not supported by boost within vcpkg!")
  else()
    string(APPEND ${config} "using gcc : ${CMAKE_CXX_COMPILER_VERSION} : ")
  endif()
else()
  if(CMAKE_CXX_COMPILER_ID STREQUAL Clang)
    string(APPEND ${config} "using clang-linux : ${CMAKE_CXX_COMPILER_VERSION} : ")
  else()
    string(APPEND ${config} "using gcc : ${CMAKE_CXX_COMPILER_VERSION} : ")
  endif()
endif()

string(APPEND ${config} "\"${CMAKE_CXX_COMPILER}\" :\n")
if(WIN32)
    file(TO_CMAKE_PATH "${BOOST_BUILD_DIR}/nothing.bat" NOTHING_BAT)
    string(APPEND ${config} "<setup>\"${NOTHING_BAT}\"\n")
elseif(MINGW)
    string(APPEND ${config} "<flavor>mingw")
endif()
string(APPEND ${config} "\n")

macro(append name value)
  string(REPLACE "\"" "\\\"" quoted_value "${value}")
  string(APPEND ${config} "${name}\"${quoted_value}\"\n")
endmacro()

if(WIN32 AND DEFINED CMAKE_LINKER)
  append("<linker>" "\"${CMAKE_LINKER}\"")
  string(APPEND ${config} "\n")
endif()
if(DEFINED CMAKE_RANLIB AND NOT CMAKE_RANLIB STREQUAL ":")
    append("<ranlib>" "${CMAKE_RANLIB}")
endif()
if(DEFINED CMAKE_AR)
    append("<archiver>" "${CMAKE_AR}")
endif()
append("<cflags>" "${CMAKE_C_FLAGS}")
append("<variant>debug:<cflags>" "${CMAKE_C_FLAGS_DEBUG}")
append("<variant>release:<cflags>" "${CMAKE_C_FLAGS_RELEASE}")
string(APPEND ${config} "\n")

if(CMAKE_CXX_STANDARD)
  if(CMAKE_CXX_STANDARD STREQUAL 98)
    append("<cxxstd>" "98")
  elseif(CMAKE_CXX_STANDARD STREQUAL 11)
    append("<cxxstd>" "11")
  elseif(CMAKE_CXX_STANDARD STREQUAL 14)
    append("<cxxstd>" "14")
  elseif(CMAKE_CXX_STANDARD STREQUAL 17)
    append("<cxxstd>" "17")
  else()
    append("<cxxstd>" "latest")
    # TODO: Add boost version check when asio fixes this.
    append("<cxxflags>" "-DBOOST_ASIO_DISABLE_CONCEPTS")
  endif()
  if(NOT CMAKE_CXX_EXTENSIONS)
    append("<cxxstd-dialect>" "iso")
  endif()
endif()
append("<cxxflags>" "${CMAKE_CXX_FLAGS}")
append("<variant>debug:<cxxflags>" "${CMAKE_CXX_FLAGS_DEBUG}")
append("<variant>release:<cxxflags>" "${CMAKE_CXX_FLAGS_RELEASE}")
string(APPEND ${config} "\n")

if(BUILD_SHARED_LIBS)
  append("<linkflags>" "${CMAKE_SHARED_LINKER_FLAGS}")
  append("<variant>debug:<linkflags>" "${CMAKE_SHARED_LINKER_FLAGS_DEBUG}")
  append("<variant>release:<linkflags>" "${CMAKE_SHARED_LINKER_FLAGS_RELEASE}")
else()
  append("<linkflags>" "${CMAKE_STATIC_LINKER_FLAGS}")
  append("<variant>debug:<linkflags>" "${CMAKE_STATIC_LINKER_FLAGS_DEBUG}")
  append("<variant>release:<linkflags>" "${CMAKE_STATIC_LINKER_FLAGS_RELEASE}")
endif()
string(APPEND ${config} "\n")

get_property(COMPILE_DEFINITIONS DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} PROPERTY COMPILE_DEFINITIONS)
foreach(define ${COMPILE_DEFINITIONS})
  string(APPEND ${config} "<define>${define}\n")
endforeach()

if(CMAKE_SYSTEM_NAME MATCHES "WindowsStore" AND MSVC)
    # set(TOOLSET_OPTIONS " <cxxflags>/EHsc <compileflags>-Zm800 <compileflags>-nologo")
    # if(VCPKG_CMAKE_SYSTEM_NAME STREQUAL "WindowsStore")
        if(NOT VCPKG_PLATFORM_TOOLSET MATCHES "v140")
            find_path(PATH_TO_CL cl.exe)
            find_path(PLATFORM_WINMD_DIR platform.winmd PATHS "${PATH_TO_CL}/../../../lib/x86/store/references" NO_DEFAULT_PATH)
            if(PLATFORM_WINMD_DIR MATCHES "NOTFOUND")
                message(FATAL_ERROR "Could not find `platform.winmd` in VS. Do you have the Universal Windows Platform development workload installed?")
            endif()
        else()
            find_path(PLATFORM_WINMD_DIR platform.winmd PATHS "$ENV{VS140COMNTOOLS}/../../VC/LIB/store/references")
            if(PLATFORM_WINMD_DIR MATCHES "NOTFOUND")
                message(FATAL_ERROR "Could not find `platform.winmd` in VS2015.")
            endif()
        endif()
        file(TO_NATIVE_PATH "${PLATFORM_WINMD_DIR}" PLATFORM_WINMD_DIR)
        string(REPLACE "\\" "/" PLATFORM_WINMD_DIR ${PLATFORM_WINMD_DIR}) # escape backslashes
        string(APPEND ${config} "<cflags>-Zl <compileflags> /AI\"${PLATFORM_WINMD_DIR}\" <linkflags>WindowsApp.lib <cxxflags>/ZW <compileflags>-DVirtualAlloc=VirtualAllocFromApp <compileflags>-D_WIN32_WINNT=0x0A00\n")
    # else()
        # set(TOOLSET_OPTIONS "${TOOLSET_OPTIONS} <compileflags>-D_WIN32_WINNT=0x0602")
    # endif()
endif()

string(APPEND ${config} "\n;\n")

###### End of toolset setup

find_path(BZIP2_INCLUDE bzlib.h)
if(NOT BZIP2_INCLUDE)
    message(FATAL_ERROR "Could not find bzip2 header: bzlib.h")
endif()
find_library(BZIP2_LIBRARY NAMES bz2 bz2d NAMES_PER_DIR)
if(NOT BZIP2_LIBRARY)
    message(FATAL_ERROR "Could not find library: bzip")
endif()
get_filename_component(BZIP2_SEARCH ${BZIP2_LIBRARY} DIRECTORY)
get_filename_component(BZIP2_NAME ${BZIP2_LIBRARY} NAME_WLE )
#set(BZIP2_INCLUDE ${BZIP2_INCLUDE_DIR})
string(APPEND ${config} "\nusing bzip2 : :\n")
string(APPEND ${config} "<include>\"${BZIP2_INCLUDE}\"\n")
string(APPEND ${config} "<search>\"${BZIP2_SEARCH}\"\n")
string(APPEND ${config} "<name>\"${BZIP2_NAME}\"\n;\n")

find_path(ZLIB_INCLUDE zlib.h)
if(NOT ZLIB_INCLUDE)
    message(FATAL_ERROR "Could not find zlib header: zlib.h")
endif()

find_library(ZLIB_LIBRARY NAMES zlibd zlib z NAMES_PER_DIR)
if(NOT ZLIB_LIBRARY)
    message(FATAL_ERROR "Could not find library: zlib")
endif()
get_filename_component(ZLIB_SEARCH ${ZLIB_LIBRARY} DIRECTORY)
get_filename_component(ZLIB_NAME ${ZLIB_LIBRARY} NAME_WLE )
#set(ZLIB_INCLUDE ${ZLIB_INCLUDE_DIR})
string(APPEND ${config} "\nusing zlib : :\n")
string(APPEND ${config} "<include>\"${ZLIB_INCLUDE}\"\n")
string(APPEND ${config} "<search>\"${ZLIB_SEARCH}\"\n")
string(APPEND ${config} "<name>\"${ZLIB_NAME}\"\n;\n")

find_path(ZSTD_INCLUDE zstd.h)
if(NOT ZSTD_INCLUDE)
    message(FATAL_ERROR "Could not find zstd header: zstd.h")
endif()
find_library(ZSTD_LIBRARY NAMES zstd zstdd zstd_static zstd_staticd NAMES_PER_DIR)
if(NOT ZSTD_LIBRARY)
    message(FATAL_ERROR "Could not find library: zstd")
endif()
get_filename_component(ZSTD_SEARCH ${ZSTD_LIBRARY} DIRECTORY)
get_filename_component(ZSTD_NAME ${ZSTD_LIBRARY} NAME_WLE )
#set(ZSTD_INCLUDE ${ZSTD_INCLUDE_DIR})
string(APPEND ${config} "\nusing zstd : :\n")
string(APPEND ${config} "<include>\"${ZSTD_INCLUDE}\"\n")
string(APPEND ${config} "<search>\"${ZSTD_SEARCH}\"\n")
string(APPEND ${config} "<name>\"${ZSTD_NAME}\"\n;\n")

configure_file(${CMAKE_CURRENT_LIST_DIR}/user-config.jam.in ${CMAKE_CURRENT_BINARY_DIR}/user-config.jam @ONLY)

find_path(ICU_PATH include/unicode/utf.h)

set(B2_OPTIONS)

if(DEFINED BOOST_CMAKE_FRAGMENT)
    include(${BOOST_CMAKE_FRAGMENT})
endif()

# Add build type specific options
if(BUILD_SHARED_LIBS)
    list(APPEND B2_OPTIONS link=shared)
else()
    list(APPEND B2_OPTIONS link=static)
endif()
# Set runtime linkage.
if(VCPKG_CRT_LINKAGE STREQUAL static)
  list(APPEND B2_OPTIONS runtime-link=static)
else()
  list(APPEND B2_OPTIONS runtime-link=shared)
endif()

if(VCPKG_TARGET_ARCHITECTURE MATCHES "x64")
    list(APPEND B2_OPTIONS address-model=64 architecture=x86)
elseif(VCPKG_TARGET_ARCHITECTURE STREQUAL "arm")
    list(APPEND B2_OPTIONS address-model=32 architecture=arm)
elseif(VCPKG_TARGET_ARCHITECTURE STREQUAL "arm64")
    list(APPEND B2_OPTIONS address-model=64 architecture=arm)
else()
    list(APPEND B2_OPTIONS address-model=32 architecture=x86)
endif()
# if(CMAKE_SIZEOF_VOID_P EQUAL 8)
    # list(APPEND B2_OPTIONS address-model=64)
# else()
    # list(APPEND B2_OPTIONS address-model=32)
# endif()

add_custom_target(boost ALL
    COMMAND "${B2_EXE}"
        #--project-config=${config}
        --user-config=${CMAKE_CURRENT_BINARY_DIR}/user-config.jam
        --prefix=${CMAKE_INSTALL_PREFIX}
        --libdir=${CMAKE_INSTALL_PREFIX}/lib
        --exec-prefix=${CMAKE_INSTALL_PREFIX}/bin
        --includedir=${CMAKE_INSTALL_PREFIX}/$<$<CONFIG:Debug>:../>include
        --cmakedir=${CMAKE_INSTALL_PREFIX}/share/boost
        --build-dir=${CMAKE_CURRENT_BINARY_DIR}/build
        ${B2_OPTIONS}
        --layout=system
        --with-atomic
        --with-random
        --with-date_time
        --with-filesystem
        --with-system
        --with-thread
        --with-chrono
        --debug-building        # Debug info on which targets are being build
        --debug-configuration   # Debug info on loading b2
        -sICU_PATH="${ICU_PATH}"
        -j${VCPKG_CONCURRENCY}
        -sBOOST_ROOT=${BOOST_BUILD_PATH}
        -sBOOST_BUILD_PATH=${BOOST_BUILD_PATH}
        --ignore-site-config
        --hash
        -q
        #architecture=x86
        threading=multi
        debug-symbols=on
        stage
        install
    WORKING_DIRECTORY ${SOURCE_PATH}/build
)

# Install PDB files.
install(CODE [[
  file(GLOB_RECURSE PDB_FILES ${CMAKE_CURRENT_BINARY_DIR}/build/boost/bin.v2/libs/*/boost_*.pdb)
  if(PDB_FILES)
    file(INSTALL ${PDB_FILES} DESTINATION ${CMAKE_INSTALL_PREFIX}/bin)
  endif()
]])

set(SUBDIR ${CMAKE_CURRENT_BINARY_DIR}/stage/lib)
install(
    CODE "file(GLOB LIBS ${SUBDIR}/*.so.* ${SUBDIR}/*.so ${SUBDIR}/*.a ${SUBDIR}/*.dylib ${SUBDIR}/*.dylib.*)\nif(LIBS)\nfile(INSTALL \${LIBS} DESTINATION \"\${CMAKE_INSTALL_PREFIX}/lib\")\nendif()"
)
