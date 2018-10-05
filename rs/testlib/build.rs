// build.rs example for rust libraries to generate c headers
// Check out https://github.com/ryankurte/rust-cmake for a full example and updated files
// Copyright 2018 Ryan Kurte

// Usage
// 1. Add rusty-binder and rusty-cheddar as build dependencies to your top level Cargo.toml
//   [build-dependencies]
//   rusty-binder = { git = "https://gitlab.com/rusty-binder/rusty-binder.git" }
//   rusty-cheddar = { git = "https://gitlab.com/rusty-binder/rusty-cheddar.git" }
// 2. Set your crate type to static in Cargo.toml
//   [lib]
//   crate-type = ["staticlib"]
// 3. Add build.rs to your top level library

use std::env;

extern crate binder;
extern crate cheddar;

fn main() {
    let dir = env::var("RUST_HEADER_DIR")
            .expect("RUST_HEADER_DIR environmental variable undefined");

    let header = env::var("RUST_HEADER_NAME")
            .expect("RUST_HEADER_DIR environmental variable undefined");

    println!("Generating header '{}' in location '{}'", header, dir);

    let c99 = cheddar::Header::c99()
         .name(&header);

    // TODO: no way of forcing this to re-run :-/
    binder::Binder::new().unwrap()
        .output_directory(dir)
        .register(c99) 
        .run_build();
}
