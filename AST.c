#include "AST.h"
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#define INT_MAX 2147483647

char* leaf[] = {"IF", "ELSE", "WHILE", "RETURN", "DOT", "SEMI", "COMMA", "ASSIGN", 
    "LT", "GT", "LE", "GE", "NE", "EQ", "PLUS", "MINUS", "MUL", "DIV", "AND", 
    "OR", "NOT", "LP", "RP", "LB", "RB", "LC", "RC"};

node* new_node(char* type, char* value, int line, node* t1, node* t2, node* t3, node* t4, node* t5, node* t6, node* t7) {
	node* tree = (node*)malloc(sizeof(node));
    if (strcmp(type, "Empty") == 0) return NULL;
	else    tree->type = type;
    if (value != NULL) {
        char* buffer = (char*)malloc(sizeof(char)*strlen(yytext));
        strcpy(buffer, yytext);
        tree->value = buffer;
    } else  tree->value = value;
    tree->line = line;
    // printf("New node type : %s, value: %s, line: %d\n", tree->type, tree->value, tree->line);
	tree->t1 = t1;
	tree->t2 = t2;
	tree->t3 = t3;
	tree->t4 = t4;
	tree->t5 = t5;
	tree->t6 = t6;
	tree->t7 = t7;
	return tree;
}

void print_tree(struct node* tree, int indent) {
    // printf("Printing tree...\n");
    // printf("Tree node type %s, value %s\n", tree->type, tree->value);
	if (tree == NULL) { printf("Nullpointer, exit.\n"); return; }
	for (int i = 0; i < indent; ++i)	printf("  ");
	if (strcmp(tree->type, "INT") == 0)	printf("INT: %s\n", tree->value);
	else if (strcmp(tree->type, "FLOAT") == 0)	printf("FLOAT: %s\n", tree->value);
	else if (strcmp(tree->type, "CHAR") == 0)	printf("CHAR: %s\n", tree->value);
	else if (strcmp(tree->type, "STRING") == 0)	printf("STRING: %s\n", tree->value);
	else if (strcmp(tree->type, "STRUCT") == 0)	printf("STRUCT: %s\n", tree->value);
	else if (strcmp(tree->type, "TYPE") == 0)	printf("TYPE: %s\n", tree->value);
    else if (strcmp(tree->type, "ID") == 0) printf("ID: %s\n", tree->value);
	else {
        for (int i = 0; i < 27; ++i) {
            if (strcmp(tree->type, leaf[i]) == 0) {
                printf("%s\n", tree->type);
                return;
            }
        }
        printf("%s (%d)\n", tree->type, tree->line);
    }
    // printf("List has been printed, going next.\n");
	if (tree->t1 != NULL)   print_tree(tree->t1, indent+1);
	if (tree->t2 != NULL)   print_tree(tree->t2, indent+1);
	if (tree->t3 != NULL)   print_tree(tree->t3, indent+1);
	if (tree->t4 != NULL)   print_tree(tree->t4, indent+1);
	if (tree->t5 != NULL)   print_tree(tree->t5, indent+1);
	if (tree->t6 != NULL)   print_tree(tree->t6, indent+1);
	if (tree->t7 != NULL)   print_tree(tree->t7, indent+1);
}