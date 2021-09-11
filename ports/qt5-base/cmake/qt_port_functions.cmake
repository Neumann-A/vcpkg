list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}")

#Basic setup
include(qt_port_hashes)
if(QT_BUILD_LATEST) # only set in qt5-base
    include(qt_port_hashes_latest)
elseif(NOT PORT STREQUAL "qt5-base")
    include(qt_port_hashes_latest OPTIONAL) # will only be available for the other qt ports if qt5-base was build with latest
endif()
#Fixup scripts
include(qt_fix_makefile_install)
include(qt_fix_cmake)
include(qt_fix_prl)
#Helper functions
if(QT_IS_LATEST OR QT_BUILD_LATEST)
    include(qt_download_submodule-latest)
else()
    include(qt_download_submodule)
endif()
include(qt_build_submodule)
include(qt_install_copyright)

include(qt_submodule_installation)
