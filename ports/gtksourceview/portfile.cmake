vcpkg_from_gitlab(
    GITLAB_URL https://gitlab.gnome.org/
    OUT_SOURCE_PATH SOURCE_PATH
    REPO GNOME/gtksourceview
    REF  1443ab336e093d88a184ee97c23e13d64b0ed369 #v5.0.0
    SHA512 cd0ae606bde068e86eb54fc67e18c3247bdc9f48f05f2139e3b01f6ff420ea6096d18f001c3938c5de4b1f27b93870ee0bd0711a5520134fd9c117997083abe8
    HEAD_REF master # branch name
) 

vcpkg_configure_meson(
    SOURCE_PATH ${SOURCE_PATH}
    OPTIONS
        -Dinstall_tests=false
        -Dintrospection=disabled
        -Dvapi=false
        -Dgtk_doc=false
        -Dsysprof=false
    ADDITIONAL_NATIVE_BINARIES glib-genmarshal='${CURRENT_HOST_INSTALLED_DIR}/tools/glib/glib-genmarshal'
                               glib-mkenums='${CURRENT_HOST_INSTALLED_DIR}/tools/glib/glib-mkenums'
                               glib-compile-resources='${CURRENT_HOST_INSTALLED_DIR}/tools/glib/glib-compile-resources${VCPKG_HOST_EXECUTABLE_SUFFIX}'
                               gtk4-update-icon-cache='${CURRENT_HOST_INSTALLED_DIR}/tools/gtk/gtk4-update-icon-cache${VCPKG_HOST_EXECUTABLE_SUFFIX}'
                               #gdbus-codegen='${CURRENT_HOST_INSTALLED_DIR}/tools/glib/gdbus-codegen'
                               #glib-compile-schemas='${CURRENT_HOST_INSTALLED_DIR}/tools/glib/glib-compile-schemas${VCPKG_HOST_EXECUTABLE_SUFFIX}'
                               #sassc='${CURRENT_INSTALLED_DIR}/tools/sassc/bin/sassc${VCPKG_HOST_EXECUTABLE_SUFFIX}'
    ADDITIONAL_CROSS_BINARIES  glib-genmarshal='${CURRENT_HOST_INSTALLED_DIR}/tools/glib/glib-genmarshal'
                               glib-mkenums='${CURRENT_HOST_INSTALLED_DIR}/tools/glib/glib-mkenums'
                               glib-compile-resources='${CURRENT_HOST_INSTALLED_DIR}/tools/glib/glib-compile-resources${VCPKG_HOST_EXECUTABLE_SUFFIX}'
                               gtk4-update-icon-cache='${CURRENT_HOST_INSTALLED_DIR}/tools/gtk/gtk4-update-icon-cache${VCPKG_HOST_EXECUTABLE_SUFFIX}'
                               #gdbus-codegen='${CURRENT_HOST_INSTALLED_DIR}/tools/glib/gdbus-codegen'
                               #glib-compile-schemas='${CURRENT_HOST_INSTALLED_DIR}/tools/glib/glib-compile-schemas${VCPKG_HOST_EXECUTABLE_SUFFIX}'
                               #sassc='${CURRENT_INSTALLED_DIR}/tools/sassc/bin/sassc${VCPKG_HOST_EXECUTABLE_SUFFIX}'
)

vcpkg_install_meson()
vcpkg_copy_pdbs()
vcpkg_fixup_pkgconfig()

file(INSTALL ${SOURCE_PATH}/COPYING DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)

#set install_test=true for this to be installed. Rest of the test gets installed into libexec
#set(TOOL_NAMES gtksourceview5-widget)
#vcpkg_copy_tools(TOOL_NAMES ${TOOL_NAMES} AUTO_CLEAN)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")

#if(VCPKG_LIBRARY_LINKAGE STREQUAL "static")
#    file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/bin" "${CURRENT_PACKAGES_DIR}/debug/bin")
#endif()
