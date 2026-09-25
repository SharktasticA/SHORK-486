#include "libshork.h"
#include <stdio.h>
#include <string.h>

int main(void)
{
    const char *msg = libshorkMessage();
    printf("%s\n", msg);
    if (strcmp(msg, "Hello, SHORK!") != 0)
    {
        fprintf(stderr, "FAIL: unexpected greeting: %s\n", msg);
        return 1;
    }
    return 0;
}
