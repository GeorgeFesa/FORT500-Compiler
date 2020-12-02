#!/bin/bash

flex lexer.l
gcc lex.yy.c util.c -lfl -lm

test="fort500test$1.f"

if [ ! -f fort500tests/"$test" ]; then
	echo "No such test."
	exit 1
fi

./a.out fort500tests/"$test"