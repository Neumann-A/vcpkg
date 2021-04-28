function(setup_build_jam SOURCE_DIR)
    configure_file("${CURRENT_INSTALLED_DIR}/share/boost-build/boost-build.jam.in" "${SOURCE_DIR}/boost-build.jam" @ONLY)
    configure_file("${CURRENT_INSTALLED_DIR}/share/boost-build/Jamroot.jam.in" "${SOURCE_DIR}/Jamroot.jam" @ONLY)
    configure_file("${CURRENT_INSTALLED_DIR}/share/boost-build/Jamfile.headers.in" "${SOURCE_DIR}/include/Jamfile" @ONLY)
    file(COPY "${CURRENT_INSTALLED_DIR}/tools/boost-build/boostcpp.jam"
                 #"${CURRENT_INSTALLED_DIR}/share/boost_install/boost-install.jam" 
                 #"${CURRENT_INSTALLED_DIR}/share/boost_install/boost-install-dirs.jam"
                 #"${CURRENT_INSTALLED_DIR}/share/boost/BoostDetectToolset.cmake"
                 #"${CURRENT_INSTALLED_DIR}/share/boost/BoostConfig.cmake"
                 DESTINATION "${SOURCE_DIR}")
    #file(COPY "${CURRENT_INSTALLED_DIR}/boost_build_headers/build"
    #             DESTINATION "${SOURCE_DIR}/lib/headers")
    file(COPY "${CURRENT_INSTALLED_DIR}/share/boost_install"
                 DESTINATION "${SOURCE_DIR}/tools")
    file(COPY "${CURRENT_INSTALLED_DIR}/share/boost/BoostDetectToolset.cmake"
              "${CURRENT_INSTALLED_DIR}/share/boost/BoostConfig.cmake"
              "${CURRENT_INSTALLED_DIR}/share/boost/BoostVersion.cmake"
                 DESTINATION "${SOURCE_DIR}/tools/boost_install")
endfunction()

function(boost_modular_build)
    cmake_parse_arguments(_bm "" "SOURCE_PATH;REQUIREMENTS;BOOST_CMAKE_FRAGMENT" "OPTIONS" ${ARGN})

    if(NOT DEFINED _bm_SOURCE_PATH)
        message(FATAL_ERROR "SOURCE_PATH is a required argument to boost_modular_build.")
    endif()

    # Getting boost build for the host machine (build machine if you use autotool definition)
    # TODO: this serves too similar a purpose as vcpkg_find_acquire_program()
    if(CMAKE_HOST_WIN32 AND VCPKG_CMAKE_SYSTEM_NAME AND NOT VCPKG_CMAKE_SYSTEM_NAME STREQUAL "WindowsStore")
        get_filename_component(BOOST_BUILD_PATH "${CURRENT_INSTALLED_DIR}/../x86-windows/tools/boost-build" ABSOLUTE)
    elseif(NOT VCPKG_TARGET_ARCHITECTURE STREQUAL "x64" AND NOT VCPKG_TARGET_ARCHITECTURE STREQUAL "x86")
        get_filename_component(BOOST_BUILD_PATH "${CURRENT_INSTALLED_DIR}/../x86-windows/tools/boost-build" ABSOLUTE)
    else()
        set(BOOST_BUILD_PATH "${CURRENT_INSTALLED_DIR}/tools/boost-build")
    endif()

    if(NOT EXISTS "${BOOST_BUILD_PATH}")
        message(FATAL_ERROR "The x86 boost-build tools must be installed to build for non-x86/x64 platforms. Please run `vcpkg install boost-build:x86-windows`.")
    endif()

    if(EXISTS "${BOOST_BUILD_PATH}/b2.exe")
        set(B2_EXE "${BOOST_BUILD_PATH}/b2.exe")
    elseif(EXISTS "${BOOST_BUILD_PATH}/b2")
        set(B2_EXE "${BOOST_BUILD_PATH}/b2")
    else()
        message(FATAL_ERROR "Could not find b2 in ${BOOST_BUILD_PATH}")
    endif()

    ##################### 
    set(_bm_DIR ${CURRENT_INSTALLED_DIR}/share/boost-build)
    # Adjust build rules to current vcpkg layout
    if(VCPKG_TARGET_IS_WINDOWS)
        set(BOOST_LIB_PREFIX)
        set(BOOST_LIB_RELEASE_SUFFIX -vc140-mt.${VCPKG_TARGET_STATIC_LIBRARY_PREFIX})
        set(BOOST_LIB_DEBUG_SUFFIX -vc140-mt-gd.${VCPKG_TARGET_STATIC_LIBRARY_PREFIX})
    else()
        set(BOOST_LIB_PREFIX lib)
        if(VCPKG_LIBRARY_LINKAGE STREQUAL "static")
            set(BOOST_LIB_RELEASE_SUFFIX ${VCPKG_TARGET_STATIC_LIBRARY_PREFIX})
            set(BOOST_LIB_DEBUG_SUFFIX ${VCPKG_TARGET_STATIC_LIBRARY_PREFIX})
        else()
            set(BOOST_LIB_RELEASE_SUFFIX ${VCPKG_TARGET_SHARED_LIBRARY_SUFFIX})
            set(BOOST_LIB_DEBUG_SUFFIX ${VCPKG_TARGET_SHARED_LIBRARY_SUFFIX})
        endif()
    endif()
    set(REQUIREMENTS ${_bm_REQUIREMENTS})
    if(EXISTS "${_bm_SOURCE_PATH}/build/Jamfile.v2")
        file(READ ${_bm_SOURCE_PATH}/build/Jamfile.v2 _contents)
        #string(REPLACE "import ../../predef/check/predef" "import predef/check/predef" _contents "${_contents}")
        #string(REPLACE "import ../../config/checks/config" "import config/checks/config" _contents "${_contents}")
        string(REGEX REPLACE
            "\.\./\.\./([^/ ]+)/build//(boost_[^/ ]+)"
            "/boost/\\1//\\2"
            _contents
            "${_contents}"
        )
        string(REGEX REPLACE " /boost//([^/ ]+)" " /boost/\\1//boost_\\1" _contents "${_contents}")
        file(WRITE ${_bm_SOURCE_PATH}/build/Jamfile.v2 "${_contents}")
    endif()
    setup_build_jam("${_bm_SOURCE_PATH}")
    ######################################################################
    if(NOT VCPKT_TARGET_IS_WINDOWS) 
        if(DEFINED _bm_BOOST_CMAKE_FRAGMENT)
            set(fragment_option "-DBOOST_CMAKE_FRAGMENT=${_bm_BOOST_CMAKE_FRAGMENT}")
        endif()
        vcpkg_configure_cmake(
            SOURCE_PATH ${CURRENT_INSTALLED_DIR}/share/boost-build
            PREFER_NINJA
            OPTIONS
                "-DB2_EXE=${B2_EXE}"
                "-DBOOST_BUILD_DIR=${_bm_DIR}"
                "-DSOURCE_PATH=${_bm_SOURCE_PATH}"
                "-DBOOST_BUILD_PATH=${BOOST_BUILD_PATH}"
                ${fragment_option}
                "-DVCPKG_CONCURRENCY=${VCPKG_CONCURRENCY}"
                "-DCURRENT_INSTALLED_DIR=${CURRENT_INSTALLED_DIR}"
                "-DCURRENT_PACKAGES_DIR=${CURRENT_PACKAGES_DIR}"
                "-DPORT=${PORT}"
        )
        vcpkg_install_cmake()

        if(NOT EXISTS ${CURRENT_PACKAGES_DIR}/lib)
            message(FATAL_ERROR "No libraries were produced. This indicates a failure while building the boost library.")
        endif()
        return()
    endif()
    #################################################
    ## Windows b uilds below

    # #####################
    # # Cleanup previous builds
    # ######################
    # file(REMOVE_RECURSE ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel)
    # if(EXISTS ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel)
        # # It is possible for a file in this folder to be locked due to antivirus or vctip
        # execute_process(COMMAND ${CMAKE_COMMAND} -E sleep 1)
        # file(REMOVE_RECURSE ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel)
        # if(EXISTS ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel)
            # message(FATAL_ERROR "Unable to remove directory: ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel\n  Files are likely in use.")
        # endif()
    # endif()

    # file(REMOVE_RECURSE ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-dbg)
    # if(EXISTS ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-dbg)
        # # It is possible for a file in this folder to be locked due to antivirus or vctip
        # execute_process(COMMAND ${CMAKE_COMMAND} -E sleep 1)
        # file(REMOVE_RECURSE ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-dbg)
        # if(EXISTS ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-dbg)
            # message(FATAL_ERROR "Unable to remove directory: ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-dbg\n  Files are likely in use.")
        # endif()
    # endif()

    # if(EXISTS ${CURRENT_PACKAGES_DIR}/debug)
        # message(FATAL_ERROR "Error: directory exists: ${CURRENT_PACKAGES_DIR}/debug\n  The previous package was not fully cleared. This is an internal error.")
    # endif()
    # file(MAKE_DIRECTORY
        # ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-dbg
        # ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel
    # )

    # # if(DEFINED ENV{NUMBER_OF_PROCESSORS})
        # # set(NUMBER_OF_PROCESSORS $ENV{NUMBER_OF_PROCESSORS})
    # # else()
        # # execute_process(
            # # COMMAND nproc
            # # OUTPUT_VARIABLE NUMBER_OF_PROCESSORS
        # # )
        # # string(REPLACE "\n" "" NUMBER_OF_PROCESSORS "${NUMBER_OF_PROCESSORS}")
        # # string(REPLACE " " "" NUMBER_OF_PROCESSORS "${NUMBER_OF_PROCESSORS}")
    # # endif()

    # ######################
    # # Generate configuration
    # ######################
    
    # if(VCPKG_CMAKE_SYSTEM_NAME STREQUAL "WindowsStore")
        # list(APPEND _bm_OPTIONS windows-api=store)
    # endif()
    # list(APPEND _bm_OPTIONS
        # -j${VCPKG_CONCURRENCY}
        # --debug-configuration
        # --debug-building
        # --debug-generators
        # --disable-icu
        # --ignore-site-config
        # --hash
        # -q
        # "-sZLIB_INCLUDE=${CURRENT_INSTALLED_DIR}/include"
        # "-sBZIP2_INCLUDE=${CURRENT_INSTALLED_DIR}/include"
        # "-sLZMA_INCLUDE=${CURRENT_INSTALLED_DIR}/include"
        # "-sZSTD_INCLUDE=${CURRENT_INSTALLED_DIR}/include"
        # threading=multi
    # )
    # list(APPEND _bm_OPTIONS threadapi=win32)


    # set(_bm_OPTIONS_DBG
         # -sZLIB_BINARY=zlibd
         # "-sZLIB_LIBPATH=${CURRENT_INSTALLED_DIR}/debug/lib"
         # -sBZIP2_BINARY=bz2d
         # "-sBZIP2_LIBPATH=${CURRENT_INSTALLED_DIR}/debug/lib"
         # -sLZMA_BINARY=lzmad
         # "-sLZMA_LIBPATH=${CURRENT_INSTALLED_DIR}/debug/lib"
         # -sZSTD_BINARY=zstdd
         # "-sZSTD_LIBPATH=${CURRENT_INSTALLED_DIR}/debug/lib"
    # )
 
    # set(_bm_OPTIONS_REL
         # -sZLIB_BINARY=zlib
         # "-sZLIB_LIBPATH=${CURRENT_INSTALLED_DIR}/lib"
         # -sBZIP2_BINARY=bz2
         # "-sBZIP2_LIBPATH=${CURRENT_INSTALLED_DIR}/lib"
         # -sLZMA_BINARY=lzma
         # "-sLZMA_LIBPATH=${CURRENT_INSTALLED_DIR}/lib"
         # -sZSTD_BINARY=zstd
         # "-sZSTD_LIBPATH=${CURRENT_INSTALLED_DIR}/lib"
    # )
    
    # # Properly handle compiler and linker flags passed by VCPKG
    # if(VCPKG_CXX_FLAGS)
        # list(APPEND _bm_OPTIONS "cxxflags=${VCPKG_CXX_FLAGS}")
    # endif()

    # if(VCPKG_CXX_FLAGS_RELEASE)
        # list(APPEND _bm_OPTIONS_REL "cxxflags=${VCPKG_CXX_FLAGS_RELEASE}")
    # endif()

    # if(VCPKG_CXX_FLAGS_DEBUG)
        # list(APPEND _bm_OPTIONS_DBG "cxxflags=${VCPKG_CXX_FLAGS_DEBUG}")
    # endif()


    # if(VCPKG_C_FLAGS)
        # list(APPEND _bm_OPTIONS "cflags=${VCPKG_C_FLAGS}")
    # endif()

    # if(VCPKG_C_FLAGS_RELEASE)
        # list(APPEND _bm_OPTIONS_REL "cflags=${VCPKG_C_FLAGS_RELEASE}")
    # endif()

    # if(VCPKG_C_FLAGS_DEBUG)
        # list(APPEND _bm_OPTIONS_DBG "cflags=${VCPKG_C_FLAGS_DEBUG}")
    # endif()


    # if(VCPKG_LINKER_FLAGS)
        # list(APPEND _bm_OPTIONS "linkflags=${VCPKG_LINKER_FLAGS}")
    # endif()

    # if(VCPKG_LINKER_FLAGS_RELEASE)
        # list(APPEND _bm_OPTIONS_REL "linkflags=${VCPKG_LINKER_FLAGS_RELEASE}")
    # endif()

    # if(VCPKG_LINKER_FLAGS_DEBUG)
        # list(APPEND _bm_OPTIONS_DBG "linkflags=${VCPKG_LINKER_FLAGS_DEBUG}")
    # endif()


    # # Add build type specific options
    # if(VCPKG_CRT_LINKAGE STREQUAL "dynamic")
        # list(APPEND _bm_OPTIONS runtime-link=shared)
    # else()
        # list(APPEND _bm_OPTIONS runtime-link=static)
    # endif()

    # if (VCPKG_LIBRARY_LINKAGE STREQUAL "dynamic")
        # list(APPEND _bm_OPTIONS link=shared)
    # else()
        # list(APPEND _bm_OPTIONS link=static)
    # endif()

    # if(VCPKG_TARGET_ARCHITECTURE MATCHES "x64")
        # list(APPEND _bm_OPTIONS address-model=64 architecture=x86)
    # elseif(VCPKG_TARGET_ARCHITECTURE STREQUAL "arm")
        # list(APPEND _bm_OPTIONS address-model=32 architecture=arm)
    # elseif(VCPKG_TARGET_ARCHITECTURE STREQUAL "arm64")
        # list(APPEND _bm_OPTIONS address-model=64 architecture=arm)
    # else()
        # list(APPEND _bm_OPTIONS address-model=32 architecture=x86)
    # endif()

    # file(TO_CMAKE_PATH "${_bm_DIR}/nothing.bat" NOTHING_BAT)

    # configure_file(${_bm_DIR}/user-config.jam ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-dbg/user-config.jam @ONLY)
    # configure_file(${_bm_DIR}/user-config.jam ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel/user-config.jam @ONLY)

    # if(VCPKG_PLATFORM_TOOLSET MATCHES "v14.")
        # list(APPEND _bm_OPTIONS toolset=msvc)
    # elseif(VCPKG_PLATFORM_TOOLSET MATCHES "external")
        # list(APPEND _bm_OPTIONS toolset=gcc)
    # else()
        # message(FATAL_ERROR "Unsupported value for VCPKG_PLATFORM_TOOLSET: '${VCPKG_PLATFORM_TOOLSET}'")
    # endif()

    # ######################
    # # Perform build + Package
    # ######################
    # if(NOT DEFINED VCPKG_BUILD_TYPE OR VCPKG_BUILD_TYPE STREQUAL "release")
        # message(STATUS "Building ${TARGET_TRIPLET}-rel")
        # set(ENV{BOOST_BUILD_PATH} "${BOOST_BUILD_PATH}")
        # vcpkg_execute_required_process(
            # COMMAND "${B2_EXE}"
                # --stagedir=${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel/stage
                # --build-dir=${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel
                # --user-config=${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel/user-config.jam
                # ${_bm_OPTIONS}
                # ${_bm_OPTIONS_REL}
                # variant=release
                # debug-symbols=on
            # WORKING_DIRECTORY ${_bm_SOURCE_PATH}/build
            # LOGNAME build-${TARGET_TRIPLET}-rel
        # )
        # message(STATUS "Building ${TARGET_TRIPLET}-rel done")
    # endif()

    # if(NOT DEFINED VCPKG_BUILD_TYPE OR VCPKG_BUILD_TYPE STREQUAL "debug")
        # message(STATUS "Building ${TARGET_TRIPLET}-dbg")
        # set(ENV{BOOST_BUILD_PATH} "${BOOST_BUILD_PATH}")
        # vcpkg_execute_required_process(
            # COMMAND "${B2_EXE}"
                # --stagedir=${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-dbg/stage
                # --build-dir=${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-dbg
                # --user-config=${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-dbg/user-config.jam
                # ${_bm_OPTIONS}
                # ${_bm_OPTIONS_DBG}
                # variant=debug
            # WORKING_DIRECTORY ${_bm_SOURCE_PATH}/build
            # LOGNAME build-${TARGET_TRIPLET}-dbg
        # )
        # message(STATUS "Building ${TARGET_TRIPLET}-dbg done")
    # endif()

    # if(NOT DEFINED VCPKG_BUILD_TYPE OR VCPKG_BUILD_TYPE STREQUAL "release")
        # message(STATUS "Packaging ${TARGET_TRIPLET}-rel")
        # file(GLOB REL_LIBS
            # ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel/boost/build/*/*.lib
            # ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel/boost/build/*/*.a
            # ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel/boost/build/*/*.so
        # )
        # file(COPY ${REL_LIBS}
            # DESTINATION ${CURRENT_PACKAGES_DIR}/lib)
        # if (VCPKG_LIBRARY_LINKAGE STREQUAL dynamic)
            # file(GLOB REL_DLLS ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel/boost/build/*/*.dll)
            # file(COPY ${REL_DLLS}
                # DESTINATION ${CURRENT_PACKAGES_DIR}/bin
                # FILES_MATCHING PATTERN "*.dll")
        # endif()
        # message(STATUS "Packaging ${TARGET_TRIPLET}-rel done")
    # endif()

    # if(NOT DEFINED VCPKG_BUILD_TYPE OR VCPKG_BUILD_TYPE STREQUAL "debug")
        # message(STATUS "Packaging ${TARGET_TRIPLET}-dbg")
        # file(GLOB DBG_LIBS
            # ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-dbg/boost/build/*/*.lib
            # ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-dbg/boost/build/*/*.a
            # ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-dbg/boost/build/*/*.so
        # )
        # file(COPY ${DBG_LIBS}
            # DESTINATION ${CURRENT_PACKAGES_DIR}/debug/lib)
        # if (VCPKG_LIBRARY_LINKAGE STREQUAL dynamic)
            # file(GLOB DBG_DLLS ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-dbg/boost/build/*/*.dll)
            # file(COPY ${DBG_DLLS}
                # DESTINATION ${CURRENT_PACKAGES_DIR}/debug/bin
                # FILES_MATCHING PATTERN "*.dll")
        # endif()
        # message(STATUS "Packaging ${TARGET_TRIPLET}-dbg done")
    # endif()
    
    if(VCPKG_TARGET_IS_WINDOWS)
        # Lib renaming due to missing configs.. 
        file(GLOB INSTALLED_LIBS ${CURRENT_PACKAGES_DIR}/debug/lib/*.lib ${CURRENT_PACKAGES_DIR}/lib/*.lib)
        foreach(LIB ${INSTALLED_LIBS})
            get_filename_component(OLD_FILENAME ${LIB} NAME)
            get_filename_component(DIRECTORY_OF_LIB_FILE ${LIB} DIRECTORY)
            string(REPLACE "libboost_" "boost_" NEW_FILENAME ${OLD_FILENAME})
            string(REPLACE "-s-" "-" NEW_FILENAME ${NEW_FILENAME}) # For Release libs
            string(REPLACE "-vc141-" "-vc140-" NEW_FILENAME ${NEW_FILENAME}) # To merge VS2017 and VS2015 binaries
            string(REPLACE "-vc142-" "-vc140-" NEW_FILENAME ${NEW_FILENAME}) # To merge VS2019 and VS2015 binaries
            string(REPLACE "-sgd-" "-gd-" NEW_FILENAME ${NEW_FILENAME}) # For Debug libs
            string(REPLACE "-sgyd-" "-gyd-" NEW_FILENAME ${NEW_FILENAME}) # For Debug libs
            string(REPLACE "-x32-" "-" NEW_FILENAME ${NEW_FILENAME}) # To enable CMake 3.10 and earlier to locate the binaries
            string(REPLACE "-x64-" "-" NEW_FILENAME ${NEW_FILENAME}) # To enable CMake 3.10 and earlier to locate the binaries
            string(REPLACE "-a32-" "-" NEW_FILENAME ${NEW_FILENAME}) # To enable CMake 3.10 and earlier to locate the binaries
            string(REPLACE "-a64-" "-" NEW_FILENAME ${NEW_FILENAME}) # To enable CMake 3.10 and earlier to locate the binaries
            string(REPLACE "-1_72" "" NEW_FILENAME ${NEW_FILENAME}) # To enable CMake > 3.10 to locate the binaries
            if("${DIRECTORY_OF_LIB_FILE}/${NEW_FILENAME}" STREQUAL "${DIRECTORY_OF_LIB_FILE}/${OLD_FILENAME}")
                # nothing to do
            elseif(EXISTS ${DIRECTORY_OF_LIB_FILE}/${NEW_FILENAME})
                file(REMOVE ${DIRECTORY_OF_LIB_FILE}/${OLD_FILENAME})
            else()
                file(RENAME ${DIRECTORY_OF_LIB_FILE}/${OLD_FILENAME} ${DIRECTORY_OF_LIB_FILE}/${NEW_FILENAME})
            endif()
        endforeach()
        vcpkg_copy_pdbs()
    endif()
    file(REMVOE "${CURRENT_PACKAGES_DIR}/share/boost/BoostDetectToolset.cmake"
                "${CURRENT_PACKAGES_DIR}/share/boost/BoostConfig.cmake"
                "${CURRENT_PACKAGES_DIR}/share/boost/BoostVersion.cmake")
endfunction()
