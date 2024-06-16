set(VCPKG_POLICY_EMPTY_PACKAGE enabled)

set(PROGNAME node)

set(BREW_PACKAGE_NAME "${PROGNAME}")
set(APT_PACKAGE_NAME "${PROGNAME}")

if(VCPKG_CROSSCOMPILING)
    message(FATAL_ERROR "This is a host only port!")
endif()

set(BASE_URL "https://nodejs.org/dist/v${VERSION}/")
set(ARCHIVE "")
set(ARCHIVE_EXT "")

if(VCPKG_TARGET_IS_WINDOWS AND VCPKG_TARGET_ARCHITECTURE MATCHES "^x86$|arm")
    set(ARCHIVE "node-v${VERSION}-win-x86")
    set(ARCHIVE_EXT ".zip")
    set(HASH 0)
elseif(VCPKG_TARGET_IS_WINDOWS AND VCPKG_TARGET_ARCHITECTURE STREQUAL "x64")
    set(ARCHIVE "node-v${VERSION}-win-x64")
    set(ARCHIVE_EXT ".zip")
    set(HASH 0)
elseif(VCPKG_TARGET_IS_OSX AND VCPKG_TARGET_ARCHITECTURE STREQUAL "x64")
    set(ARCHIVE "node-v${VERSION}-darwin-x64")
    set(ARCHIVE_EXT ".tar.gz")
    set(HASH 0)
elseif(VCPKG_TARGET_IS_OSX AND VCPKG_TARGET_ARCHITECTURE STREQUAL "arm64")
    set(ARCHIVE "node-v${VERSION}-darwin-arm64")
    set(ARCHIVE_EXT ".tar.gz")
    set(HASH 0)
elseif(VCPKG_TARGET_IS_LINUX AND VCPKG_TARGET_ARCHITECTURE STREQUAL "x64")
    set(ARCHIVE "node-v${VERSION}-linux-x64")
    set(ARCHIVE_EXT ".tar.xz")
    set(HASH 8fe5bd9d1b88c1306e902483c8c7f01256666086bfbb46a9f49ea77bd1b75c1bac906384b90f73960de0a28127324779991107facc3bd0eb306b1458fa43370e)
elseif(VCPKG_TARGET_IS_LINUX AND VCPKG_TARGET_ARCHITECTURE STREQUAL "arm64")
    set(ARCHIVE "node-v${VERSION}-linux-arm64")
    set(ARCHIVE_EXT ".tar.xz")
    set(HASH 0)
else()
    message(FATAL_ERROR "Target not yet supported by '${PORT}'")
endif()
set(URL "${BASE_URL}${ARCHIVE}${ARCHIVE_EXT}")
message(STATUS "URL: '${URL}'")

vcpkg_download_distfile(ARCHIVE_PATH
  URLS "${URL}"
  SHA512 "${HASH}"
  FILENAME "${ARCHIVE}${ARCHIVE_EXT}"
  #ALWAYS_REDOWNLOAD
  #SKIP_SHA512
)

file(MAKE_DIRECTORY "${CURRENT_PACKAGES_DIR}/tools")
message(STATUS "ARCHIVE_PATH: '${ARCHIVE_PATH}'")

vcpkg_execute_in_download_mode(
    COMMAND ${CMAKE_COMMAND} -E tar xzf "${ARCHIVE_PATH}"
    WORKING_DIRECTORY "${CURRENT_PACKAGES_DIR}/tools"
)

file(RENAME "${CURRENT_PACKAGES_DIR}/tools/${ARCHIVE}" "${CURRENT_PACKAGES_DIR}/tools/node")
