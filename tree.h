#ifndef _TREE_H_
#define _TREE_H_

#include<cstdio>
#include<cstdlib>
#include<cstring>
#include<cstdarg>
#include<iostream>
#include<string>
using namespace std;

extern char *yytext;
extern int yylineno;

struct gramTree {
    string content;
    string name;
    int line;
    struct gramTree *left;
    struct gramTree *right;
};

extern struct gramTree *root;

struct gramTree* create_tree(string name, int num,...);
void eval(struct gramTree *head,int leavel);
char* my_substring(char* s, int begin, int end);
void freeGramTree(gramTree* node);

#endif