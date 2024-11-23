if(NOT _VCPKG_WINDOWS_TOOLCHAIN)
    set(_VCPKG_WINDOWS_TOOLCHAIN 1)

    # Load ENV if not loaded!
    if(NOT DEFINED ENV{MSVC_TOOLCHAIN_ENV_ALREADY_SET})
        block()
            include("${_VCPKG_INSTALLED_DIR}/${VCPKG_TARGET_TRIPLET}/share/msvc/msvc-env.cmake")
        endblock()
    endif()

    #set(CMAKE_GENERATOR_INSTANCE "${_VCPKG_INSTALLED_DIR}/${VCPKG_TARGET_TRIPLET}/VS/Common7/Tools" CACHE INTERNAL "" FORCE)

    if(TOOLCHAIN_ENABLE_Fortran AND
       NOT DEFINED ENV{INTEL_TOOLCHAIN_ENV_ALREADY_SET})
        block()
            include("${_VCPKG_INSTALLED_DIR}/${VCPKG_TARGET_TRIPLET}/share/intel-hpc/intel-msvc-env.cmake")
        endblock()
    endif()
    string(APPEND CMAKE_Fortran_FLAGS " -assume:underscore -assume:protect_parens -fp:strict -names:lowercase -Qopenmp-")

    include_directories(AFTER SYSTEM $ENV{INCLUDE})
    link_directories(AFTER SYSTEM $ENV{LIB})

    if(NOT DEFINED VCPKG_CRT_LINKAGE)
        block(PROPAGATE VCPKG_CRT_LINKAGE)
            include("${CMAKE_CURRENT_LIST_DIR}/../${VCPKG_TARGET_TRIPLET}.cmake")
            set(VCPKG_CRT_LINKAGE "${VCPKG_CRT_LINKAGE}" PARENT_SCOPE)
        endblock()
    endif()

    if(CMAKE_GENERATOR MATCHES "Visual Studio")
        set(CMAKE_GENERATOR_INSTANCE "$ENV{VSINSTALLDIR}")
    endif()

    set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>$<$<STREQUAL:${VCPKG_CRT_LINKAGE},dynamic>:DLL>" CACHE STRING "")
    set(CMAKE_MSVC_DEBUG_INFORMATION_FORMAT "")

    macro(toolchain_set_cmake_policy_new)
    if(POLICY ${ARGN})
        cmake_policy(SET ${ARGN} NEW)
    endif()
    endmacro()
    # Setup policies
    toolchain_set_cmake_policy_new(CMP0137)
    toolchain_set_cmake_policy_new(CMP0128)
    toolchain_set_cmake_policy_new(CMP0126)
    toolchain_set_cmake_policy_new(CMP0117)
    toolchain_set_cmake_policy_new(CMP0092)
    toolchain_set_cmake_policy_new(CMP0091)
    toolchain_set_cmake_policy_new(CMP0067)
    toolchain_set_cmake_policy_new(CMP0066)
    toolchain_set_cmake_policy_new(CMP0056)
    toolchain_set_cmake_policy_new(CMP0012)
    unset(toolchain_set_cmake_policy_new)  

    list(APPEND CMAKE_TRY_COMPILE_PLATFORM_VARIABLES
       VCPKG_CRT_LINKAGE VCPKG_TARGET_ARCHITECTURE VCPKG_SET_CHARSET_FLAG
       VCPKG_C_FLAGS VCPKG_CXX_FLAGS
       VCPKG_C_FLAGS_DEBUG VCPKG_CXX_FLAGS_DEBUG
       VCPKG_C_FLAGS_RELEASE VCPKG_CXX_FLAGS_RELEASE
       VCPKG_LINKER_FLAGS VCPKG_LINKER_FLAGS_RELEASE VCPKG_LINKER_FLAGS_DEBUG
       VCPKG_PLATFORM_TOOLSET
    )

    set(CMAKE_SYSTEM_NAME Windows CACHE STRING "")

    if(VCPKG_TARGET_ARCHITECTURE STREQUAL "x86")
        set(CMAKE_SYSTEM_PROCESSOR x86 CACHE STRING "")
    elseif(VCPKG_TARGET_ARCHITECTURE STREQUAL "x64")
        set(CMAKE_SYSTEM_PROCESSOR AMD64 CACHE STRING "")
    elseif(VCPKG_TARGET_ARCHITECTURE STREQUAL "arm")
        set(CMAKE_SYSTEM_PROCESSOR ARM CACHE STRING "")
    elseif(VCPKG_TARGET_ARCHITECTURE STREQUAL "arm64")
        set(CMAKE_SYSTEM_PROCESSOR ARM64 CACHE STRING "")
    endif()

    if(DEFINED VCPKG_CMAKE_SYSTEM_VERSION)
        set(CMAKE_SYSTEM_VERSION "${VCPKG_CMAKE_SYSTEM_VERSION}" CACHE STRING "" FORCE)
    endif()

    if(CMAKE_HOST_SYSTEM_NAME STREQUAL "Windows")
        if(CMAKE_SYSTEM_PROCESSOR STREQUAL CMAKE_HOST_SYSTEM_PROCESSOR)
            set(CMAKE_CROSSCOMPILING OFF CACHE STRING "")
        elseif(CMAKE_SYSTEM_PROCESSOR STREQUAL "x86")
            # any of the four platforms can run x86 binaries
            set(CMAKE_CROSSCOMPILING OFF CACHE STRING "")
        elseif(CMAKE_HOST_SYSTEM_PROCESSOR STREQUAL "ARM64")
            # arm64 can run binaries of any of the four platforms after Windows 11
            set(CMAKE_CROSSCOMPILING OFF CACHE STRING "")
        endif()

        if(NOT DEFINED CMAKE_SYSTEM_VERSION)
            set(CMAKE_SYSTEM_VERSION "${CMAKE_HOST_SYSTEM_VERSION}" CACHE STRING "")
        endif()
    endif()

    if(VCPKG_CRT_LINKAGE STREQUAL "dynamic")
        set(VCPKG_CRT_LINK_FLAG_PREFIX "/MD")
    elseif(VCPKG_CRT_LINKAGE STREQUAL "static")
        set(VCPKG_CRT_LINK_FLAG_PREFIX "/MT")
    else()
        message(FATAL_ERROR "Invalid setting for VCPKG_CRT_LINKAGE: \"${VCPKG_CRT_LINKAGE}\". It must be \"static\" or \"dynamic\"")
    endif()

    set(CHARSET_FLAG "/utf-8")
    if (NOT VCPKG_SET_CHARSET_FLAG OR VCPKG_PLATFORM_TOOLSET MATCHES "v120")
        # VS 2013 does not support /utf-8
        set(CHARSET_FLAG "")
    endif()

    set(MP_BUILD_FLAG "")
    if(NOT (CMAKE_CXX_COMPILER MATCHES "clang-cl.exe"))
        set(MP_BUILD_FLAG "/MP ")
    endif()

    set(CMAKE_CXX_FLAGS " /nologo /DWIN32 /D_WINDOWS ${CHARSET_FLAG} /GR /EHsc ${MP_BUILD_FLAG}${VCPKG_CXX_FLAGS}" CACHE STRING "")
    set(CMAKE_C_FLAGS " /nologo /DWIN32 /D_WINDOWS ${CHARSET_FLAG} ${MP_BUILD_FLAG}${VCPKG_C_FLAGS}" CACHE STRING "")

    if(VCPKG_TARGET_ARCHITECTURE STREQUAL "arm64ec")
        string(APPEND CMAKE_CXX_FLAGS " /arm64EC /D_AMD64_ /DAMD64 /D_ARM64EC_ /DARM64EC")
        string(APPEND CMAKE_C_FLAGS " /arm64EC /D_AMD64_ /DAMD64 /D_ARM64EC_ /DARM64EC")
    endif()
    set(CMAKE_RC_FLAGS "-c65001 /DWIN32" CACHE STRING "")

    set(CMAKE_CXX_FLAGS_DEBUG "/D_DEBUG ${VCPKG_CRT_LINK_FLAG_PREFIX}d /Z7 /Ob0 /Od /RTC1 ${VCPKG_CXX_FLAGS_DEBUG}" CACHE STRING "")
    set(CMAKE_C_FLAGS_DEBUG "/D_DEBUG ${VCPKG_CRT_LINK_FLAG_PREFIX}d /Z7 /Ob0 /Od /RTC1 ${VCPKG_C_FLAGS_DEBUG}" CACHE STRING "")
    set(CMAKE_CXX_FLAGS_RELEASE "${VCPKG_CRT_LINK_FLAG_PREFIX} /O2 /Oi /Gy /DNDEBUG /Z7 ${VCPKG_CXX_FLAGS_RELEASE}" CACHE STRING "")
    set(CMAKE_C_FLAGS_RELEASE "${VCPKG_CRT_LINK_FLAG_PREFIX} /O2 /Oi /Gy /DNDEBUG /Z7 ${VCPKG_C_FLAGS_RELEASE}" CACHE STRING "")

    string(APPEND CMAKE_STATIC_LINKER_FLAGS_RELEASE_INIT " /nologo ")
    set(CMAKE_MODULE_LINKER_FLAGS_RELEASE "/nologo /DEBUG /INCREMENTAL:NO /OPT:REF /OPT:ICF ${VCPKG_LINKER_FLAGS} ${VCPKG_LINKER_FLAGS_RELEASE}" CACHE STRING "")
    set(CMAKE_SHARED_LINKER_FLAGS_RELEASE "/nologo /DEBUG /INCREMENTAL:NO /OPT:REF /OPT:ICF ${VCPKG_LINKER_FLAGS} ${VCPKG_LINKER_FLAGS_RELEASE}" CACHE STRING "")
    set(CMAKE_EXE_LINKER_FLAGS_RELEASE "/nologo /DEBUG /INCREMENTAL:NO /OPT:REF /OPT:ICF ${VCPKG_LINKER_FLAGS} ${VCPKG_LINKER_FLAGS_RELEASE}" CACHE STRING "")

    string(APPEND CMAKE_STATIC_LINKER_FLAGS_DEBUG_INIT " /nologo ")
    string(APPEND CMAKE_MODULE_LINKER_FLAGS_DEBUG_INIT " /nologo ${VCPKG_LINKER_FLAGS} ${VCPKG_LINKER_FLAGS_DEBUG} ")
    string(APPEND CMAKE_SHARED_LINKER_FLAGS_DEBUG_INIT " /nologo ${VCPKG_LINKER_FLAGS} ${VCPKG_LINKER_FLAGS_DEBUG} ")
    string(APPEND CMAKE_EXE_LINKER_FLAGS_DEBUG_INIT " /nologo ${VCPKG_LINKER_FLAGS} ${VCPKG_LINKER_FLAGS_DEBUG} ")

    unset(CHARSET_FLAG)
    unset(MP_BUILD_FLAG)
    unset(VCPKG_CRT_LINK_FLAG_PREFIX)
endif()
