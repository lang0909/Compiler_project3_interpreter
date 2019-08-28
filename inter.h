#include<stdio.h>
#include<stdlib.h>
#include<string.h>

typedef enum {typeId, typeCon, typeReal, typeOpr} typeEnum;

typedef struct{
    char str[20];
    int index;
}nodeId;

typedef struct{
    int conValue;
}nodeCon;

typedef struct{
    double realValue;
}nodeReal;

typedef struct{
    int optn;
    struct nodeType * list[2];
}nodeOpr;

typedef struct nodeType{
    typeEnum type;

    union{
	nodeId id;
	nodeCon con;
	nodeReal real;
	nodeOpr opr;
    };
}Node;

typedef struct{
    char symbol[20];
    double rv;
}SYMBOL_TABLE;

extern SYMBOL_TABLE symbol_table[20];
extern int symbol_index;
