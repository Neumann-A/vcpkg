vcpkg_check_linkage(ONLY_STATIC_LIBRARY)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO apache/zookeeper
    REF 5a02a05eddb59aee6ac762f7ea82e92a68eb9c0f
    SHA512 309e78e1c7f10a487a8152e14e83fb1e7dfe875480c8740f04dd26d8a76d1d4826cc150b4f47e8d5a314627642df8a33cdfa7ff07c007a517650ed0459c94eac
    HEAD_REF master
    PATCHES
        #cmake.patch
        #win32.patch
)

vcpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        sync WANT_SYNCAPI
)

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}/zookeeper-client/zookeeper-client-c"
    DISABLE_PARALLEL_CONFIGURE
    OPTIONS
        -DWANT_CPPUNIT=OFF
        ${FEATURE_OPTIONS}
)

vcpkg_cmake_install()

vcpkg_cmake_config_fixup()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

file(INSTALL "${SOURCE_PATH}/zookeeper-client/zookeeper-client-c/LICENSE" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)

vcpkg_copy_pdbs()
