#include <stdio.h>
#include <stdlib.h>
#include <signal.h>
#include <unistd.h>
#include <sys/time.h>

#include <pcap.h>

// pcap_open_live timeout
static const unsigned pcap_timeout = 500;

// interval in usec between report outputs
static const unsigned report_interval = 1000000;


static unsigned long long bytes_count = 0;

static void packet_cb(u_char *args, const struct pcap_pkthdr *header, const u_char *packet) {
    bytes_count += header->len;
}


static struct timeval last_time = { .tv_sec=0, .tv_usec=0 }, curr_time = { .tv_sec=0, .tv_usec=0 };

static unsigned long long last_bytes_count = 0;

static void maybe_report() {
    gettimeofday(&curr_time, NULL);
    const unsigned long dt =
        1000000 * curr_time.tv_sec + curr_time.tv_usec
      - 1000000 * last_time.tv_sec - last_time.tv_usec;

    if (curr_time.tv_sec > 0 && dt > report_interval) {
        unsigned bps = 1000000 * (bytes_count - last_bytes_count) / dt;
        printf("%u bytes/s, %llu bytes total\n", bps, bytes_count);

        last_bytes_count = bytes_count;
        last_time = curr_time;
    }
}

int main(int argc, const char *argv[]) {
    char *dev, errbuf[PCAP_ERRBUF_SIZE];
    bpf_u_int32 mask;		/* The netmask of our sniffing device */
    bpf_u_int32 net;		/* The IP of our sniffing device */

    pcap_t *handle;

    if (argc < 2) {
        fprintf(stderr, "usage: %s <pcap filter expression>\n", argv[0]);
        exit(1);
    }

    //const char *filter = "host 192.168.142.7 and tcp and port 22";
    const char *filter = argv[1];
    struct bpf_program filter_program;
    
    dev = pcap_lookupdev(errbuf);
    if (dev == NULL) {
        fprintf(stderr, "Couldn't find default device: %s\n", errbuf);
        exit(1);
    }

    if (pcap_lookupnet(dev, &net, &mask, errbuf) == -1) {
        fprintf(stderr, "Can't get netmask for device %s\n", dev);
        net = 0;
        mask = 0;
    }

    handle = pcap_open_live(dev, 100, 0, pcap_timeout, errbuf);
    if (handle == NULL) {
        fprintf(stderr, "Couldn't open device %s: %s\n", dev, errbuf);
        exit(2);
    }

    if (pcap_compile(handle, &filter_program, filter, 0, net) == -1) {
        fprintf(stderr, "Couldn't compile filter '%s': %s\n", filter, pcap_geterr(handle));
        return(2);
    }
    if (pcap_setfilter(handle, &filter_program) == -1) {
        fprintf(stderr, "Couldn't install filter '%s': %s\n", filter, pcap_geterr(handle));
        return(2);
    }

    fprintf(stderr, "Sniffing on device %s ...\n", dev);

    maybe_report();
    while (1) {
        pcap_dispatch(handle, -1, packet_cb, NULL);
        
        // TODO we're losing any packets that arrive between pcap_dispatch calls (and maybe_report's running time
        // also depends on stdoud's performance.
        // To avoid that, we'd probably have to use pcap_loop and either SIGALRM or a 2nd thread for reporting.
        
        maybe_report();
    }

    return(0);
}
