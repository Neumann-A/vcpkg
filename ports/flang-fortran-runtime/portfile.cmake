vcpkg_check_linkage(ONLY_STATIC_LIBRARY) # unresolved symbol interr


vcpkg_download_distfile(
    FLANG_LLVM_ARCHIVE
    URLS https://github.com/flang-compiler/classic-flang-llvm-project/archive/refs/heads/release_13x.zip
    FILENAME flang-llvm-13x.zip
    SHA512 dc1cf27e77c02f24bba09dee6af71f4ee0037df68ebd1307550244aee58d200bb6b74bf90d9266abca7780be4c2266e35c5b7bf48c36cf09f7619118d77f8132
)

vcpkg_extract_source_archive_ex(
    OUT_SOURCE_PATH SOURCE_LLVM
    ARCHIVE ${FLANG_LLVM_ARCHIVE}
)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO  flang-compiler/flang
    REF 59c43c4d99ade23d103aaf5299016a1666ceb2e1
    SHA512 467c3a977d5a207a0115ece5db070c9b49c1b57595155d477d25fe0b49453facbc90566b6e5ae7a48038b59bda7481b4ed6cd969628f3019076864be74a3d6a3
    PATCHES awk.patch
            1163.diff
            1165.diff
            1166.diff
            1168.diff
            1177.diff
            1178.diff
            1210.diff
            move_flang2.patch
            cross.patch
            sep_runtime_from_compiler.patch
)

set(NINJA "${CURRENT_HOST_INSTALLED_DIR}/tools/ninja/ninja${VCPKG_HOST_EXECUTABLE_SUFFIX}")
vcpkg_find_acquire_program(PYTHON3)
get_filename_component(PYTHON3_DIR "${PYTHON3}" DIRECTORY)
vcpkg_add_to_path(${PYTHON3_DIR})

if(VCPKG_TARGET_IS_WINDOWS AND NOT VCPKG_TARGET_IS_MINGW)
    vcpkg_cmake_get_vars(cmake_vars_file)
    include("${cmake_vars_file}")

    if(VCPKG_DETECTED_CMAKE_CXX_COMPILER_ID MATCHES "MSVC")
        vcpkg_list(SET OPTIONS 
                    "-DCMAKE_C_COMPILER=${CURRENT_HOST_INSTALLED_DIR}/manual-tools/vcpkg-tool-llvm/bin/clang-cl.exe"
                    "-DCMAKE_CXX_COMPILER=${CURRENT_HOST_INSTALLED_DIR}/manual-tools/vcpkg-tool-llvm/bin/clang-cl.exe"
                    "-DCMAKE_AR=${VCPKG_DETECTED_CMAKE_AR}"
                    "-DCMAKE_LINKER=${VCPKG_DETECTED_CMAKE_LINKER}"
                    "-DCMAKE_MT=${VCPKG_DETECTED_CMAKE_MT}"
                    )
        if(VCPKG_TARGET_ARCHITECTURE STREQUAL "arm64")
            string(APPEND VCPKG_C_FLAGS " --target=aarch64-win32-msvc")
            string(APPEND VCPKG_CXX_FLAGS " --target=aarch64-win32-msvc")
            vcpkg_list(APPEND OPTIONS -DCMAKE_CROSSCOMPILING=ON -DCMAKE_SYSTEM_PROCESSOR:STRING=ARM64 -DCMAKE_SYSTEM_NAME:STRING=Windows -DCMAKE_Fortran_FLAGS=--target=aarch64-win32-msvc)
        endif()
    endif()
    x_vcpkg_find_fortran(OUT_OPTIONS fortran_cmake 
                     OUT_OPTIONS_RELEASE fortran_cmake_rel
                     OUT_OPTIONS_DEBUG   fortran_cmake_dbg)
    #vcpkg_list(APPEND OPTIONS 
    #                "-DCMAKE_Fortran_COMPILER=${CURRENT_HOST_INSTALLED_DIR}/manual-tools/llvm-flang/bin/flang.exe"
    #                "-DCMAKE_Fortran_COMPILER_ID=Flang"
    #          )

    vcpkg_acquire_msys(MSYS_ROOT PACKAGES gawk bash sed)
    vcpkg_add_to_path("${MSYS_ROOT}/usr/bin")
    if(VCPKG_TARGET_ARCHITECTURE STREQUAL "x64")
        set(ARCH X86)
    elseif(VCPKG_TARGET_ARCHITECTURE STREQUAL "arm64")
        set(ARCH ARM)
    endif()
    vcpkg_add_to_path("${CURRENT_HOST_INSTALLED_DIR}/manual-tools/llvm-flang/bin/${ARCH}")
endif()

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        #"-DLLVM_TARGETS_TO_BUILD=X86;AArch64"
        "-DFLANG_BUILD_RUNTIME=ON"
        "-DFLANG_LLVM_EXTENSIONS=ON"
        "-DFLANG_INCLUDE_DOCS=OFF"
        "-DLLVM_INCLUDE_TESTS=OFF"
        "-DFLANG_BUILD_TOOLS=OFF"
        "-DVCPKG_HOST_TRIPLET=${_HOST_TRIPLET}"
        #"-DLLVM_CONFIG=${CURRENT_HOST_INSTALLED_DIR}/manual-tools/llvm-flang/bin/llvm-config.exe"
        #"-DLLVM_CMAKE_PATH=${CURRENT_HOST_INSTALLED_DIR}/manual-tools/llvm-flang/lib/cmake/llvm" # Flang does not link against anything in llvm
        "-DLLVM_TOOLS_BINARY_DIR=${CURRENT_INSTALLED_DIR}/bin"
        "-DLLVM_LIBRARY_DIR=${CURRENT_INSTALLED_DIR}/lib"
        "-DLLVM_MAIN_INCLUDE_DIR=${CURRENT_INSTALLED_DIR}/include/llvm"
        "-DCMAKE_MODULE_PATH=${SOURCE_LLVM}/llvm/cmake/modules"
        "-DLLVM_PACKAGE_VERSION=13.0.1"
        "-DCMAKE_Fortran_PREPROCESS_SOURCE=<CMAKE_Fortran_COMPILER> -cpp <DEFINES> <INCLUDES> <FLAGS> -E -o <PREPROCESSED_SOURCE> <SOURCE>"
        #"-DCMAKE_Fortran_COMPILE_OPTIONS_PREPROCESS_ON=-cpp"
        #"-DCMAKE_Fortran_COMPILE_OPTIONS_PREPROCESS_OFF=-nocpp"
        #"-DCMAKE_Fortran_SUBMODULE_SEP=@"
        #"-DCMAKE_Fortran_SUBMODULE_EXT=.mod"
        #"-DCMAKE_Fortran_FORMAT_FIXED_FLAG=-ffixed-form"
        #"-DCMAKE_Fortran_FORMAT_FREE_FLAG=-ffree-form"
        "-DCMAKE_INCLUDE_SYSTEM_FLAG_Fortran="
        "-DCMAKE_Fortran_MODDIR_FLAG=-J"
        "-DCMAKE_Fortran_POSTPROCESS_FLAG=-fpreprocessed"
        ${fortran_cmake}
        ${OPTIONS}
    OPTIONS_RELEASE
        ${fortran_cmake_rel}
    OPTIONS_DEBUG
        ${fortran_cmake_dbg}
)
vcpkg_cmake_install(ADD_BIN_TO_PATH)

#file(GLOB_RECURSE allbinfiles "${CURRENT_PACKAGES_DIR}/bin/*")
#file(MAKE_DIRECTORY "${CURRENT_PACKAGES_DIR}/manual-tools/llvm-flang/")
#file(RENAME "${CURRENT_PACKAGES_DIR}/bin" "${CURRENT_PACKAGES_DIR}/manual-tools/llvm-flang/bin" )
#file(GLOB_RECURSE alllibfiles "${CURRENT_PACKAGES_DIR}/lib/*")
#file(RENAME "${CURRENT_PACKAGES_DIR}/lib" "${CURRENT_PACKAGES_DIR}/manual-tools/llvm-flang/lib" )

#file(RENAME "${CURRENT_PACKAGES_DIR}/include" "${CURRENT_PACKAGES_DIR}/manual-tools/llvm-flang/include" )

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

file(INSTALL "${SOURCE_PATH}/LICENSE.txt" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)

set(VCPKG_POLICY_DLLS_IN_STATIC_LIBRARY enabled)