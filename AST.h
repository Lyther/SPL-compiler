#ifndef AST_H
#define AST_H

extern char* yytext;

typedef struct node {
    char* type;
    char* value;
    int lineno;
    struct node* t1;
    struct node* t2;
    struct node* t3;
    struct node* t4;
    struct node* t5;
    struct node* t6;
    struct node* t7;
} node;

node* new_node(char* type, char* value, int lineno, node* t1, node* t2, node* t3, node* t4, node* t5, node* t6, node* t7);

void print_tree(struct node* root, int indent);

#endif