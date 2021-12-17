# VENDORED DEPENDENCIES! 
# TODO: Should be replaced in the future with VCPKG internal versions
# add_subdirectory(thirdparty/diy)
# add_subdirectory(thirdparty/lodepng)
# if(VTKm_ENABLE_LOGGING)
  # add_subdirectory(thirdparty/loguru)
# endif()
# add_subdirectory(thirdparty/optionparser)
# add_subdirectory(thirdparty/taotuple)
# add_subdirectory(thirdparty/lcl)

vcpkg_check_features (OUT_FEATURE_OPTIONS OPTIONS 
    FEATURES
      cuda   VTKm_ENABLE_CUDA
      omp    VTKm_ENABLE_OPENMP
      tbb    VTKm_ENABLE_TBB
      mpi    VTKm_ENABLE_MPI
      double VTKm_USE_DOUBLE_PRECISION
    )
    
if("cuda" IN_LIST FEATURES AND NOT ENV{CUDACXX})
  set(ENV{CUDACXX} "$ENV{CUDA_PATH}/bin/nvcc")
  if(VCPKG_LIBRARY_LINKAGE STREQUAL "dynamic")
      message(STATUS "Feature CUDA forces static build!")
  endif()
  set(VCPKG_LIBRARY_LINKAGE "static") # CUDA forces static build.
endif()

list(APPEND OPTIONS -DVTKm_ENABLE_RENDERING=ON)
list(APPEND OPTIONS -DVTKm_ENABLE_DEVELOPER_FLAGS=OFF)
list(APPEND OPTIONS -DVTKm_ENABLE_CPACK=OFF)
list(APPEND OPTIONS -DVTKm_USE_DEFAULT_TYPES_FOR_VTK=ON)
# For port customizations on unix systems. 
# Please feel free to make these port features if it makes any sense
#list(APPEND OPTIONS -DVTKm_ENABLE_GL_CONTEXT=ON) # or
#list(APPEND OPTIONS -DVTKm_ENABLE_EGL_CONTEXT=ON) # or
#list(APPEND OPTIONS -DVTKm_ENABLE_OSMESA_CONTEXT=ON)
list(APPEND OPTIONS -DBUILD_TESTING=OFF)

vcpkg_from_gitlab(GITLAB_URL "https://gitlab.kitware.com" 
                  OUT_SOURCE_PATH SOURCE_PATH 
                  REPO vtk/vtk-m 
                  REF d5143ad7ed2e55025cec2f49fb3f0ab46045a8e2 # v1.7.0 Version is strongly locked to VTK 9.1. Upgrading will most likly brake the VTK build
                  SHA512 969edf3fcf297c9e3aa3743a66591fdd44e718dafc16dbb6f1a57755f56a20a00b1db0d46e8d3fcb328d0dfa64071807474e7f68f44e28104dd2eea2d7570216
                  FILE_DISAMBIGUATOR 1)
vcpkg_cmake_configure(
  SOURCE_PATH "${SOURCE_PATH}"
  OPTIONS ${OPTIONS}
)
vcpkg_cmake_install()
vcpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/vtkm-1.7 PACKAGE_NAME vtkm)

vcpkg_replace_string("${CURRENT_PACKAGES_DIR}/share/vtkm/VTKmConfig.cmake" [[set_and_check(VTKm_CONFIG_DIR "${PACKAGE_PREFIX_DIR}/lib/cmake/vtkm-1.7")]] [[set_and_check(VTKm_CONFIG_DIR "${PACKAGE_PREFIX_DIR}/share/vtkm")]])
vcpkg_replace_string("${CURRENT_PACKAGES_DIR}/share/vtkm/VTKmConfig.cmake" "${CURRENT_BUILDTREES_DIR}" "not/existing/buildtree")

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

file(INSTALL "${SOURCE_PATH}/LICENSE.txt" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
