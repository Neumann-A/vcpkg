vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO root-project/root
    REF 6438fdb78a7d0cc06e2f3dd2dd5bf057b00fa7ea # 55e26c43341d2175e9703311bef455f3bcf6bf44 04/25/2023
    SHA512 7424924b2b01fc6cea33b0081ebe7913686a0a6bcb06d71b8ca59d1fd907643c0dd9f5190e835e99c014ab04282a369f798cf81baba261e0c592ddf8db47f071 # e56026de02bdca275933e0dd2131e2d527224c1956cdf1afb0b6d12090e5e90e7e2c3277040f388417b7becc58d4a659540271fe168d864a7f568ed6278164f7
    HEAD_REF master
    PATCHES
        fix_find_package.patch
        fix_ninja_msvc.diff
        more-patches.patch
        build-fixes.patch
)

#string(APPEND VCPKG_C_FLAGS " -D__TBB_NO_IMPLICIT_LINKAGE=1")
#string(APPEND VCPKG_CXX_FLAGS " -D__TBB_NO_IMPLICIT_LINKAGE=1")

vcpkg_find_acquire_program(GIT)
cmake_path(GET GIT PARENT_PATH GIT_DIR)
vcpkg_add_to_path("${GIT_DIR}")

vcpkg_add_to_path("${CURRENT_HOST_INSTALLED_DIR}/tools/python3")
vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DBUILD_TESTING=OFF
        -DVCPKG_HOST_TRIPLET=${_HOST_TRIPLET}
        "-DPYTHON_EXECUTABLE=${CURRENT_HOST_INSTALLED_DIR}/tools/python3/python${VCPKG_HOST_EXECUTABLE_SUFFIX}"
        -Dbuiltin_tbb=OFF
        -Dbuiltin_gtest=OFF
        -DCMAKE_CXX_STANDARD=17
        "-DLLVM_ENABLE_ASSERTIONS=on"
        "-Dalien=off"
        "-Dall=off"
        "-Darrow=off"
        "-Dasan=off"
        "-Dasimage=on"
        "-Dasserts=off"
        "-Dbuiltin_afterimage=on"
        "-Dbuiltin_cppzmq=off"
        "-Dbuiltin_davix=off"
        "-Dbuiltin_fftw3=off"
        "-Dbuiltin_gsl=off"
        "-Dbuiltin_llvm=on"
        "-Dbuiltin_openssl=off"
        "-Dbuiltin_openui5=on"
        "-Dbuiltin_unuran=on"
        "-Dbuiltin_vc=off"
        "-Dbuiltin_vdt=off"
        "-Dbuiltin_veccore=off"
        "-Dbuiltin_xrootd=off"
        "-Dbuiltin_xxhash=off"
        "-Dbuiltin_zeromq=off"
        "-Dbuiltin_zlib=off"
        "-Dbuiltin_zstd=off"
        "-Dccache=off"
        "-Dcefweb=off"
        "-Dclad=on"
        "-Dclingtest=off"
        "-Dcocoa=off"
        "-Dcoverage=off"
        "-Dcuda=off"
        "-Dcudnn=off"
        "-Dcxxmodules=off"
        "-Ddaos=off"
        "-Ddataframe=on"
        "-Ddavix=off"
        "-Ddcache=off"
        "-Ddev=off"
        "-Ddistcc=off"
        "-Dexceptions=on"
        "-Dfcgi=off"
        "-Dfftw3=on"
        "-Dfitsio=on"
        "-Dfortran=off"
        "-Dgdml=on"
        "-Dgfal=off"
        "-Dgminimal=off"
        "-Dgnuinstall=off"
        "-Dgsl_shared=off"
        "-Dgviz=off"
        "-Dhttp=on"
        "-Dimt=on"
        "-Djemalloc=off"
        "-Dlibcxx=off"
        "-Dllvm13_broken_tests=off"
        "-Dmacos_native=off"
        "-Dmathmore=on"
        "-Dmemory_termination=off"
        "-Dminimal=off"
        "-Dminuit2=on"
        "-Dminuit2_mpi=off"
        "-Dminuit2_omp=off"
        "-Dmlp=on"
        "-Dmonalisa=off"
        "-Dmpi=off"
        "-Dmysql=off"
        "-Dodbc=on"
        "-Dopengl=on"
        "-Doracle=off"
        "-Dpgsql=off"
        "-Dpyroot2=off"
        "-Dpyroot3=off"
        "-Dpyroot=off"
        "-Dpyroot_legacy=off"
        "-Dpythia6=off"
        "-Dpythia6_nolink=off"
        "-Dpythia8=off"
        "-Dqt5web=off"
        "-Dqt6web=off"
        "-Dr=off"
        "-Droofit=on"
        "-Droofit_multiprocess=off"
        "-Droot7=on"
        "-Drootbench=off"
        "-Droottest=on"
        "-Drpath=on"
        "-Druntime_cxxmodules=off"
        "-Dshadowpw=off"
        "-Dshared=on"
        "-Dsoversion=off"
        "-Dspectrum=on"
        "-Dsqlite=off"
        "-Dssl=off"
        "-Dtcmalloc=off"
        "-Dtest_distrdf_dask=off"
        "-Dtest_distrdf_pyspark=off"
        "-Dtesting=on"
        "-Dtmva-cpu=on"
        "-Dtmva-gpu=off"
        "-Dtmva-pymva=on"
        "-Dtmva-rmva=off"
        "-Dtmva-sofie=off"
        "-Dtmva=on"
        "-Dunuran=on"
        "-During=off"
        "-Dvc=off"
        "-Dvdt=off"
        "-Dveccore=off"
        "-Dvecgeom=off"
        "-Dwebgui=on"
        "-Dwin_broken_tests=off"
        "-Dwinrtdebug=off"
        "-Dx11=off"
        "-Dxml=off"
        "-Dxproofd=off"
        "-Dxrootd=off"
        #--trace-expand
)

vcpkg_cmake_install(ADD_BIN_TO_PATH)
vcpkg_cmake_config_fixup()
vcpkg_fixup_pkgconfig()

file(REMOVE_RECURSE
        "${CURRENT_PACKAGES_DIR}/debug/include"
        "${CURRENT_PACKAGES_DIR}/debug/share")

vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LGPL2_1.txt")