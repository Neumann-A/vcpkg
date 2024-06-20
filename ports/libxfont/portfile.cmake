if(NOT X_VCPKG_FORCE_VCPKG_X_LIBRARIES AND NOT VCPKG_TARGET_IS_WINDOWS)
    message(STATUS "Utils and libraries provided by '${PORT}' should be provided by your system! Install the required packages or force vcpkg libraries by setting X_VCPKG_FORCE_VCPKG_X_LIBRARIES in your triplet!")
    set(VCPKG_POLICY_EMPTY_PACKAGE enabled)
else()

vcpkg_from_gitlab(
    GITLAB_URL https://gitlab.freedesktop.org/xorg
    OUT_SOURCE_PATH SOURCE_PATH
    REPO lib/libxfont
    REF libXfont2-${VERSION}
    SHA512  6416ee84ea1de10ee6c22644d811a1079d3690b07414b090806f2c79069032d33452ca1a772edf3889d09a73c8efe743ddd7124b9513636217e377b33a1c47fc
    HEAD_REF master
    PATCHES build.patch
            build2.patch
            #configure.patch
) 

set(ENV{ACLOCAL} "aclocal -I \"${CURRENT_INSTALLED_DIR}/share/xorg/aclocal/\"")
if(VCPKG_TARGET_IS_WINDOWS)
    string(APPEND VCPKG_CXX_FLAGS " /D_WILLWINSOCK_") # /showIncludes are not passed on so I cannot figure out which header is responsible for this
    string(APPEND VCPKG_C_FLAGS " /D_WILLWINSOCK_")
endif()
vcpkg_configure_make(
    SOURCE_PATH "${SOURCE_PATH}"
    AUTOCONFIG
    OPTIONS ${OPTIONS}
      --with-bzip2=yes
    OPTIONS_DEBUG ${DEPS_DEBUG}
    OPTIONS_RELEASE ${DEPS_RELEASE}
)

vcpkg_install_make()
if(VCPKG_TARGET_IS_WINDOWS)
    set(_file "${CURRENT_PACKAGES_DIR}/lib/pkgconfig/xfont2.pc")
    file(READ "${_file}" _contents)
    string(REPLACE "-lm" "" _contents "${_contents}")
    file(WRITE "${_file}" "${_contents}")
    set(_file "${CURRENT_PACKAGES_DIR}/debug/lib/pkgconfig/xfont2.pc")
    file(READ "${_file}" _contents)
    string(REPLACE "-lm" "" _contents "${_contents}")
    file(WRITE "${_file}" "${_contents}")
endif()
vcpkg_fixup_pkgconfig()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")

# Handle copyright
file(INSTALL "${SOURCE_PATH}/COPYING" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
endif()
