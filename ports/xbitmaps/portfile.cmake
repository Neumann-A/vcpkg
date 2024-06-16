vcpkg_from_gitlab(
    GITLAB_URL https://gitlab.freedesktop.org/xorg
    OUT_SOURCE_PATH SOURCE_PATH
    REPO data/bitmaps
    REF  xbitmaps-${VERSION}
    SHA512 0
    HEAD_REF master
)

set(ENV{ACLOCAL} "aclocal -I \"${CURRENT_INSTALLED_DIR}/share/xorg/aclocal/\"")

vcpkg_configure_make(
    SOURCE_PATH "${SOURCE_PATH}"
    AUTOCONFIG
)
vcpkg_install_make()
file(MAKE_DIRECTORY "${CURRENT_PACKAGES_DIR}/share/pkgconfig/")
file(RENAME "${CURRENT_PACKAGES_DIR}/share/${PORT}/pkgconfig/xbitmaps.pc" "${CURRENT_PACKAGES_DIR}/share/pkgconfig/xbitmaps.pc")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/share/${PORT}/pkgconfig/")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug")
vcpkg_fixup_pkgconfig()

file(INSTALL "${SOURCE_PATH}/COPYING" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
file(TOUCH "${CURRENT_PACKAGES_DIR}/share/${PORT}/usage")
