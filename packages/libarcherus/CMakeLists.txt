cmake_minimum_required(VERSION 3.16)
project(libarcherus VERSION 0.1.0 LANGUAGES CXX)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_CXX_STANDARD 23)

# Shared library
add_library(libarcherus SHARED
    src/libarcherus.cpp
)

target_include_directories(libarcherus
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
        $<INSTALL_INTERFACE:include>
)

set_target_properties(libarcherus PROPERTIES
    VERSION ${PROJECT_VERSION}
    SOVERSION 1
    EXPORT_NAME libarcherus
)

# Install library + headers
install(TARGETS libarcherus
    EXPORT libarcherusTargets
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
    RUNTIME DESTINATION bin
    INCLUDES DESTINATION include
)

install(DIRECTORY include/ DESTINATION include)

# Package config
include(CMakePackageConfigHelpers)

write_basic_package_version_file(
    "${CMAKE_CURRENT_BINARY_DIR}/libarcherusConfigVersion.cmake"
    VERSION ${PROJECT_VERSION}
    COMPATIBILITY AnyNewerVersion
)

install(EXPORT libarcherusTargets
    FILE libarcherusTargets.cmake
    NAMESPACE archerus::
    DESTINATION lib/cmake/libarcherus
)

configure_file(libarcherusConfig.cmake.in
    "${CMAKE_CURRENT_BINARY_DIR}/libarcherusConfig.cmake"
    @ONLY
)

install(FILES
    "${CMAKE_CURRENT_BINARY_DIR}/libarcherusConfig.cmake"
    "${CMAKE_CURRENT_BINARY_DIR}/libarcherusConfigVersion.cmake"
    DESTINATION lib/cmake/libarcherus
)

