vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO root-project/root
    REF 55e26c43341d2175e9703311bef455f3bcf6bf44
    SHA512 e56026de02bdca275933e0dd2131e2d527224c1956cdf1afb0b6d12090e5e90e7e2c3277040f388417b7becc58d4a659540271fe168d864a7f568ed6278164f7
    HEAD_REF master
    PATCHES
        fix_find_package.patch
)
vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DVCPKG_HOST_TRIPLET=${_HOST_TRIPLET}
)

vcpkg_cmake_install()
vcpkg_cmake_config_fixup()
vcpkg_fixup_pkgconfig()

file(REMOVE_RECURSE
        "${CURRENT_PACKAGES_DIR}/debug/include"
        "${CURRENT_PACKAGES_DIR}/debug/share")

vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LGPL2_1.txt")