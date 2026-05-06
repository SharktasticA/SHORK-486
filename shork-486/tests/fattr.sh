#!/bin/sh

touch fattr_test
setfattr -n user.hw1 -v "Hello world #1" fattr_test
setfattr -n user.hw2 -v "Hello world #2" fattr_test
getfattr -d fattr_test
