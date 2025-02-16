
string(REPLACE "-rc1" "rc1" VERSION "${VERSION}")
vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO open-mpi/hwloc
    REF "hwloc-${VERSION}"
    SHA512 d30ce938fc399bef1d370e85e623ccf6a62202f4cff21844ac59e5e065d0812e6bb431d38e49f79dfecb85dc1a13d470d18b032630b81d2f680f6153e12c52cd
    PATCHES
        fix_shared_win_build.patch
        stdout_fileno.patch
)

if(VCPKG_TARGET_IS_WINDOWS AND NOT VCPKG_TARGET_IS_MINGW)
    set(OPTIONS ac_cv_prog_cc_c99= # To avoid the compiler check for C99 which will fail for MSVC
                --disable-plugin-dlopen)
endif()

if(VCPKG_LIBRARY_LINKAGE STREQUAL "dynamic")
    list(APPEND OPTIONS "HWLOC_LDFLAGS=-no-undefined")
elseif(VCPKG_TARGET_IS_OSX)
    list(APPEND OPTIONS "HWLOC_LDFLAGS=-framework CoreFoundation")
endif()

vcpkg_configure_make(
    SOURCE_PATH "${SOURCE_PATH}"
    AUTOCONFIG
    OPTIONS
        ${OPTIONS} 
        --disable-libxml2
        --disable-opencl
        --disable-cairo
        --disable-cuda
        --disable-libudev
        --disable-levelzero
        --disable-nvml
        --disable-rsmi
        --disable-pci
        #--disable-cpuid
        #--disable-picky
)

vcpkg_install_make()
vcpkg_fixup_pkgconfig()
vcpkg_copy_tool_dependencies("${CURRENT_PACKAGES_DIR}/tools/${PORT}/bin")

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

if(EXISTS "${CURRENT_PACKAGES_DIR}/tools/hwloc/bin/hwloc-compress-dir")
    vcpkg_replace_string("${CURRENT_PACKAGES_DIR}/tools/hwloc/bin/hwloc-compress-dir" "${CURRENT_INSTALLED_DIR}" "`dirname $0`/../../.." IGNORE_UNCHANGED)
endif()
if(EXISTS "${CURRENT_PACKAGES_DIR}/tools/hwloc/debug/bin/hwloc-compress-dir")
    vcpkg_replace_string("${CURRENT_PACKAGES_DIR}/tools/hwloc/debug/bin/hwloc-compress-dir" "${CURRENT_INSTALLED_DIR}" "`dirname $0`/../../../.." IGNORE_UNCHANGED)
endif()

if(EXISTS "${CURRENT_PACKAGES_DIR}/tools/hwloc/bin/hwloc-gather-topology")
    vcpkg_replace_string("${CURRENT_PACKAGES_DIR}/tools/hwloc/bin/hwloc-gather-topology" "${CURRENT_INSTALLED_DIR}" "`dirname $0`/../../..")
endif()
if(EXISTS "${CURRENT_PACKAGES_DIR}/tools/hwloc/debug/bin/hwloc-gather-topology")
    vcpkg_replace_string("${CURRENT_PACKAGES_DIR}/tools/hwloc/debug/bin/hwloc-gather-topology" "${CURRENT_INSTALLED_DIR}" "`dirname $0`/../../../..")
endif()

# Handle copyright
file(INSTALL "${SOURCE_PATH}/COPYING" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)

file(REMOVE "${CURRENT_PACKAGES_DIR}/debug/COPYING.txt"
            "${CURRENT_PACKAGES_DIR}/debug/README.txt"
            "${CURRENT_PACKAGES_DIR}/debug/NEWS.txt"
            "${CURRENT_PACKAGES_DIR}/COPYING.txt"
            "${CURRENT_PACKAGES_DIR}/README.txt"
            "${CURRENT_PACKAGES_DIR}/NEWS.txt"
    )
