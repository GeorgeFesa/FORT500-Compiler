all: compiler

parser.tab.c parser.tab.h: parser.y
	bison -v -d parser.y

lex.yy.c: lexer.l parser.tab.h
	flex lexer.l

compiler: lex.yy.c parser.tab.c parser.tab.h util.c
	gcc -g parser.tab.c lex.yy.c util.c -lm

# hashtbl.o: extra/hashtbl.c extra/hashtbl.h
# 	gcc extra/hashtbl.o -c extra/hashtbl.c

clean:
	rm a.out parser.tab.c parser.tab.h lexer.yy.c
	rm parser.output