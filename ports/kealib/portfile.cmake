include(vcpkg_common_functions)
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/kealib-1.4.9)
vcpkg_download_distfile(ARCHIVE
    URLS "https://bitbucket.org/chchrsc/kealib/downloads/kealib-1.4.9.tar.gz"
    FILENAME "kealib-1.4.9.tar.gz"
    SHA512 85e5cae3daf3fbee100d437a4de71f98e1d15a93e6e316952948888cbc6047265e167725a6e170ba1fd919c02b7da4189a7c418faeefcdb0c802e1fbd9628276
)
vcpkg_extract_source_archive(${ARCHIVE})

vcpkg_apply_patches(
    SOURCE_PATH ${SOURCE_PATH}
    PATCHES
        hdf5_include.patch
)

if ("parallel" IN_LIST FEATURES)
    set(ENABLE_PARALLEL ON)
else()
    set(ENABLE_PARALLEL OFF)
endif()

if(${VCPKG_LIBRARY_LINKAGE} MATCHES "static")
    set(HDF5_USE_STATIC_LIBRARIES ON)
endif()

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS
      -DHDF5_PREFER_PARALLEL=${ENABLE_PARALLEL}
      -DLIBKEA_WITH_GDAL=OFF
      -DDISABLE_TESTS=ON
      -DHDF5_USE_STATIC_LIBRARIES=${HDF5_USE_STATIC_LIBRARIES}
)

vcpkg_install_cmake()
vcpkg_copy_pdbs()

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(INSTALL ${SOURCE_PATH}/python/LICENSE.txt DESTINATION ${CURRENT_PACKAGES_DIR}/share/kealib RENAME copyright)

if(VCPKG_LIBRARY_LINKAGE STREQUAL "static")
    file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/bin ${CURRENT_PACKAGES_DIR}/bin)
endif()