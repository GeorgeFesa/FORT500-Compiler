#!/bin/bash

flex lexer.l
gcc lex.yy.c util.c -lfl -lm
if [[ $1 -eq "1" ]]; then
	./a.out fort500tests/fort500test1.f
elif [[ $1 -eq "2" ]]; then
	./a.out fort500tests/fort500test2.f
fi
