#!/bin/sh

#    Copyright
#    (c) 2020 Marc Sune <marcdevel@gmail.com>
#
#    Permission to use, copy, modify, and distribute this software for any
#    purpose with or without fee is hereby granted, provided that the above
#    copyright notice and this permission notice appear in all copies.
#
#    THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
#    WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
#    MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
#    ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
#    WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
#    ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
#    OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

#Do not delete
set -e

#wget Retries
WGET_N_RETRIES=30
WGET_WAIT_RETRIES_S=10

#Don't pollute /
mkdir -p /tmp
cd /tmp

#Dependencies (not fulfilled by Dockerfile)
git clone https://github.com/akheron/jansson
cd jansson && rm -rf ./.git && autoreconf -i && ./configure && make && sudo make install && cd ..

git clone https://github.com/edenhill/librdkafka
cd librdkafka && rm -rf ./.git && ./configure && make && sudo make install && cd ..

git clone https://github.com/alanxz/rabbitmq-c
cd rabbitmq-c && rm -rf ./.git && mkdir build && cd build && cmake -DCMAKE_INSTALL_LIBDIR=lib .. && sudo cmake --build . --target install && cd .. && cd ..

git clone --recursive https://github.com/maxmind/libmaxminddb 
cd libmaxminddb && rm -rf ./.git && ./bootstrap && ./configure && make && sudo make install && cd ..

git clone -b 3.2-stable https://github.com/ntop/nDPI
cd nDPI && rm -rf ./.git && ./autogen.sh && ./configure && make && sudo make install && sudo ldconfig && cd ..

wget -t $WGET_N_RETRIES --waitretry=$WGET_WAIT_RETRIES_S --no-check-certificate https://github.com/zeromq/libzmq/releases/download/v4.3.2/zeromq-4.3.2.tar.gz
tar xfz zeromq-4.3.2.tar.gz
cd zeromq-4.3.2 && ./configure && make && sudo make install && cd ..

wget -t $WGET_N_RETRIES --waitretry=$WGET_WAIT_RETRIES_S --no-check-certificate https://archive.apache.org/dist/avro/avro-1.9.2/c/avro-c-1.9.2.tar.gz
tar xfz avro-c-1.9.2.tar.gz
cd avro-c-1.9.2 && mkdir build && cd build && cmake .. && make && sudo make install && cd .. && cd ..

git clone https://github.com/confluentinc/libserdes
cd libserdes && rm -rf ./.git && ./configure && make && sudo make install && cd ..

git clone https://github.com/redis/hiredis
cd hiredis && rm -rf ./.git && make && sudo make install && cd ..

#Make sure dynamic linker is up-to-date
ldconfig
