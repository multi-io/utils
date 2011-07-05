#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>
#include <signal.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>

static int line_num;
static struct timeval start, stop;

static void sighandler(int);

static char *alloc_lines(unsigned line_length, unsigned count) {
    int i;
    char *result = malloc(count*(line_length+2));
    int rnd = open("/dev/urandom", O_RDONLY);
    for (i=0; i<count; i++) {
        int j;
        char *line = result + i*(line_length+2);
        read(rnd, line, count);
        for (j=0; j<line_length; j++) {
            char *pc = line+j;
            if (*pc<32) *pc = '.';
        }
        *(line+(j++)) = '\n';
        *(line+(j++)) = '\0';
    }
    close(rnd);
    return result;
}

#define count 512

int main(int argc, char **argv) {
    unsigned measurement_interval = 5;
    char *lines;
    const unsigned line_length = 39;
    if (argc>1) {
        if (1 != sscanf(argv[1], "%u", &measurement_interval)) {
            fputs("argument parse error\n", stderr);
            exit(-1);
        }
    }
    fprintf(stderr,"measurement_interval: %u secs\n", measurement_interval);
    
    if (SIG_ERR == signal(SIGALRM, sighandler)) {
        perror("signal");
        exit(-1);
    }

    lines = alloc_lines(line_length, count);

    if (0 != gettimeofday (&start,NULL)) {
        perror("gettimeofday");
        exit(-1);
    }
    alarm(measurement_interval);

    for (line_num=0; ; ++line_num) {
        fputs(lines + (line_num % count)*(line_length+2), stdout);
        //puts("Hello World foo bar baz quick brown fox");
    }
}


static void sighandler(int signum) {
    int i_val = line_num;
    double time;
    gettimeofday (&stop,NULL);
    time = (double)stop.tv_sec+(double)stop.tv_usec/1e6 - (double)start.tv_sec-(double)start.tv_usec/1e6;
    fprintf(stderr,"\n\n==END== lines printed: %i, time: %.4f secs, %.2f lines/sec\n",
            i_val, time, (double)i_val/time);
    exit(0);
}
