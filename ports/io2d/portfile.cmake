vcpkg_check_linkage(ONLY_STATIC_LIBRARY)

# This port is simply broken. 
# It uses raw find_library calls for most of its dependencies which in most cases will not find the correct library for debug builds

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO cpp-io2d/P0267_RefImpl
    REF caa0ba0cb5a421a38bc26afaf3505bee206c44dd
    SHA512 f8e5a708f6cbda913a0492a843e1502b8d3cc615a6abda50e850be944e1484ec9087b787c54cc25d513172a7d5ab789be41a761c97df94266df4d1bcf14db17c
    HEAD_REF master
    PATCHES
        cmake.dep.patch
)

if (VCPKG_TARGET_IS_OSX)
    set(IO2D_DEFAULT_OPTION "-DIO2D_DEFAULT=COREGRAPHICS_MAC")
endif()
vcpkg_find_acquire_program(PKGCONFIG)
vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS
        -DIO2D_WITHOUT_SAMPLES=1
        -DIO2D_WITHOUT_TESTS=1
        -DCMAKE_INSTALL_INCLUDEDIR:STRING=include
        ${IO2D_DEFAULT_OPTION}
        #"-DPKG_CONFIG_EXECUTABLE=${PKGCONFIG}"
)

vcpkg_install_cmake()

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)

vcpkg_fixup_cmake_targets(CONFIG_PATH lib/cmake/io2d)

# There probably nees to be more fixed in the config.... Would be better if this port would be using targets for ext. deps. 
file(RENAME ${CURRENT_PACKAGES_DIR}/share/io2d/io2dConfig.cmake ${CURRENT_PACKAGES_DIR}/share/io2d/io2dTargets.cmake)
file(WRITE ${CURRENT_PACKAGES_DIR}/share/io2d/io2dConfig.cmake "
include(CMakeFindDependencyMacro)
find_dependency(unofficial-cairo CONFIG)
find_dependency(unofficial-graphicsmagick CONFIG)

include(\${CMAKE_CURRENT_LIST_DIR}/io2dTargets.cmake)
")


file(INSTALL ${SOURCE_PATH}/LICENSE.md DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)