#include <stdio.h>
#include <sys/time.h>

int main() {
    struct timeval tv1,tv2;
    fprintf(stderr,"press enter...\n");
    getchar();

    if (0 != gettimeofday (&tv1,NULL)) {
        perror("err...");
        exit(-1);
    }

    fprintf(stderr,"press enter...\n");
    getchar();

    if (0 != gettimeofday (&tv2,NULL)) {
        perror("err...");
        exit(-1);
    }

    printf("%.4f\n", (double)tv2.tv_sec+(double)tv2.tv_usec/1e6
                  -(double)tv1.tv_sec-(double)tv1.tv_usec/1e6);
}
