#include <stdio.h>
#include <stdlib.h>
#include <signal.h>
#include <unistd.h>

#include <pcap.h>


static void packet_cb(u_char *args, const struct pcap_pkthdr *header, const u_char *packet) {
    printf("caplen=%u len=%u\n", header->caplen, header->len);
}


int main() {
    char *dev, errbuf[PCAP_ERRBUF_SIZE];
    bpf_u_int32 mask;		/* The netmask of our sniffing device */
    bpf_u_int32 net;		/* The IP of our sniffing device */

    pcap_t *handle;

    const char *filter = "tcp and port 22";
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

    handle = pcap_open_live(dev, BUFSIZ, 0, 1000, errbuf);
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
    pcap_loop(handle, -1, packet_cb, NULL);

    return(0);
}
