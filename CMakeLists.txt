
cmake_minimum_required (VERSION 3.2)
project (rust-example)

# Set C headers for inclusion
include_directories(
    bin/inc/
)

# Set C sources for compilation
set(SOURCES
    bin/src/main.c
)

# Include the rust.cmake helper
include(rust.cmake)

# Build the rust project "testlib" in "rs/testlib" with no target
build_rust(testlib rs/testlib "")

# Compile executable
add_executable(example ${SOURCES})

# Link to rust library
target_link_libraries(example ${RUST_LIBS})

# Set rust library to build as part of executable
#add_dependencies(example ${RUST_DEPS})
