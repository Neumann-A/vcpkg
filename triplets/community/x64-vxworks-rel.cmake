set(VCPKG_TARGET_ARCHITECTURE x64)
set(VCPKG_CRT_LINKAGE dynamic)
set(VCPKG_LIBRARY_LINKAGE static)

set(VCPKG_CMAKE_SYSTEM_NAME Linux)
set(VCPKG_BUILD_TYPE release)

set(VCPKG_MAKE_BUILD_TRIPLET "--build=x86_64-pc-linux-gnu --host=x86_64-wrs-vxworks")
set(VCPKG_MESON_FORCE_CROSS ON)

set(ENV{WIND_SDK_HOME} "/home/neumann/vxworks/wrsdk-vxworks7-qemu")
set(ENV{WIND_SDK_CC_SYSROOT} "$ENV{WIND_SDK_HOME}/vxsdk/sysroot")
set(ENV{WRSD_LICENSE_FILE} "$ENV{WIND_SDK_HOME}/license")

set(VCPKG_CHAINLOAD_TOOLCHAIN_FILE "$ENV{WIND_SDK_CC_SYSROOT}/mk/rtp.toolchain.cmake")

set(VCPKG_CMAKE_CONFIGURE_OPTIONS "-DQT_QMAKE_TARGET_MKSPEC=vxworks-clang")

set(VCPKG_CONFIGURE_MAKE_OPTIONS "--enable-malloc0returnsnull=yes")
if(PORT STREQUAL "xcb")
  list(APPEND VCPKG_CONFIGURE_MAKE_OPTIONS "ac_cv_search_sendmsg=no")
endif() 
if(PORT STREQUAL "libx11")
  list(APPEND VCPKG_CONFIGURE_MAKE_OPTIONS "ac_cv_member_struct_sockaddr_in_sin_len=no")
endif() 
set(ENV{CC} "wr-cc")
set(ENV{CXX} "wr-c++")
set(ENV{CPP} "wr-cpp")
set(ENV{LD} "wr-ld")
set(ENV{AR} "wr-ar")
set(ENV{NM} "wr-nm")
set(ENV{OBJCOMPY} "wr-objcopy")
set(ENV{OBJDUMP} "wr-objdump")
set(ENV{RANLIB} "wr-ranlib")
set(ENV{READELF} "wr-readelf")
set(ENV{SIZE} "wr-size")
set(ENV{STRIP} "wr-strip")

set(ENV{PATH} "$ENV{WIND_SDK_HOME}/vxsdk/host/x86_64-linux/bin:$ENV{PATH}")
# export LD_LIBRARY_PATH=${WIND_SDK_HOME}/vxsdk/host/x86_64-linux/lib:${LD_LIBRARY_PATH}

set(ENV{PATH} "$ENV{WIND_SDK_HOME}/tools/debug/24.03/x86_64-linux2/bin:$ENV{PATH}")
# export LD_LIBRARY_PATH=${WIND_SDK_HOME}/tools/debug/24.03/x86_64-linux2/lib:${LD_LIBRARY_PATH}

# export WIND_SDK_CCBASE_PATH=${WIND_SDK_HOME}/compilers/llvm-17.0.6.1/LINUX64/bin

# __WIND_HOME=${WIND_HOME}
# __WIND_CC_SYSROOT=${WIND_CC_SYSROOT}
# WIND_HOME=${WIND_SDK_HOME}
# source ${WIND_SDK_HOME}/vxsdk/sysroot/usr/rust/rustenv.linux
# WIND_HOME=${__WIND_HOME}
# WIND_CC_SYSROOT=${__WIND_CC_SYSROOT}

set(X_VCPKG_FORCE_VCPKG_X_LIBRARIES ON)

# notes:
# -D_XOPEN_SOURCE -D_POSIX_C_SOURCE required that that BOOL does not get redefined
# -D_ISO_C_SOURCE  cannot be defined due to macros being not set in limits.h (-DIOV_MAX=1024)
# ac_cv_search_sendmsg=no is not set because a macro is not defined for xcb
# --enable-malloc0returnsnull=yes needs to be checked. I simply assumed yes