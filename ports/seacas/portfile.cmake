vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO gsjaardema/seacas
    REF 3eba1c8f0ec86f8359064c7f8ed5f5ac07a1ce68 
    SHA512 a73f1fe359900e0f98c5c9c1078bbd564fcedb6d448a9b8beda741e60fb2b6c46aa79e2c654b266d0c8f32bed67d200a30127988d6ea6d471d980372ca39b6d7
    HEAD_REF master
    PATCHES
)

#set(SEACASExodus_ENABLE_STATIC_DEFAULT "OFF")
#set(SEACASExodus_ENABLE_SHARED_DEFAULT "OFF")

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
      -DSEACASProj_ENABLE_Fortran:BOOL=OFF
      -DSEACASProj_ENABLE_Zoltan:BOOL=ON # Only supported by linux?
      -DSEACASProj_ENABLE_SEACAS:BOOL=ON
      -DSEACASProj_ENABLE_SEACASIoss:BOOL=ON
      -DSEACASProj_ENABLE_ALL_PACKAGES:BOOL=ON
      -DTrilinos_ENABLE_SEACAS:BOOL=ON
      -DTPL_ENABLE_Netcdf:BOOL=ON
  #-D Netcdf_LIBRARY_DIRS:PATH=${WHERE_TO_INSTALL}/lib
  #-D TPL_Netcdf_INCLUDE_DIRS:PATH=${WHERE_TO_INSTALL}/include
      -DTPL_Netcdf_Enables_Netcdf4:BOOL=ON  #(if built with hdf5 libraries which give netcdf-4 capability)
      -DTPL_Netcdf_Enables_PNetcdf:BOOL=ON  #(if built with parallel-netcdf which gives parallel I/O capability)
      -DTPL_ENABLE_Matio:BOOL=ON  
      -DTPL_ENABLE_HDF5:BOOL=ON
      -DTPL_ENABLE_CGNS:BOOL=ON
      -DTPL_ENABLE_Zlib:BOOL=ON
  #-D Matio_LIBRARY_DIRS:PATH=${WHERE_TO_INSTALL}/lib
  #-D TPL_Matio_INCLUDE_DIRS:PATH=${WHERE_TO_INSTALL}/include
  #-D TPL_X11_INCLUDE_DIRS:PATH=/usr/X11R6/include  (SVDI, blot, fastq require X11 includes and libs)
  #-D SEACAS_ENABLE_TESTS=ON
)

vcpkg_cmake_install()
vcpkg_cmake_config_fixup()
vcpkg_fixup_pkgconfig()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")

# Handle post-build CMake instructions
vcpkg_copy_pdbs()
