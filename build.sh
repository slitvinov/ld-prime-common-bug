#!/bin/sh

gfortran $FCFLAGS -c small.f -o small.o
gfortran $FCFLAGS -c main.f -o main.o
gfortran $FCFLAGS $LDFLAGS main.o small.o -o test

./test
