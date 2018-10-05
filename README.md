# Rust CMake

An example of integrating cargo/rust with CMake projects, and a reusable cmake function to help.

This builds arbitrary rust projects under your `${CMAKE_BINARY_DIR}` output directory.

## Layout

- [CMakeLists.txt]() is the top level CMake configuration file
- [rust.cmake]() defines a function to build rust libraries
- [bin/]() contains the C source files
- [rs/]() contains the example rust library

## Building the example

- `git clone git@github.com:ryankurte/rust-cmake.git` to clone
- `cd rust-cmake` to change to the project directory
- `mkdir build && cd build` to create a build directory and change to it
- `cmake ..` to configure cmake
- `make testlib` to perform a first library build (see issues section following)
- `make` to build everything
- `./example` to execute the example application

## Using this in a cmake project

- Copy [rust.cmake]() into your project
- Include it in your top level CMake file with `include(rust.cmake)`
- Add a rust project with `build_rust(NAME LOCATION TARGET)`, target can be `""` for native compilation.
- Add `${RUST_LIBS}` to your linker arguments with `target_link_libraries(example ${RUST_LIBS})`.

## Issues
- The c header file is not generated until the rust library is built, which must be manually run the first time. There should be a way to order this.

