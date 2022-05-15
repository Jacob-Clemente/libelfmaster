# Build Stage
FROM --platform=linux/amd64 ubuntu:20.04 as builder

## Install build dependencies.
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y cmake

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y autoconf

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y g++

## Add source code to the build stage.
ADD . /libelfmaster
WORKDIR /libelfmaster

RUN ./configure
RUN make

WORKDIR /libelfmaster/examples

## TODO: ADD YOUR BUILD INSTRUCTIONS HERE.
RUN gcc -O2 -g elfparse.c ../src/libelfmaster.a -o elfparse

#Package Stage
FROM --platform=linux/amd64 ubuntu:20.04

## TODO: Change <Path in Builder Stage>
COPY --from=builder /libelfmaster/examples/elfparse /
