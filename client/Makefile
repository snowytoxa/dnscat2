# Makefile
# By Ron Bowes
# Created January, 2013
#
# (See LICENSE.md)
#
# Should work for Linux and BSD make.

CC?=gcc
DEBUG_CFLAGS?=-DTESTMEMORY -Werror -O0
RELEASE_CFLAGS?=-Os
CFLAGS?=--std=c89 -I. -Wall -D_DEFAULT_SOURCE -fstack-protector-all -Wformat -Wformat-security -g
LIBS=-pie -Wl,-z,relro,-z,now

# Can't use a '#' in the shell command
VERSION=$(shell egrep '^.define VERSION' dnscat.c | head -n1 | cut -d\" -f2)

OS=$(shell uname -s)
ARCH=$(shell uname -p | sed 's/x86_64/x64/i' | sed 's/i.86/x86/i')

ifeq ($(OS), Linux)
  RELEASE_FILENAME="dnscat2-$(VERSION)-client-$(ARCH)"
else
  RELEASE_FILENAME="dnscat2-$(VERSION)-client-$(OS)-$(ARCH)"
endif

OBJS=controller/packet.o \
		 controller/session.o \
		 controller/controller.o \
		 drivers/driver.o \
		 drivers/command/driver_command.o \
		 drivers/command/command_packet.o \
		 drivers/command/command_packet_stream.o \
		 drivers/driver_console.o \
		 drivers/driver_exec.o \
		 drivers/driver_ping.o \
		 libs/buffer.o \
		 libs/dns.o \
		 libs/log.o \
		 libs/memory.o \
		 libs/select_group.o \
		 libs/tcp.o \
		 libs/types.o \
		 libs/udp.o \
		 tunnel_drivers/driver_dns.o \

DNSCAT_DNS_OBJS=${OBJS} dnscat.o

all: dnscat
	@echo "*** Build complete! Run 'make debug' to build a debug version!"

debug: CFLAGS += $(DEBUG_CFLAGS)
debug: dnscat
	@echo "*** Debug build complete"

release: CFLAGS += ${RELEASE_CFLAGS}
release: clean dnscat
	strip dnscat
	tar -cjf ${RELEASE_FILENAME}.tar.bz2 dnscat
	@echo "*** Release compiled: `pwd`/${RELEASE_FILENAME}"
	@echo "*** By the way, did you update the version number in the server?"

remove:
	rm -f /usr/local/bin/dnscat

uninstall: remove

clean:
	-rm -f *.o *.exe *.stackdump dnscat tcpcat test driver_tcp driver_dns
	-rm -f controller/*.o drivers/*.o libs/*.o tunnel_drivers/*.o tunnel_drivers/dns/*.o
	-rm -rf win32/Debug/
	-rm -rf win32/Release/
	-rm -rf win32/*.ncb
	-rm -rf win32/*.sln
	-rm -rf win32/*.suo
	-rm -rf win32/*.vcproj.*

dnscat: ${DNSCAT_DNS_OBJS}
	${CC} ${CFLAGS} -o dnscat ${DNSCAT_DNS_OBJS}
	@echo "*** dnscat successfully compiled"
