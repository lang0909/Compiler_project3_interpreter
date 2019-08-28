%{
#include<stdio.h>
#include<stdlib.h>
#include"inter.h"

Node * opr(int opr_type, Node * pa1, Node * pa2, Node * pa3);
Node * id(char * value3);
Node * con(int value1);
Node * real(double value2);
int find_symbol_index(char * s);
void save_symbol(char * s1);
double cal(Node * p);
void freeNode(Node * p);
int yylex();
extern FILE * yyin;
int symbol_index = -1;
void yyerror(char *msg);
SYMBOL_TABLE symbol_table[20];
%}

%union{
    int int_value;
    double real_value;
    char id[20];
    Node * ptr;
};

%token <int_value> INTEGER
%token <real_value> DOUBLE
%token <id> ID
%token WHILE IF PRINT ELSE

%left GE LE EQ NE '>' '<'
%left '+' '-'
%left '*' '/'
%right UMINUS

%type <ptr> statement expression statement_list 

%%

start:
    line    {exit(0);}
    ;

line:
    line statement  {cal($2);	freeNode($2);}
    |
    ;

statement:
    ';'	{$$ = opr(';',NULL,NULL,NULL);}
    | expression';' {$$ = $1;}
    | PRINT expression';'   {$$ = opr(PRINT,$2,NULL,NULL);}
    | ID '=' expression';'  {$$ = opr('=',id($1),$3,NULL);}
    | WHILE '(' expression ')' statement    {$$ = opr(WHILE,$3,$5,NULL);}
    | IF '(' expression ')' statement ELSE statement	{$$ = opr(IF,$3,$5,$7);}
    | '{' statement_list '}'	{$$ = $2;}
    ;

statement_list:
    statement	{$$ = $1;}
    | statement_list statement	{$$ = opr(';',$1,$2,NULL);}
    ;

expression:
    INTEGER {$$ = con($1);}
    | DOUBLE {$$ = real($1);}
    | ID    {$$ = id($1);}
    | '-' expression %prec UMINUS   {$$ = opr(UMINUS,$2,NULL,NULL);}
    | expression '+' expression	    {$$ = opr('+',$1,$3,NULL);}
    | expression '-' expression	    {$$ = opr('-',$1,$3,NULL);}
    | expression '*' expression	    {$$ = opr('*',$1,$3,NULL);}
    | expression '/' expression	    {$$ = opr('/',$1,$3,NULL);}
    | expression '<' expression	    {$$ = opr('<',$1,$3,NULL);}
    | expression '>' expression	    {$$ = opr('>',$1,$3,NULL);}
    | expression GE expression	    {$$ = opr(GE,$1,$3,NULL);}
    | expression LE expression	    {$$ = opr(LE,$1,$3,NULL);}
    | expression NE expression	    {$$ = opr(NE,$1,$3,NULL);}
    | expression EQ expression	    {$$ = opr(EQ,$1,$3,NULL);}
    | '(' expression ')'	{$$ = $2;}
    ;

%%

Node * con(int value1)
{
    Node * temp;
    temp = malloc(sizeof(Node));

    temp->type = typeCon;
    temp->con.conValue = value1;

    return temp;
}

Node * real(double value2)
{
    Node * temp;
    temp = malloc(sizeof(Node));

    temp->type = typeReal;
    temp->real.realValue = value2;

    return temp;
}

Node * id(char* value3)
{
    Node * temp;
    temp = malloc(sizeof(Node));

    temp->type = typeId;
    strcpy(temp->id.str,value3);
    if(find_symbol_index(value3)==-1)
    {
	save_symbol(temp->id.str);
	temp->id.index = symbol_index;
    }
    else
	temp->id.index = find_symbol_index(value3);
    return temp;
}

Node * opr(int opr_type, Node * pa1, Node * pa2, Node * pa3)
{
    Node * temp;
    temp = malloc(sizeof(Node));

    temp->type = typeOpr;
    temp->opr.optn = opr_type;
    temp->opr.list[0] = pa1;
    temp->opr.list[1] = pa2;
    temp->opr.list[2] = pa3;

    return temp;
}

void freeNode(Node * temp1)
{
    if(temp1 == NULL)
	return;
    if(temp1->type == typeOpr)
    {
	for(int i=0;i<3;i++)
	{
	    freeNode(temp1->opr.list[i]);
	}
    }
    free(temp1);
}

void yyerror(char * msg)
{
    fprintf(stderr, "%s\n", msg);
}

int main(int argc,char * argv[])
{
    yyin = fopen(argv[1],"r");
    yyparse();
    return 0;
}

int find_symbol_index(char * s)
{
    for(int k=0;k<20;k++)
    {
	if(strcmp(s,symbol_table[k].symbol)==0)
	    return k;
    }
    return -1;
}

void save_symbol(char *s1)
{
    strcpy(symbol_table[++symbol_index].symbol,s1);
}


double cal(Node * p)
{
    if(p==NULL)
	return 0;
    switch(p->type)
    {
	case typeCon: 
	    return p->con.conValue;
	case typeReal:
	    return p->real.realValue;
	case typeId:
	    return symbol_table[p->id.index].rv;
	case typeOpr:
	switch(p->opr.optn)
	{
	    case WHILE:
		while(cal(p->opr.list[0]))
		    cal(p->opr.list[1]);
		return 0;
	    case IF:
		if(cal(p->opr.list[0]))
		    cal(p->opr.list[1]);
		else
		    cal(p->opr.list[2]);
		return 0;
	    case PRINT:
		if(cal(p->opr.list[0])-(int)cal(p->opr.list[0]) == 0)
		    printf("%d\n",(int)cal(p->opr.list[0]));
		else
		    printf("%f\n",cal(p->opr.list[0]));
		return 0;
	    case ';':
		cal(p->opr.list[0]);
		return cal(p->opr.list[1]);
	    case '=':
		return symbol_table[p->opr.list[0]->id.index].rv= cal(p->opr.list[1]);
	    case UMINUS:
		return -cal(p->opr.list[0]);
	    case '+':
		return cal(p->opr.list[0]) + cal(p->opr.list[1]);
	    case '-':
		return cal(p->opr.list[0]) - cal(p->opr.list[1]);
	    case '*':
		return cal(p->opr.list[0]) * cal(p->opr.list[1]);
	    case '/':
		if(cal(p->opr.list[1])==0)
		{
		    yyerror("divide by zero");
		    return 0;
		}
		return cal(p->opr.list[0]) / cal(p->opr.list[1]);
	    case '<':
		return cal(p->opr.list[0]) < cal(p->opr.list[1]);
	    case '>':
		return cal(p->opr.list[0]) > cal(p->opr.list[1]);
	    case GE:
		return cal(p->opr.list[0]) >= cal(p->opr.list[1]);
	    case LE:
		return cal(p->opr.list[0]) <= cal(p->opr.list[1]);
	    case NE:
		return cal(p->opr.list[0]) != cal(p->opr.list[1]);
	    case EQ:
		return cal(p->opr.list[0]) == cal(p->opr.list[1]);
	}
    }
}
