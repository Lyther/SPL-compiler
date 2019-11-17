#ifndef PARSER_H
#define PARSER_H

#include "statement.h"
#include "AST.h"

void parser_program(node *root);

void parser_ext_def_list(node *root);

void parser_ext_def(node *root);

void parser_comp_st(node *root, type *t);

void parser_stmt(node *root, type *t);

void parser_stmt_list(node *root, type *t);

void parser_ext_dec_list(node *root, type *t);

type *parser_specifier(node *root);

type *parser_exp(node *root);

type *parser_fun_dec(node *root, type *t);

statement *parser_def_list(node *root, statement *stmt);

statement *parser_def(node *root, statement *stmt);

statement *parser_dec_list(node *root, statement *stmt, type *t);

statement *parser_dec(node *root, type *t);

statement *parser_var_dec(node *root, type *t);

statement *parser_var_list(node *root, statement *stmt);

statement *parser_param_dec(node *root, statement *stmt);

void parser_error(node *root, int type, char *message);

int parser_same(type *t1, type *t2);

#endif