lexer:	    lexer.l ya.y
	flex lexer.l
	bison -d -b y ya.y
	gcc y.tab.c lex.yy.c -ly -lfl

.PHONY:	clean
clean:
	rm -rf *.tab.c *.tab.h *.yy.c a.out
