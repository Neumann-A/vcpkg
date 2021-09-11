function(qt_get_submodule_name OUT_NAME)
    string(REPLACE "5-" "" _tmp_name ${PORT})
    set(${OUT_NAME} ${_tmp_name} PARENT_SCOPE)
endfunction()

function(qt_download_submodule)
    cmake_parse_arguments(_csc "GIT_INIT_SUBMODULE" "OUT_SOURCE_PATH" "PATCHES;BUILD_OPTIONS;BUILD_OPTIONS_RELEASE;BUILD_OPTIONS_DEBUG" ${ARGN})
    
    if(NOT DEFINED _csc_OUT_SOURCE_PATH)
        message(FATAL_ERROR "qt_download_module requires parameter OUT_SOURCE_PATH to be set! Please correct the portfile!")
    endif()
    
    vcpkg_buildpath_length_warning(37)
    qt_get_submodule_name(NAME)

    set(ENV{SYNCQT} true)
    vcpkg_from_gitlab(
        GITLAB_URL https://invent.kde.org/qt
        OUT_SOURCE_PATH SOURCE_PATH
        REPO qt/${NAME}
        REF ${QT_REF_${PORT}}
        SHA512 ${QT_HASH_${PORT}}
        HEAD_REF kde/5.12 # branch name
        PATCHES ${_csc_PATCHES} #patch name
    )

    if(QT_UPDATE_VERSION)
        # Add Code to Update the HASHES?
        #file(SHA512 "${ARCHIVE_FILE}" ARCHIVE_HASH)
        #message(STATUS "${PORT} new hash is ${ARCHIVE_HASH}")
        #file(APPEND "${VCPKG_ROOT_DIR}/ports/qt5-base/cmake/qt_new_hashes.cmake" "set(QT_HASH_${PORT} ${ARCHIVE_HASH})\n")
    endif()

    vcpkg_find_acquire_program(PERL)
    set(SYNCQT_PATH "${CURRENT_INSTALLED_DIR}/tools/qt5/bin")
    if(PORT STREQUAL "qt5-base")
        set(SYNCQT_PATH "${SOURCE_PATH}/bin")
    endif()
    vcpkg_execute_required_process(
        COMMAND "${PERL}" "${SYNCQT_PATH}/syncqt.pl" -version ${QT_MAJOR_MINOR_VER}.${QT_PATCH_VER} -outdir ${SOURCE_PATH} -v
        WORKING_DIRECTORY ${SOURCE_PATH}
        LOGNAME syncqt-${_build_triplet}
    )
    if(_csc_GIT_INIT_SUBMODULE)
        vcpkg_find_acquire_program(GIT)
        vcpkg_execute_required_process(
        COMMAND "${GIT}" submodule update --init
        WORKING_DIRECTORY ${SOURCE_PATH}
        LOGNAME sumbodule-init-${_build_triplet}
        )
    endif()
    set(${_csc_OUT_SOURCE_PATH} ${SOURCE_PATH} PARENT_SCOPE)
endfunction()