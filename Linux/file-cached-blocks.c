// adapted from http://insights.oetiker.ch/linux/fadvise/

#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <sys/mman.h>

int main(int argc, char *argv[]) {
    int fd;
    struct stat file_stat;
    void *file_mmap;
    unsigned char *mincore_vec;
    size_t page_size = getpagesize();
    size_t page_index;

    fd = open(argv[1],0);
    fstat(fd, &file_stat);
    file_mmap = mmap((void *)0, file_stat.st_size, PROT_NONE, MAP_SHARED, fd, 0);
    mincore_vec = calloc(1, (file_stat.st_size+page_size-1)/page_size);
    mincore(file_mmap, file_stat.st_size, mincore_vec);
    printf("Cached Blocks of %s: ",argv[1]);
    unsigned n_pages = 1 + file_stat.st_size/page_size;
    unsigned n_cached = 0;
    for (page_index = 0; page_index < n_pages; page_index++) {
        if (mincore_vec[page_index]&1) {
            printf("%lu ", (unsigned long)page_index);
            n_cached++;
        }
    }
    printf("\nSummary: %u of %u pages (%.2lf%%) cached.\n", n_cached, n_pages, (double)n_cached*100/n_pages );
    free(mincore_vec);
    munmap(file_mmap, file_stat.st_size);
    close(fd);
    return 0;
}
