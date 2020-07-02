#include <stdio.h>
#include <sys/stat.h>
#include <unistd.h>

int main()
{
    if (geteuid() != 0) {
        printf("Run this as root!\n");
        return 1;
    }

    chown("/usr/bin/revealloader", 0, 0);
    chmod("/usr/bin/revealloader", 06755);

    return 0;
}
