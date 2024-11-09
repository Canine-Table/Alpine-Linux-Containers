#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

// Function to generate a random canary
unsigned int generate_canary() {
        srand(time(NULL));
        return rand();
}

void vulnerable_function(char *str) {
        // Generate and store a random canary
        unsigned int canary = generate_canary(); 

        // Copy the canary to a check variable
        unsigned int check_canary = canary;

        char buffer[16];

        // This is intentionally vulnerable
        strcpy(buffer, str);

        // Check the canary value before the function returns
        if (canary != check_canary) {
                printf("Stack smashing detected!\n");
                exit(1);
        }
}

int main(int argc, char **argv) {
        if (argc != 2) {
                fprintf(stderr, "Usage: %s <input string>\n", argv[0]);
                return 1;
        }
        vulnerable_function(argv[1]);
        printf("Function executed successfully.\n");
        return 0;
}
