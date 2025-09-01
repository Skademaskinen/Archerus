project(initializer)
cmake_minimum_required(VERSION 3.10)
set(CMAKE_CXX_STANDARD 23)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(PROJECT_IMPLEMENTATIONS
    src/config.cpp
    src/initializer.cpp
    src/home_manager.cpp
    src/nixos.cpp
)

include_directories(include)

include_directories(../../lib/cpplib)

find_package(argparse REQUIRED)

add_executable(initializer src/main.cpp ${PROJECT_IMPLEMENTATIONS})

target_link_libraries(initializer PRIVATE 
    argparse::argparse 
)
