include(vcpkg_common_functions)

set(VCPKG_POLICY_EMPTY_PACKAGE enabled)

if(NOT VCPKG_TARGET_ARCHITECTURE STREQUAL "x64" AND NOT VCPKG_TARGET_ARCHITECTURE STREQUAL "x86")
    return()
elseif(CMAKE_HOST_WIN32 AND VCPKG_CMAKE_SYSTEM_NAME AND NOT VCPKG_CMAKE_SYSTEM_NAME STREQUAL "WindowsStore")
    return()
endif()

set(BOOST_VERSION 1.73.0)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/build
    REF boost-${BOOST_VERSION}
    SHA512 68e132c480c3063f99ddae48177ff5a35369e49e7f497d51d758a9bf760c5b20c1c040cb212fad94b1f27fb140054b0ef14ac0b32c6d7d246e921787ff58a037
    HEAD_REF master
)

vcpkg_download_distfile(LICENSE
    URLS "https://raw.githubusercontent.com/boostorg/boost/boost-${BOOST_VERSION}/LICENSE_1_0.txt"
    FILENAME "boost_LICENSE_1_0.txt"
    SHA512 d6078467835dba8932314c1c1e945569a64b065474d7aced27c9a7acc391d52e9f234138ed9f1aa9cd576f25f12f557e0b733c14891d42c16ecdc4a7bd4d60b8
)

vcpkg_download_distfile(BOOSTCPP_ARCHIVE
    URLS "https://raw.githubusercontent.com/boostorg/boost/boost-${BOOST_VERSION}/boostcpp.jam"
    FILENAME "boost-${BOOST_VERSION}-boostcpp.jam"
    SHA512 8cf929fa4a602342c859a6bbd5f9dda783ac29431d951bcf6cae4cb14377c1b3aed90bacd902b0f7d1807591cf5e1a244cf8fc3c6cc6e0a4056db145b58f51df
)

file(INSTALL ${LICENSE} DESTINATION "${CURRENT_PACKAGES_DIR}/share/boost-build" RENAME copyright)
file(INSTALL ${BOOSTCPP_ARCHIVE} DESTINATION "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}" RENAME boostcpp.jam)
file(INSTALL ${BOOSTCPP_ARCHIVE} DESTINATION "${CURRENT_PACKAGES_DIR}/tools/${PORT}" RENAME boostcpp.jam)
# This fixes the lib path to use desktop libs instead of uwp -- TODO: improve this with better "host" compilation
string(REPLACE "\\store\\;" "\\;" LIB "$ENV{LIB}")
set(ENV{LIB} "${LIB}")

file(COPY
    ${SOURCE_PATH}/
    DESTINATION ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}
)

file(READ "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}/src/tools/msvc.jam" _contents)
string(REPLACE " /ZW /EHsc " "" _contents "${_contents}")
string(REPLACE "-nologo" "" _contents "${_contents}")
string(REPLACE "/nologo" "" _contents "${_contents}")
string(REPLACE "/Zm800" "" _contents "${_contents}")
string(REPLACE "<define>_WIN32_WINNT=0x0602" "" _contents "${_contents}")
file(WRITE "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}/src/tools/msvc.jam" "${_contents}")

message(STATUS "Bootstrapping...")
if(CMAKE_HOST_WIN32)
    vcpkg_execute_required_process(
        COMMAND "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}/bootstrap.bat" msvc
        WORKING_DIRECTORY "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}"
        LOGNAME bootstrap-${TARGET_TRIPLET}
    )
    if(NOT VCPKG_BOOST_TOOLSET)
        set(VCPKG_BOOST_TOOLSET msvc)
    endif()
else()
    vcpkg_execute_required_process(
        COMMAND "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}/bootstrap.sh"
        WORKING_DIRECTORY "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}"
        LOGNAME bootstrap-${TARGET_TRIPLET}
    )    
    if(NOT VCPKG_BOOST_TOOLSET)
        if(VCPKG_TARGET_IS_OSX)
            set(VCPKG_BOOST_TOOLSET darwin)
        else()
            set(VCPKG_BOOST_TOOLSET gcc)
        endif()
    endif()
endif()

#vcpkg_find_acquire_program(BISON)
#get_filename_component(BISON_DIR "${BISON}" DIRECTORY)
#vcpkg_add_to_path("${BISON_DIR}")

file(TO_NATIVE_PATH "${CURRENT_PACKAGES_DIR}" INSTALL_PREFIX_PATH )
file(TO_NATIVE_PATH "${CURRENT_PACKAGES_DIR}/tools/${PORT}" INSTALL_TOOLS_PATH )
vcpkg_execute_required_process(
    COMMAND "./b2;install;--prefix=${INSTALL_PREFIX_PATH};--bindir=${INSTALL_TOOLS_PATH};toolset=${VCPKG_BOOST_TOOLSET}"
    WORKING_DIRECTORY "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}"
    LOGNAME install-${TARGET_TRIPLET}
)
file(READ "${CURRENT_PACKAGES_DIR}/share/boost-build/boost-build.jam" _contents)
string(REPLACE "boost-build src/kernel ;" "boost-build ../../share/boost-build/src/kernel ;" _contents1 "${_contents}")
string(REPLACE "boost-build src/kernel ;" "boost-build \"\@CURRENT_INSTALLED_DIR@/share/boost-build/src/kernel\" ;" _contents2 "${_contents}")
file(WRITE "${CURRENT_PACKAGES_DIR}/tools/${PORT}/boost-build.jam" "${_contents1}")
file(WRITE "${CURRENT_PACKAGES_DIR}/share/${PORT}/boost-build.jam.in" "${_contents2}")
#b2 correctly installed get boost-install scripts

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_BOOST_INSTALL
    REPO boostorg/boost_install
    REF boost-${BOOST_VERSION}
    SHA512 11f3f54fca305563f965be38d36f5d72417a4d5011fba01134b768006f0ff3d458d952a72ce8faff159c6209c977fc1ecdb05157a2d0c6020748db379970b8de
    HEAD_REF master
)
#set(CURRENT_INSTALLED_DIR_BACKUP "${CURRENT_INSTALLED_DIR}")
#set(CURRENT_INSTALLED_DIR "${CURRENT_PACKAGES_DIR}")
#configure_file("${CURRENT_PACKAGES_DIR}/tools/${PORT}/boost-build.jam.in" "${SOURCE_BOOST_INSTALL}/boost-build.jam")
#set(CURRENT_INSTALLED_DIR "${CURRENT_INSTALLED_DIR_BACKUP}")

file(COPY
    ${SOURCE_BOOST_INSTALL}/
    DESTINATION ${CURRENT_PACKAGES_DIR}/share/boost_install/
)

file(MAKE_DIRECTORY "${CURRENT_PACKAGES_DIR}/share/boost/")
#Install CMake files
file(RENAME "${CURRENT_PACKAGES_DIR}/share/boost_install/BoostConfig.cmake" "${CURRENT_PACKAGES_DIR}/share/boost/BoostConfig.cmake")
file(RENAME "${CURRENT_PACKAGES_DIR}/share/boost_install/BoostDetectToolset.cmake" "${CURRENT_PACKAGES_DIR}/share/boost/BoostDetectToolset.cmake")
file(RENAME "${CURRENT_PACKAGES_DIR}/share/boost_install/test/BoostVersion.cmake" "${CURRENT_PACKAGES_DIR}/share/boost/BoostVersion.cmake")


file(
    COPY
        "${CMAKE_CURRENT_LIST_DIR}/modular/boost-modular-build.cmake"
        "${CMAKE_CURRENT_LIST_DIR}/modular/Jamfile.headers.in"
        "${CMAKE_CURRENT_LIST_DIR}/modular/Jamroot.jam.in"
        "${CMAKE_CURRENT_LIST_DIR}/modular/user-config.jam.in"
        "${CMAKE_CURRENT_LIST_DIR}/modular/nothing.bat"
        "${CMAKE_CURRENT_LIST_DIR}/modular/CMakeLists.txt"
    DESTINATION
        "${CURRENT_PACKAGES_DIR}/share/boost-build"
)


vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_BOOST_HEADERS
    REPO boostorg/headers
    REF boost-${BOOST_VERSION}
    SHA512 7f60cd03dc147b950103095f4ba150343813b61a94076a09c08ab22607d6da897cb643aba0ad3918c0b79f7c10dd63ccf145e6fde29f441836f22af531b501a4
    HEAD_REF master
)

file(COPY
    ${SOURCE_BOOST_HEADERS}/
    DESTINATION ${CURRENT_PACKAGES_DIR}/share/boost_build_headers/
)

# vcpkg_execute_required_process(
    # COMMAND "${CURRENT_PACKAGES_DIR}/tools/${PORT}/b2;--prefix=${INSTALL_PREFIX_PATH};toolset=${VCPKG_BOOST_TOOLSET}"
    # WORKING_DIRECTORY "${SOURCE_BOOST_INSTALL}"
    # LOGNAME install-boost_install-${TARGET_TRIPLET}
# )

#--build-dir
#--exec-prefix