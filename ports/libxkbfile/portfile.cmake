if(NOT X_VCPKG_FORCE_VCPKG_X_LIBRARIES AND NOT VCPKG_TARGET_IS_WINDOWS)
    message(STATUS "Utils and libraries provided by '${PORT}' should be provided by your system! Install the required packages or force vcpkg libraries by setting X_VCPKG_FORCE_VCPKG_X_LIBRARIES in your triplet!")
    set(VCPKG_POLICY_EMPTY_PACKAGE enabled)
else()

set(PATCHES "")
if(VCPKG_TARGET_IS_WINDOWS AND VCPKG_LIBRARY_LINKAGE STREQUAL dynamic)
    set(PATCHES symbol_visibility.patch)
    list(APPEND VCPKG_C_FLAGS " /DXKBFILE_BUILD")
    list(APPEND VCPKG_CXX_FLAGS " /DXKBFILE_BUILD")
endif()

vcpkg_from_gitlab(
    GITLAB_URL https://gitlab.freedesktop.org/xorg
    OUT_SOURCE_PATH SOURCE_PATH
    REPO lib/libxkbfile
    REF  libxkbfile-${VERSION}
    SHA512 e4b0fc6d9525669fe85cd8ebb096ce4a9355de00e7356dbe6c3cb194f6aa2449ef345811ce4934bb8c09edb94eee08227f7f20ee1df4a8a49697a3dc85cd704e
    HEAD_REF master
    PATCHES fix_u_char.patch 
            ${PATCHES}
) 

file(MAKE_DIRECTORY "${SOURCE_PATH}/m4")
set(ENV{ACLOCAL} "aclocal -I \"${CURRENT_INSTALLED_DIR}/share/xorg/aclocal/\"")

vcpkg_configure_make(
    SOURCE_PATH "${SOURCE_PATH}"
    AUTOCONFIG
)

vcpkg_install_make()
vcpkg_fixup_pkgconfig()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")

# Handle copyright
file(MAKE_DIRECTORY "${CURRENT_PACKAGES_DIR}/share/${PORT}/")
file(INSTALL "${SOURCE_PATH}/COPYING" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}/" RENAME copyright)
endif()

