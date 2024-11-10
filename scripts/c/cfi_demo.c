#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

void target_function() {
        printf("Target function executed.\n");
}

void vulnerable_function(void (*func)()) {
        func();
}

int main(int argc, char **argv) {
        if (argc != 2) {
                fprintf(stderr, "Usage: %s <input>\n", argv[0]);
                return 1;
        }

        void (*func)() = NULL;

        if (argv[1][0] == '1')
                func = target_function;
        else
                func = (void (*)())(uintptr_t)strtoul(argv[1], NULL, 0);

        vulnerable_function(func);

        return 0;
}
