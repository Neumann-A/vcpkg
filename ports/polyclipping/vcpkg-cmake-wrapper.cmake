list(REMOVE_ITEM ARGS "NO_MODULE")
list(REMOVE_ITEM ARGS "CONFIG")
list(REMOVE_ITEM ARGS "MODULE")

set(clipper_PREV_MODULE_PATH ${CMAKE_MODULE_PATH})
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR})

z_vcpkg_underlying_find_package(${ARGS})

set(CMAKE_MODULE_PATH ${clipper_PREV_MODULE_PATH})
