project(webserver)
cmake_minimum_required(VERSION 3.10)
set(CMAKE_CXX_STANDARD 23)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(PROJECT_IMPLEMENTATIONS
    src/config.cpp
    src/webserver.cpp
)

include_directories(include)

include_directories(../../lib/cpplib)

find_package(argparse REQUIRED)
find_package(httplib REQUIRED)
find_package(nlohmann_json REQUIRED)

add_executable(webserver src/main.cpp ${PROJECT_IMPLEMENTATIONS})

target_link_libraries(webserver PRIVATE 
    argparse::argparse 
    httplib::httplib 
    nlohmann_json::nlohmann_json
)
