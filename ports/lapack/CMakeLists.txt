cmake_minimum_required(VERSION 3.17)



project(Find_LAPACK_external)
find_package(BLAS REQUIRED)
set(CMAKE_REQUIRED_LINK_OPTIONS ${CMAKE_REQUIRED_LINK_OPTIONS} -LIBPATH:${MINGW_ROOT}/mingw64/x86_64-w64-mingw32/lib/ -LIBPATH:${MINGW_ROOT}/mingw64/lib/gcc/x86_64-w64-mingw32/11.2.0/) 
set(CMAKE_REQUIRED_LINK_OPTIONS ${CMAKE_REQUIRED_LINK_OPTIONS} libgfortran.a libquadmath.a libgcc_eh.a libatomic.a libm.a libpthread.a) 
find_package(LAPACK REQUIRED)
