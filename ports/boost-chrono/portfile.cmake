# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/chrono
    REF boost-1.80.0
    SHA512 421b8b30e7e11024c240815e2c5eb5a7c7b76fdc8ac7da9bb70c600aced9da96bd634bfb3dd5c485f00d0cf2bc9bb75cda15bcc08753cd007853fcf2ca80f8d1
    HEAD_REF master
)

include(${CURRENT_HOST_INSTALLED_DIR}/share/boost-build/boost-modular-build.cmake)
boost_modular_build(SOURCE_PATH ${SOURCE_PATH})
include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
