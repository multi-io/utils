LIBS=-lpcap

default: log-pcap

log-pcap: main.o
	$(CC) $< $(LIBS) -o $@

clean:
	rm -f *.o log-pcap

