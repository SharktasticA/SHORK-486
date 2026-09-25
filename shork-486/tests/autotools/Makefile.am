ACLOCAL_AMFLAGS = -I m4

noinst_LTLIBRARIES = libshork.la
libshork_la_SOURCES = src/libshork.c src/libshork.h

noinst_PROGRAMS = shorkauto
shorkauto_SOURCES = src/main.c
shorkauto_LDADD = libshork.la
