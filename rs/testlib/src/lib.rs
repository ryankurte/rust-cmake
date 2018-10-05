
#[no_mangle]
pub extern fn add(a: u32, b: u32) -> u32 {
    let c = a + b;
    println!("Adding A ({}) + B ({}) = {}", a, b, c);
    c
}

