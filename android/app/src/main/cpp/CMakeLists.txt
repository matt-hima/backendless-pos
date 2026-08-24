cmake_minimum_required(VERSION 3.22.1)
project(lilygo_native)

set(EXTENSION_STATIC_BUILD 1 CACHE BOOL "" FORCE)
set(BUILD_EXTENSIONS "json;parquet" CACHE STRING "" FORCE)
set(DUCKDB_EXTRA_LINK_FLAGS "-llog" CACHE STRING "" FORCE)
set(ENABLE_EXTENSION_AUTOLOADING 1 CACHE BOOL "" FORCE)
set(ENABLE_EXTENSION_AUTOINSTALL 1 CACHE BOOL "" FORCE)
set(BUILD_UNITTESTS 0 CACHE BOOL "" FORCE)
set(BUILD_SHELL 0 CACHE BOOL "" FORCE)
set(DUCKDB_EXPLICIT_PLATFORM "android_arm64-v8a" CACHE STRING "" FORCE)
set(OVERRIDE_GIT_DESCRIBE "" CACHE STRING "" FORCE)

add_subdirectory(
    ${CMAKE_CURRENT_LIST_DIR}/../../../../../native/duckdb
    ${CMAKE_CURRENT_BINARY_DIR}/duckdb
)

add_library(duckdb_android SHARED duckdb_jni.cpp)
target_include_directories(duckdb_android PRIVATE
    ${CMAKE_CURRENT_LIST_DIR}/../../../../../native/duckdb/src/include
)
target_link_libraries(duckdb_android PRIVATE
    duckdb_static
    duckdb_generated_extension_loader
    json_extension
    parquet_extension
    core_functions_extension
    log
)
