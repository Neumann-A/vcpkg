set(VCPKG_POLICY_EMPTY_INCLUDE_FOLDER enabled)
if(NOT X_VCPKG_FORCE_VCPKG_X_LIBRARIES AND NOT VCPKG_TARGET_IS_WINDOWS)
    message(STATUS "Utils and libraries provided by '${PORT}' should be provided by your system! Install the required packages or force vcpkg libraries by setting X_VCPKG_FORCE_VCPKG_X_LIBRARIES")
    set(VCPKG_POLICY_EMPTY_PACKAGE enabled)
else()

vcpkg_from_gitlab(
    GITLAB_URL https://gitlab.freedesktop.org/xorg
    OUT_SOURCE_PATH SOURCE_PATH
    REPO app/xkbcomp
    REF xkbcomp-${VERSION}
    SHA512  0
    HEAD_REF master # branch name
    PATCHES configure.patch 
            unistd.h.patch
            xkbscan.patch
            listing.patch#patch name
) 

set(ENV{ACLOCAL} "aclocal -I \"${CURRENT_INSTALLED_DIR}/share/xorg/aclocal/\"")

vcpkg_find_acquire_program(FLEX)
get_filename_component(FLEX_DIR "${FLEX}" DIRECTORY )
vcpkg_add_to_path(PREPEND "${FLEX_DIR}")
vcpkg_find_acquire_program(BISON)
get_filename_component(BISON_DIR "${BISON}" DIRECTORY )
vcpkg_add_to_path(PREPEND "${BISON_DIR}")

if(WIN32) # WIN32 HOST probably has win_flex and win_bison!
    if(NOT EXISTS "${FLEX_DIR}/flex${VCPKG_HOST_EXECUTABLE_SUFFIX}")
        file(CREATE_LINK "${FLEX}" "${FLEX_DIR}/flex${VCPKG_HOST_EXECUTABLE_SUFFIX}")
    endif()
    if(NOT EXISTS "${BISON_DIR}/BISON${VCPKG_HOST_EXECUTABLE_SUFFIX}")
        file(CREATE_LINK "${BISON}" "${BISON_DIR}/bison${VCPKG_HOST_EXECUTABLE_SUFFIX}")
    endif()
endif()

vcpkg_configure_make(
    SOURCE_PATH "${SOURCE_PATH}"
    AUTOCONFIG
    OPTIONS "--with-xkb-config-root=./../../../share/X11/xkb"   # tools/xkbcomp/bin to share/X11/xkb
)

vcpkg_install_make()
vcpkg_fixup_pkgconfig()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")

# Handle copyright
file(INSTALL "${SOURCE_PATH}/COPYING" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)

vcpkg_copy_tool_dependencies("${CURRENT_PACKAGES_DIR}/tools/${PORT}/bin")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/tools")
endif()
