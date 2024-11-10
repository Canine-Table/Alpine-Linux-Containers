#include <stdio.h>
#include <string.h>

void target_function();
void vulnerable_function(char*);

int main(int argc, char **argv) {
        if (argc != 2) {
                fprintf(stderr, "Usage: %s <input string>\n", argv[0]);
                return 1;
        }
    
        vulnerable_function(argv[1]);
        printf("Function executed successfully.\n");
        return 0;
}

void target_function() {
        printf("Target function executed.\n");
}

void vulnerable_function(char *str) {
        char buffer[16];

        // This is intentionally vulnerable
        strcpy(buffer, str);
}
