/**
 * Benchmark program for linear reading from files or block devices
 * (hard drives, CDs, DVDs, USB storage etc.). Sample output for a HD:
 * hdabench.png
 *
 * (c) Olaf Klischat 2007
 *
 */

//probably Linux-specific parts: BLKGETSIZE ioctl,

#define _GNU_SOURCE
// http://www.titov.net/2006/01/02/using-o_largefile-or-o_direct-on-linux/

#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdint.h>
#include <sys/mount.h>
#include <sys/time.h>
#include <time.h>
#include <errno.h>


static void usage() {
    fprintf(stderr, "usage: benchmark_read [-s<start>] [-l<length>] [-b<size>] filename\n\n");
    fprintf(stderr, "benchmark linear reading in file (or block device) named filename\n");
    fprintf(stderr, "from start to start+length-1.\n");
    fprintf(stderr, "size is the size (in bytes) of the memory buffer to be allocated internally\n");
    fprintf(stderr, "for reading from the file. Defaults to 1MiB; must be a multiple\n");
    fprintf(stderr, "of the system's page size.\n");
    fprintf(stderr, "start defaults to 0, length to (length of the file)-start.\n");
    fprintf(stderr, "start must be a multiple of the sector size (512).\n");
    fprintf(stderr, "length will automatically be aligned to the next smaller multiple of size.\n");
    fprintf(stderr, "\nOutput data to stdout as a gnuplot-compatible script\n");
    fprintf(stderr, "\nWhen redirecting the output to a file, make sure that file\n");
    fprintf(stderr, "does not reside on the physical device you're benchmarking\n");
    exit(1);
}

typedef u_int64_t usecs_t;
typedef u_int64_t fileoffset_t;

static fileoffset_t get_file_size(int fd);

int main(int argc, char **argv) {
    fileoffset_t start = 0;
    fileoffset_t length = 0;
    unsigned bufsize = 1024*1024;
    char *filename = NULL;

    char **opt;
    int iopt;
    for (iopt=1, opt=argv+1; iopt<argc; iopt++, opt++) {
        fileoffset_t fofftmp;
        unsigned utmp;
        if (1 == sscanf(*opt, "-s%Lu", &fofftmp)) {
            start = fofftmp;
        } else if (1 == sscanf(*opt, "-l%Lu", &fofftmp)) {
            length = fofftmp;
        } else if (1 == sscanf(*opt, "-b%u", &utmp)) {
            bufsize = utmp;
        } else if ((*opt)[0] != '-' && !filename) {
            filename = *opt;
        } else {
            fprintf(stderr, "error: unknown option: %s\n\n", *opt); usage();
        }
    }

    if (!filename) {
        fprintf(stderr, "error: missing filename.\n", *opt); usage();
    }

    int fd = open(filename, O_RDONLY|O_DIRECT|O_LARGEFILE);
    if (-1==fd) {
        perror("open"); exit(1);
    }

    fileoffset_t size = get_file_size(fd);
    fprintf(stderr, "file size: %Lu bytes\n",size);

    if (start>=size) {
        fprintf(stderr, "error: start >= file size\n"); exit(1);
    }
    if (length==0) length = size-start;
    if (start+length-1 >= size) {
        fprintf(stderr, "error: start+length-1 >= file size (would read past end of file)\n"); exit(1);
    }

    unsigned pagesize = getpagesize();
    if (bufsize<pagesize || bufsize%pagesize != 0) {
        fprintf(stderr, "error: buffer size (%u) must be a multiple of the page size (%u)\n",bufsize,pagesize);
        exit(1);
    }
    if (start%512 != 0) {
        fprintf(stderr, "error: start (%u) must be a multiple of the sector size (512)\n",start);
        exit(1);
    }

    length = length/bufsize*bufsize;
    u_int64_t n_datapoints = length/bufsize;

    fprintf(stderr, "running with: filename=%s, start=%Lu, length=%Lu, buffer size=%u (%Lu measurements / data points)\n",
            filename,start,length,bufsize,n_datapoints);

    char *realbuf = malloc(bufsize+pagesize);
    if (!realbuf) { perror("malloc"); exit(1); }
    //align to page boundaries
    char *buf = (char*)((((int unsigned)realbuf+pagesize-1)/pagesize)*pagesize);
    memset(buf, 0, bufsize);   //make sure it's mapped (does that really work?)

    if (-1 == lseek(fd, start, SEEK_SET)) {
        perror("lseek"); exit(1);
    }

    fprintf(stderr, "running measurements...\n");

    printf("\
set xlabel \"offset from start (MiB)\n\
set ylabel \"transfer rate (MiB/sec)\"\n\
set title \"linear reading performance of %s\"\n\
plot '-' title \"\" with points\n\
", filename);

    ssize_t n_read=0;
    static struct timeval t0, t1;
    usecs_t time;
    double MiBperSecond;
    u_int64_t i_read;
    for (i_read=0; i_read<n_datapoints; i_read++) {
        gettimeofday(&t0,NULL);
        n_read = read(fd, buf, bufsize);  //TODO: is this guaranteed to really read all the bytes?
        gettimeofday(&t1,NULL);
        if (n_read != bufsize) {
            fprintf(stderr, "error reading chunk no. %Lu: %s\n", i_read, strerror(errno));
            continue;
        }
        time = t1.tv_sec*1e6 + t1.tv_usec - t0.tv_sec*1e6 - t0.tv_usec;
        MiBperSecond = (double)bufsize/time*1000000/1024/1024;
        
        printf("%Lu %lf\n", (start + i_read*bufsize)/1024/1024, MiBperSecond);
    }

    printf("e\n");

    free(realbuf);
    close(fd);
}


static fileoffset_t get_file_size(int fd) {
    // http://www.linuxproblem.org/art_20.html
    // http://lists.freebsd.org/pipermail/freebsd-hackers/2006-June/016925.html

    unsigned long result;
    if (!ioctl(fd, BLKGETSIZE, &result)) {
        return (fileoffset_t)result*512;
    } else {
        //not a block device; assume it's an ordinary file
        struct stat s;
        if (!fstat(fd, &s)) {
            return (fileoffset_t)(s.st_size);
        } else {
            perror("fstat");
            exit(1);
        }
    }
}
