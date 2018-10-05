#include <stdio.h>

#include "rust-lib.h"

int main(int argc, char** argv) {
    printf("CMake and Cargo Interop Example\n");

    int c = add(2, 4);

    return 0;
}


