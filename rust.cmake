# CMake helper for building rust libraries as a component of a C/C++ project
# Check out https://github.com/ryankurte/rust-cmake for a full example and updated files
# Copyright 2018 Ryan Kurte

# USAGE
# Install nightly rust (`rustup default nightly) and rust-src (`rustup component add rust-src`)
# and make the following additions to your top level CMakeLists.txt
# 1. Add the cargo folder (must match library name)
#     set(RUST_SOURCE rs)
# 2. Include rust.cmake
#     include(rust.cmake)
# 3. Add rust-lib as a dependency for your target
#     add_dependencies(${CMAKE_PROJECT_NAME} rust-lib)
# 4. Link rust libraries to your target
#     target_link_libraries(${CMAKE_PROJECT_NAME} ${RUST_LIBS})

# Locate cargo instance
find_program(CARGO cargo)

function(build_rust RUST_NAME RUST_SOURCE RUST_TARGET)

message(STATUS "[RUST] Building Rust project '${RUST_NAME}' from location '${RUST_SOURCE}' with target '${RUST_TARGET}'")

# Rust project base directory
set(_RUST_DIR "${PROJECT_SOURCE_DIR}/${RUST_SOURCE}") 

# Set cargo output dir to cmake binary dir (simplifies cleaning etc.)
set(ARGS --target-dir ${CMAKE_BINARY_DIR})

# Override cargo target if specified
if(RUST_TARGET)
	message(STATUS "[RUST] Overriding target with ${RUST_TARGET}")
	# Non-native target requires --target specifier
	set(ARGS ${ARGS} --target=${RUST_TARGET})
	# Non-native target goes into target specific dir
	set(_RUST_TARGETDIR ${CMAKE_BINARY_DIR}/${RUST_TARGET})
else()
	message(STATUS "[RUST] Using native target")
	# Native target builds into /target
	set(_RUST_TARGETDIR ${CMAKE_BINARY_DIR})
	# Native target requires pthread and dl
	set(RUST_LIBS pthread dl)
endif()

# Add release or debug args
if (CMAKE_BUILD_TYPE STREQUAL "Release")
	message(STATUS "[RUST] Detected release build")
	set(ARGS ${ARGS} --release)
	set(_RUST_OUTDIR ${_RUST_TARGETDIR}/release/)
else()
	message(STATUS "[RUST] Using default debug build")
	set(_RUST_OUTDIR ${_RUST_TARGETDIR}/debug/)
endif()

set(ENV "CMAKE_BINARY_DIR=${CMAKE_BINARY_DIR} RUST_HEADER_NAME=${RUST_NAME}.h")

# Add a target to build the rust library
set(_BUILD_CMD "${RUST_NAME}")
add_custom_target(${_BUILD_CMD} 
	COMMAND "${CARGO} build ${ARGS}"
	WORKING_DIRECTORY ${_RUST_DIR}
	DEPENDS ${_RUST_DIR}/*)

add_custom_command(
	OUTPUT ${_RUST_OUTDIR}/lib${RUST_NAME}.a ${_RUST_OUTDIR}/${RUST_NAME}.h
	COMMAND ${ENV} ${CARGO} build ${ARGS}
	WORKING_DIRECTORY ${_RUST_DIR}
	DEPENDS ${_RUST_DIR}/*
)

# Add a target to test the rust library
set(_TEST_CMD "${RUST_NAME}-test")
add_custom_target(${_TEST_CMD} 
	COMMAND ${ENV} ${CARGO} test ${ARGS}
	WORKING_DIRECTORY ${_RUST_DIR}
	DEPENDS ${_RUST_DIR}/*)

# Add a target to clean the rust library
set(_CLEAN_CMD "${RUST_NAME}-clean")
add_custom_target(${_CLEAN_CMD} 
	COMMAND ${ENV} ${CARGO} clean ${ARGS}
	WORKING_DIRECTORY ${_RUST_DIR}
)

# Include the C header output dir
include_directories(${CMAKE_BINARY_DIR}/c-header-C99)

# Define a RUST_LIBS variable for linking
set(RUST_LIBS ${RUST_LIBS} ${_RUST_OUTDIR}/lib${RUST_NAME}.a)

# Define a RUST_DEPS variable for specifying dependencies
# TODO: maybe this could be automated?
set(RUST_DEPS ${RUST_DEPS} ${RUST_NAME})

# Set variables globally in the cache for use outside of the function
SET(RUST_LIBS  "${RUST_LIBS}" CACHE INTERNAL "RUST_LIBS")
SET(RUST_DEPS  "${RUST_DEPS}" CACHE INTERNAL "RUST_DEPS")

endfunction(build_rust)

