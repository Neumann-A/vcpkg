set(VCPKG_POLICY_EMPTY_INCLUDE_FOLDER enabled)

if(NOT X_VCPKG_FORCE_VCPKG_X_LIBRARIES AND NOT VCPKG_TARGET_IS_WINDOWS)
    message(STATUS "Utils and libraries provided by '${PORT}' should be provided by your system! Install the required packages or force vcpkg libraries by setting X_VCPKG_FORCE_VCPKG_X_LIBRARIES in your triplet")
    set(VCPKG_POLICY_EMPTY_PACKAGE enabled)
else()

if(VCPKG_TARGET_IS_WINDOWS AND NOT VCPKG_TARGET_IS_MINGW)
    set(PATCHES skip_rawcpp.patch)
endif()

vcpkg_from_gitlab(
    GITLAB_URL https://gitlab.freedesktop.org/xorg
    OUT_SOURCE_PATH SOURCE_PATH
    REPO util/macros
    REF   util-macros-${VERSION}
    SHA512 893fa42862e518cfbc0ac71d1f2e7900027c20b66368ee9a0c0d7f6770afeeeab9fa8eda4d32b7a0d858e7b8a22de049ac5d409c7abf0f4f6ccca58d4455e0ea
    HEAD_REF master
    PATCHES ${PATCHES}
) 

vcpkg_configure_make(
    AUTOCONFIG
    SOURCE_PATH "${SOURCE_PATH}"
)
vcpkg_install_make()

file(MAKE_DIRECTORY "${CURRENT_PACKAGES_DIR}/share/xorg/")
if(NOT WIN32)
    file(MAKE_DIRECTORY "${CURRENT_PACKAGES_DIR}/share/xorg/aclocal/")
endif()

file(RENAME "${CURRENT_PACKAGES_DIR}/share/${PORT}/aclocal/" "${CURRENT_PACKAGES_DIR}/share/xorg/aclocal")
file(RENAME "${CURRENT_PACKAGES_DIR}/share/${PORT}/util-macros/" "${CURRENT_PACKAGES_DIR}/share/xorg/util-macros")

file(READ "${CURRENT_PACKAGES_DIR}/share/${PORT}/pkgconfig/xorg-macros.pc" _contents)
string(REPLACE "${CURRENT_PACKAGES_DIR}" "${CURRENT_INSTALLED_DIR}" _contents "${_contents}")
string(REPLACE "datarootdir=\${prefix}/share" "datarootdir=\${prefix}/share/xorg" _contents "${_contents}")
string(REPLACE "includedir=${CURRENT_INSTALLED_DIR}/include" "includedir=\${prefix}/include" _contents "${_contents}")
file(WRITE "${CURRENT_PACKAGES_DIR}/share/pkgconfig/xorg-macros.pc" "${_contents}")
file(MAKE_DIRECTORY "${CURRENT_PACKAGES_DIR}/lib/")
file(RENAME "${CURRENT_PACKAGES_DIR}/share/pkgconfig/" "${CURRENT_PACKAGES_DIR}/lib/pkgconfig")
file(REMOVE "${CURRENT_PACKAGES_DIR}/share/${PORT}/pkgconfig/xorg-macros.pc")

if(EXISTS "${CURRENT_PACKAGES_DIR}/debug/share/${PORT}/pkgconfig/xorg-macros.pc")
    file(READ "${CURRENT_PACKAGES_DIR}/debug/share/${PORT}/pkgconfig/xorg-macros.pc" _contents)
    string(REPLACE "${CURRENT_PACKAGES_DIR}/debug" "${CURRENT_INSTALLED_DIR}/debug" _contents "${_contents}")
    string(REPLACE "datarootdir=\${prefix}/share}" "datarootdir=\${prefix}/share/xorg/debug}" _contents "${_contents}")
    string(REPLACE "includedir=${CURRENT_INSTALLED_DIR}/debug/include" "includedir=\${prefix}/../include" _contents "${_contents}")
    file(WRITE "${CURRENT_PACKAGES_DIR}/debug/share/pkgconfig/xorg-macros.pc" "${_contents}")
    if(NOT WIN32)
        file(MAKE_DIRECTORY "${CURRENT_PACKAGES_DIR}/share/xorg/debug/")
    endif()
    file(MAKE_DIRECTORY "${CURRENT_PACKAGES_DIR}/debug/lib")
    file(RENAME  "${CURRENT_PACKAGES_DIR}/debug/share/pkgconfig/" "${CURRENT_PACKAGES_DIR}/debug/lib/pkgconfig")
    file(REMOVE "${CURRENT_PACKAGES_DIR}/debug/share/${PORT}/pkgconfig/xorg-macros.pc")
    file(RENAME  "${CURRENT_PACKAGES_DIR}/debug/share/" "${CURRENT_PACKAGES_DIR}/share/xorg/debug/")
endif()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share/")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share/${PORT}/pkgconfig")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/share/xorg/debug/${PORT}/pkgconfig" "${CURRENT_PACKAGES_DIR}/share/${PORT}/pkgconfig")
vcpkg_fixup_pkgconfig()

# Handle copyright
file(INSTALL "${SOURCE_PATH}/COPYING" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
endif()
