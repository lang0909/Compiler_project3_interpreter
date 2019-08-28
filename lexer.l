%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "inter.h"
#include "y.tab.h"
void yyerror(char *);
%}

%%

"while"	return WHILE;
"if" return IF;
"else" return ELSE;
"print"	return PRINT;
[a-zA-Z_][a-zA-Z0-9_]*	{strcpy(yylval.id,yytext); return ID;}
0|[1-9][0-9]*	{yylval.int_value = atoi(yytext);   return INTEGER;}
(0|[1-9][0-9]*)\.(0*|[0-9]*[1-9])   {yylval.real_value = atof(yytext);	return DOUBLE;}
[-()<>=+*/;{}]	return *yytext;
">="	return GE;
"<="	return LE;
"=="	return EQ;
"!="	return NE;
[ \t\n]+    ;
.   yyerror("lexical error");

%%

int yywrap(void)
{
    return 1;
}
