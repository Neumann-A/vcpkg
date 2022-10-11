# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/io
    REF boost-1.80.0
    SHA512 9c37f72be450ca0fac5e10540732f43779665d9b03a90ad5a9abaca558fec40f62ca04f2a41894131b0661220206c4e4bd93671a1e2a26747f3361adab2c51a5
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
