all: compiler

parser.tab.c parser.tab.h: parser.y
	bison -v -d parser.y

lex.yy.c: lexer.l parser.tab.h
	flex lexer.l

hashtbl.o: extra/hashtbl.c extra/hashtbl.h
	gcc -o extra/hashtbl.o -c extra/hashtbl.c

compiler: lex.yy.c parser.tab.c parser.tab.h lexer_util.c hashtbl.o
	gcc parser.tab.c lex.yy.c lexer_util.c extra/hashtbl.o -lm -g

clean:
	rm a.out parser.tab.c parser.tab.h lex.yy.c extra/hashtbl.o
	rm parser.output