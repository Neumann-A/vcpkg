set(GNUTLS_BRANCH 3.7)
set(GNUTLS_VERSION ${GNUTLS_BRANCH}.3)
set(GNUTLS_HASH 3ace744affe23e284342658d6d2d2de49dd50065489cbc8be18fc7d38187253e5268ca54027ce5cd517056c249ac039a7481e4548cec04325de37ae85617d077)

vcpkg_download_distfile(ARCHIVE
    URLS "https://www.gnupg.org/ftp/gcrypt/gnutls/v${GNUTLS_BRANCH}/gnutls-${GNUTLS_VERSION}.tar.xz"
    FILENAME "gnutls-${GNUTLS_VERSION}.tar.xz"
    SHA512 ${GNUTLS_HASH}
)

vcpkg_extract_source_archive_ex(
    OUT_SOURCE_PATH SOURCE_PATH
    ARCHIVE "${ARCHIVE}"
    REF ${GNUTLS_VERSION}
)

if(VCPKG_TARGET_IS_OSX)
    set(LDFLAGS "-framework CoreFoundation")
else()
    set(LDFLAGS "")
endif()

if ("openssl" IN_LIST FEATURES)
  set(OPENSSL_COMPATIBILITY "--enable-openssl-compatibility")
endif()

#set(ENV{AUTOPOINT} "true")
set(ENV{AUTOPOINT} "${CURRENT_HOST_INSTALLED_DIR}/tools/gettext/bin/autopoint")
set(ENV{GTKDOCIZE} "true")

vcpkg_configure_make(
    SOURCE_PATH "${SOURCE_PATH}"
    #USE_WRAPPERS
    AUTOCONFIG
    OPTIONS
        --disable-doc
        --disable-silent-rules
        --disable-tests
        --disable-maintainer-mode
        --disable-rpath
        --disable-libdane
        --with-included-unistring
        --without-p11-kit
        --without-tpm
        #ac_cv_header_sys_param_h=yes # Required
        ${OPENSSL_COMPATIBILITY}
        "LDFLAGS=${LDFLAGS}"
    ADDITIONAL_MSYS_PACKAGES perl gettext
)

vcpkg_install_make()
vcpkg_fixup_pkgconfig()
vcpkg_copy_pdbs()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")
file(INSTALL "${SOURCE_PATH}/LICENSE" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
