#ifndef STATEMENT_H
#define STATEMENT_H

typedef struct type {
    char *name;
    char *t;
    int is_val, is_array, is_struct, is_fun;
    struct array *arr;
    struct statement *stmt;
} type;

typedef struct array {
    struct type *base;
    int length;
} array;

typedef struct statement {
    char *name;
    struct type *t;
    struct statement *next;
} statement;

#endif