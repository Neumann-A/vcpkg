include("${CMAKE_CURRENT_LIST_DIR}/../vcpkg-cmake-get-vars/vcpkg-port-config.cmake")

# Or this file should be autogenerated somehow. 
file(GLOB cmake_files "${CMAKE_CURRENT_LIST_DIR}/*.cmake")
foreach(cmake_file IN LISTS cmake_files)
    include("${cmake_file}")
endforeach()
